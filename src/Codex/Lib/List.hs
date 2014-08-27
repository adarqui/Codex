{-# LANGUAGE ParallelListComp #-}

module Codex.Lib.List (
 FV,
 frequency,
 subseqs,
 sublistMin,
 sublistMax,
 sublistBy,
 splitBy,
 parengen
) where

import Codex.Lib.Collect
 (Collect(..), compareToCollect)

import Data.List

type FV a = (Int, a)

frequency :: (Eq a) => [a] -> [FV a]
frequency [] = []
frequency (x:xs) = (half'fst, x) : (frequency half'snd)
 where
  half'fst = succ $ length $ takeWhile (== x) xs
  half'snd = dropWhile (== x) xs

subseqs :: [a] -> [[a]]
subseqs l = [x | i <- inits l, x <- tails i, not $ null x ]

sublistMax :: [[a]] -> [[a]]
sublistMax l = sublistBy (\list accum_len -> compareToCollect $ compare (length list) accum_len) 0 l

sublistMin :: [[a]] -> [[a]]
sublistMin l = sublistBy (\list accum_len -> compareToCollect $ compare accum_len (length list)) (maxBound :: Int) l

sublistBy :: ([x] -> Int -> Collect) -> Int -> [[x]] -> [[x]]
sublistBy by_fn start_len list =
 filter (\result -> length result > 0) $
  snd $
   foldl
    (\(accum_len, accum_list) elm -> 
     case (by_fn elm accum_len) of
      DISCARD -> (accum_len, accum_list)
      KEEP -> (length elm, elm:accum_list)
      NEW -> (length elm, [elm]))
    (start_len,[[]]) list

splitBy delimiter =
 foldr f [[]] 
 where
  f c l@(x:xs)
   | c == delimiter = []:l
   | otherwise = (c:x):xs

parengen :: Int -> Int -> Char -> Char -> String -> [String]
parengen 0 0 _ _ s = [s]
parengen open close openchr closechr s =
  filter (not . null) $ s'1 ++ s'2
 where
  s'1 = if (open > 0) then (parengen (open-1) (close+1) openchr closechr (s++[openchr])) else [[]]
  s'2 = if (close > 0) then (parengen open (close-1) openchr closechr (s++[closechr])) else [[]]
