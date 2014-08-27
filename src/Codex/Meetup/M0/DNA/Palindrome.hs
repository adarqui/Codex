module Meetup.M0.DNA.Palindrome (
 subseq
) where

import Meetup.Lib.DNA
import Meetup.Lib.Patterns

import Data.List
import Data.Maybe
import Data.Function

subseq :: [DNA] -> [[DNA]]
subseq l = nub $ catMaybes $ map maybePalindrome $ nub $ subsequences l

subseqMax :: [DNA] -> [DNA]
subseqMax l = maximumBy (compare `on` length) $ subseq l

--subseqMax' :: [DNA] -> [DNA]
--subseqMax' l = snd $ maximum $ map (\x -> (length x, x)) $ subseq l
