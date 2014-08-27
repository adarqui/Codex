module Codex.Lib.Game.Difficulty (
 Difficulty (..)
) where

data Difficulty =
 Novice | Intermediate | Advanced | Expert
 deriving (Show, Read, Eq, Ord, Enum)
