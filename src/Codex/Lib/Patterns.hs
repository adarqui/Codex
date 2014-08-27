module Codex.Lib.Patterns (
 isPalindrome,
 maybePalindrome,
 palindromes
) where

import Codex.Lib.List
import Data.List
import Data.Maybe

isPalindrome :: (Eq a) => [a] -> Bool
isPalindrome [] = False
isPalindrome [x] = False
isPalindrome l = isPalindrome' l (reverse l)

isPalindrome' [] [] = True
isPalindrome' (x:xs) (y:ys)
 | x == y = isPalindrome' xs ys
 | x /= y = False

maybePalindrome :: (Eq a) => [a] -> Maybe [a]
maybePalindrome l
 | isPalindrome l = Just l
 | otherwise = Nothing

palindromes:: (Eq a) => [a] -> [[a]]
palindromes l = catMaybes $ map maybePalindrome $ nub $ subseqs l
