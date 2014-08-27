module Meetup.M0.GuessEq (
 guess
) where

import Data.List

type EqVal = ([Int], Int)

data Op a = Add a a | Sub a a | Mul a a | Div a a deriving (Show, Read)

operations :: (Fractional a) => [(a -> a -> a)]
operations = [(+),(-),(*),(/)]

guess :: EqVal -> [Int]
guess (nums, result) = guess' nums result

guess' :: [Int] -> Int -> [Int]
guess' nums result = nums
