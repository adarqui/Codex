module Codex.Lib.Game.Team (
 Team (..)
) where

import Codex.Lib.Game.Player
 (Player (..))

import Codex.Lib.Game.Match
 (Stats (..))

data Team a = Team {
 _name :: String,
 _stats :: Stats,
 _players :: [Player a]
} deriving (Show, Read, Eq)
