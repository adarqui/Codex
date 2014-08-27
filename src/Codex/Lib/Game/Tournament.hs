module Codex.Lib.Game.Tournament (
 Tournament (..)
) where

data Tournament =
 SingleElimination | BestOf Int
 deriving (Show, Read)
