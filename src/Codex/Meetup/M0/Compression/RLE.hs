module Meetup.M0.Compression.RLE (
 encode,
 decode
) where

import Meetup.Lib.List

encode :: (Eq a) => [a] -> [FV a]
encode z = frequency z

decode :: [FV a] -> [a]
decode [] = []
decode ((n, x):xs) = (take n (repeat x)) ++ decode xs
