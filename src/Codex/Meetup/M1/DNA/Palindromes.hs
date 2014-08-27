module Codex.Meetup.M1.DNA.Palindromes (
 everything,
 largest,
 smallest,
 greaterThan,
 lesserThan
) where

import Codex.Lib.List
 (sublistMin, sublistMax, sublistBy)

import Codex.Lib.Collect
 (Collect (..))

import Codex.Lib.Patterns
 (palindromes)

import Codex.Lib.Science.DNA
 (DNA (..))

everything :: [DNA] -> [[DNA]]
everything = palindromes

largest :: [DNA] -> [[DNA]]
largest = sublistMax . palindromes

smallest :: [DNA] -> [[DNA]]
smallest = sublistMin . palindromes

greaterThan :: Int -> [DNA] -> [[DNA]]
greaterThan len_min list =
 sublistBy
  (\elm _ -> if (length elm > len_min) then KEEP else DISCARD)
  len_min
  $ everything list

lesserThan :: Int -> [DNA] -> [[DNA]]
lesserThan len_max list =
 sublistBy
  (\elm _ -> if (length elm < len_max) then KEEP else DISCARD)
  len_max
  $ everything list
