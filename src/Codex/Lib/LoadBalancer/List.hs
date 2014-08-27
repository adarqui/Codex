{-# LANGUAGE RecordWildCards #-}
{-
 The most useless thing i've ever written
-}
module Codex.Lib.LoadBalancer.List (
 Wrapper,
 lb'new,
 lb'peek,
 lb'get'strategy,
 lb'set'strategy,
 lb'get'rot,
 lb'set'rot,
 lb'get'shards,
 lb'add'shards,
 lb'del'shards,
 lb'drain,
 lb'recv,
 lb'send
) where

import Codex.Lib.LoadBalancer.Strategies

import Control.Concurrent
import Control.Concurrent.MVar

import Data.List

data Communication a =
   Send a
 | Drain (MVar [a])
 | Recv (MVar [a])
 | Peek (MVar [[a]])
 | SetStrategy Strategy
 | GetStrategy (MVar Strategy)
 | GetRot (MVar Int)
 | SetRot Int
 | GetShards (MVar Int)
 | AddShards [[a]]
 | DelShards [Int]
 | AddAutoScale [[(Int,Int)] -> Bool]
 | DelAutoScale
 | Empty

data Wrapper a = Wrapper {
 _mv :: MVar (Communication a),
 _list :: [[a]],
 _shards :: Int,
 _shardsMin :: Int,
 _rot :: Int,
 _strategy :: Strategy,
 _auto :: [[(Int,Int)] -> Bool]
}

lb'new :: Strategy -> [[a]] -> IO (Wrapper a)
lb'new strat l = do
 mv <- newEmptyMVar
 let w = Wrapper { _mv = mv, _list = l, _shards = length l, _shardsMin = length l, _rot = 0, _strategy = strat, _auto = [] }
 tid <- forkIO $ lb'daemon w
 return w

-- auto scale out
lb'daemon :: Wrapper a -> IO ()
lb'daemon w = do
 d <- takeMVar $ _mv w
 let slen = shards'len (_list w)
 let shouldScale = foldl' (\cur f -> (f (shards'len (_list w))) : cur) [False] (_auto w)
 case (any (==True) shouldScale) of
  True -> lb'daemon' (shard'put w) d
  False -> lb'daemon' w d
 lb'daemon' w d

-- scale back
lb'daemon' :: Wrapper a -> Communication a -> IO ()
lb'daemon' w@Wrapper{..} d = do
 lb'daemon'' w d

-- run through rest of communications
lb'daemon'' :: Wrapper a -> Communication a -> IO ()
lb'daemon'' w@Wrapper{..} d = do
 case d of
  Peek a' -> putMVar a' _list >> lb'daemon w
  SetStrategy strategy -> lb'daemon w { _strategy = strategy }
  GetStrategy a'-> putMVar a' _strategy >> lb'daemon w
  GetRot a' -> putMVar a' _rot >> lb'daemon w
  SetRot rot -> lb'daemon w { _rot = rotate _rot _shards }
  GetShards a' -> putMVar a' _shards >> lb'daemon w
  AddShards a' -> lb'daemon $ add'shards w a'
  DelShards a' -> lb'daemon $ del'shards w a'
  Drain a' -> do
   (d',w') <- balance'drain w []
   putMVar a' d'
   lb'daemon w'
  Recv a' -> do
   (d',w') <- balance'get w
   putMVar a' d'
   lb'daemon w'
  Send a' -> do
   (_,w') <- balance'put w a'
   lb'daemon w'
  _ -> lb'daemon w

add'shards :: Wrapper a -> [[a]] -> Wrapper a
add'shards w@Wrapper{..} shards = w { _list = new_shards, _shards = length new_shards }
 where
  new_shards = _list ++ shards

del'shards :: Wrapper a -> [Int] -> Wrapper a
del'shards w@Wrapper{..} shards =
 case ((_shards - (length sanitized')) > _shardsMin) of
  True -> w { _list = new_shards, _shards = length new_shards, _rot = 0 }
  False -> w
 where
  sanitized = filter (\x -> x < _shards) shards
  sanitized' = take ((length sanitized) - _shardsMin) sanitized
  new_shards = map (\x -> _list !! x) $ filter (\x -> not $ x `elem` sanitized') $ [0..(length _list)-1]

map'list l = map (\x -> (l !! x)) [0..(length l) - 1]

shard'put :: Wrapper a -> Wrapper a
shard'put w@Wrapper{..} = w { _list = _list ++ [[]], _shards = _shards + 1 }

balance'put :: Wrapper a -> a -> IO ([[a]], Wrapper a)
balance'put w@Wrapper{..} e = do
 let slen = shards'len _list
 return $ case _strategy of
  Robin -> let new_list = insert' (0,_rot) _list e in (new_list, w {_list = new_list, _rot = rotate _rot _shards })
  Most -> let new_list = insert' (maximum slen) _list e in (new_list, w { _list = new_list })
  _ -> (_list, w)

rotate rot shards = if rot >= (shards-1) then 0 else (rot+1)

balance'drain :: Wrapper a -> [a] -> IO ([a], Wrapper a)
balance'drain w@Wrapper{..} list = do
 let slen = shards'len _list
 case (total'len slen) of
  0 ->  balance'get w >>= (\(_,w') -> return (list,w))
  _ -> balance'get w >>= (\(list',w') -> balance'drain w' (list' ++ list))

balance'get :: Wrapper a -> IO ([a], Wrapper a)
balance'get w@Wrapper{..} = do
 let slen = shards'len _list
 return $ case _strategy of
  Random -> ([],w)
  Robin -> let (sub_list,new_list) = remove (maximum slen) _list in (sub_list,w{_list=new_list})
  Least -> let (sub_list,new_list) = remove (fakeMin (filter (\(x,y) -> x /= 0) slen) (0,0)) _list in (sub_list,w{_list=new_list})
  Most -> let (sub_list,new_list) = remove (maximum slen) _list in (sub_list,w{_list=new_list})
  Source -> ([],w)
  Sticky -> ([],w)
  Nop -> ([],w)
  _ -> ([],w)

remove :: (Int,Int) -> [[a]] -> ([a],[[a]])
remove (0,_) l = ([],l)
remove n [[]] = ([],[[]])
remove (len,idx) l@(x:xs) = (e, reorder l idx)
 where
  e = [head $ l !! idx]
  t = (tail (l !! idx))

fakeMin [] def = def
fakeMin l _ = foldl1 (\(x,y) (x',y') -> if (x < y) then (x',y') else (x,y)) l

insert' :: (Int,Int) -> [[a]] -> a -> [[a]]
insert' (len,idx) l@(x:xs) elm = reorder'put elm l idx
 where
  e = [head $ l !! idx]

total'len :: [(Int,Int)] -> Int
total'len slen = foldl' (\accum (len,idx) -> len + accum) 0 slen

shards'len :: [[a]] -> [(Int,Int)]
shards'len [[]] = [(0,0)]
shards'len l = map (\n -> (length (l !! n),n)) [0..(length l)-1]

reorder list idx = (tail (list !! idx)) : (map (\n -> list !! n) $ filter (/= idx) [0..(length list)-1])
reorder'put e list idx = ((list !! idx) ++ [e]) : (map (\n -> list !! n) $ filter (/= idx) [0..(length list)-1])

lb'peek :: Wrapper a -> IO [[a]]
lb'peek w@Wrapper{..} = do
 backchan <- newEmptyMVar
 lb'send' w (Peek backchan)
 takeMVar backchan

lb'get'strategy :: Wrapper a -> IO Strategy
lb'get'strategy w@Wrapper{..} = do
 backchan <- newEmptyMVar
 lb'send' w (GetStrategy backchan)
 takeMVar backchan

lb'set'strategy :: Wrapper a -> Strategy -> IO ()
lb'set'strategy w@Wrapper{..} strat = do
 lb'send' w (SetStrategy strat)

lb'get'rot :: Wrapper a -> IO Int
lb'get'rot w@Wrapper{..} = do
 backchan <- newEmptyMVar
 lb'send' w (GetRot backchan)
 takeMVar backchan

lb'set'rot :: Wrapper a -> Int -> IO ()
lb'set'rot w@Wrapper{..} n = do
 lb'send' w (SetRot n)

lb'get'shards :: Wrapper a -> IO Int
lb'get'shards w@Wrapper{..} = do
 backchan <- newEmptyMVar
 lb'send' w (GetShards backchan)
 takeMVar backchan

lb'add'shards :: Wrapper a -> [[a]] -> IO ()
lb'add'shards w@Wrapper{..} shards = do
 lb'send' w (AddShards shards)

lb'del'shards :: Wrapper a -> [Int] -> IO ()
lb'del'shards w@Wrapper{..} shards = do
 lb'send' w (DelShards shards)

lb'send' :: Wrapper a -> Communication a -> IO ()
lb'send' w@Wrapper{..} c = do
 putMVar _mv c

lb'drain :: Wrapper a -> IO [a]
lb'drain w@Wrapper{..} = do
 backchan <- newEmptyMVar
 lb'send' w (Drain backchan)
 takeMVar backchan

lb'recv :: Wrapper a -> IO [a]
lb'recv w@Wrapper{..} = do
 backchan <- newEmptyMVar
 lb'send' w (Recv backchan)
 takeMVar backchan

lb'send :: Wrapper a -> a -> IO ()
lb'send w@Wrapper{..} a = do
 lb'send' w (Send a)
 return ()
