module Codex.Lib.Server.MVar.Testing (
 test'connect'and'disconnect 
) where

import Codex.Lib.Random
import Codex.Lib.Server.MVar
import Control.Monad
import Control.Concurrent
import Control.Concurrent.MVar
import Control.Concurrent.Chan
import qualified Data.Map as M
import qualified Data.Vector.Unboxed as V

test'connect'and'disconnect :: Server -> Int -> Int -> Int -> IO ()
test'connect'and'disconnect serv threads connections iter = do
 putStrLn $ "testing connections and disconnects: threads="++show threads++", connections="++show connections++", iter: "++show iter
 forM_ [1..threads] (\_ -> forkIO $ test'connect'and'disconnect' serv connections iter)
 return ()

test'connect'and'disconnect' :: Server -> Int -> Int -> IO ()
test'connect'and'disconnect' serv connections iter = do
 forM_ [1..connections] (\thread -> forkIO $ replicateM_ iter $ test'connect'and'disconnect'' serv thread iter)

test'connect'and'disconnect'' :: Server -> Int -> Int -> IO ()
--test'connect'and'disconnect'' _ _ 0 = do
-- putStrLn "done."
-- return ()
test'connect'and'disconnect'' serv thread iter = do
 putStrLn $ "testing connections: thread="++show thread
 client <- send'event'connection serv
 r <- rangeRandom 100000 1000000
 threadDelay r
 case client of
  Nothing -> return ()
  (Just client') -> do send'event'disconnect serv (_id client')
-- test'connect'and'disconnect'' serv thread (iter-1)
