module Codex.Meetup.M1.RPS.Include (
 RPS (..)
) where

data RPS =
 Rock | Paper | Scissors
 deriving (Show, Read, Eq, Enum)
