module Codex.Lib.Game.Match (
 MatchResult (..),
 Stats (..)
) where

data MatchResult =
 Lose | Win | Draw
 deriving (Show, Read, Eq, Enum)

data Stats = Stats {
 _wins, _losses, _draws :: Int
} deriving (Show, Read, Eq)
