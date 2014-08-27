module Codex.Meetup.M1.WhoseOperator.IsIt (
 who
) where

import Codex.Lib.List
 (parengen)

import Data.List

who n = parengen n 0 '(' ')' ""

data Op =
   Num Int
 | PlaceHolder
 deriving (Show, Read)

data Operator a =
   Add
 | Sub
 | Mul
 | Div
 | Val a
 deriving (Show, Read, Eq)

ops :: (Fractional a) => [(a -> a -> a)]
ops = [(+),(-),(*),(/)]

k l = map (intersperse PlaceHolder) $ permutations $ map Num l 


zz :: (Fractional a) => [a] -> [a]
zz l@(a:b:c:d:e) = [ (a' `ops1` b' `ops2` c' `ops3` d')  | (a':b':c':d':e') <- permutations l, ops1 <- ops, ops2 <- ops, ops3 <- ops ]


z :: (Fractional a) => [a] -> [a]
z l@(a:b:c:d:e) = [ (a `ops1` b `ops2` c `ops3` d)  | x <- permutations l, ops1 <- ops, ops2 <- ops, ops3 <- ops ]


z' :: (Fractional a, Eq a) => [a] -> a -> [a]
z' l@(a:b:c:d:e) ans = filter (==ans) $ [ (a `ops1` b `ops2` c `ops3` d)  | x <- permutations l, ops1 <- ops, ops2 <- ops, ops3 <- ops ]


operators = [Add,Sub,Mul,Div]
z'' :: (Fractional a, Eq a) => [a] -> a -> [[Operator a]]
z'' l@(a:b:c:d:e) ans = [ [Val a,ops1,Val b,ops2,Val c,ops3,Val d] | x <- permutations l, ops1 <- operators, ops2 <- operators, ops3 <- operators ]


ops' = [("add",(+)),("sub",(-)),("mul",(*)),("div",(/))]

z''' :: [Double] -> Double -> [(Double, String)]
z''' l@(a:b:c:d:e) ans = filter (\x -> fst x == ans) [((snd ops1) a $ (snd ops2) b $ (snd ops3) c d, (show a ++ " " ++ fst ops1 ++ " " ++ show b ++ " " ++ fst ops2 ++ " " ++ show c ++ " " ++ fst ops3 ++ " " ++ show d)) | ops1 <- ops', ops2 <- ops', ops3 <- ops']



{-
applyOp :: Op -> Int
applyOp (Add x y) = x + y
applyOp (Sub x y) = x - y
applyOp (Mul x y) = x * y
-}

{-
applyOp (Op a b) = case op of
 (Add a b) -> a + b
 (Sub a b) -> a - b
 Mul a b -> a * b
 Div a b -> a / b
-}

{-
apply [] = []
apply (x:xs) = x $ apply xs
-}
