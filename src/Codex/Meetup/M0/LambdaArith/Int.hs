module Meetup.M0.LambdaArith.Int (
 Int (..)
) where

import Prelude hiding (id, pred, succ, Int (..))

data Int =
 P Int | O | S Int
 deriving (Show, Read)

id :: Int -> Int
id i = i
