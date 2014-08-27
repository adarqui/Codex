module Codex.Lib.Game.Player (
 Player (..),
 PlayerType (..),
 HumanT (..),
 ComputerT (..)
) where

import Codex.Lib.Science.Gender
 (Gender (..))

import Codex.Lib.Game.Match
 (Stats (..))

data Player a = Player {
 _id :: Int,
 _type :: PlayerType,
 _stats :: Stats,
 _history :: [a]
} deriving (Show, Read, Eq)

data PlayerType =
 Human HumanT | Computer ComputerT
 deriving (Show, Read, Eq)

data HumanT = HumanT {
 _nickName :: String,
 _gender :: Gender
} deriving (Show, Read, Eq)

data ComputerT = ComputerT {
 _nodeName :: String
} deriving (Show, Read, Eq)
