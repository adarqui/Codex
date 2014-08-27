module Codex.Lib.LoadBalancer.Strategies (
 Strategy (..),
 AutoScale (..),
 LoadBalancer (..)
) where

data Strategy =
   Random
 | Robin
 | Least
 | Most
 | Source
 | Sticky
 | Nop
 deriving (Show, Read, Eq, Enum)

data AutoScale =
   ScaleOut
 | ScaleBack
 deriving (Show, Read, Eq, Enum)

data Health =
   Up
 | Down
 deriving (Show, Read, Eq, Enum)

data LoadBalancer = LoadBalancer {
} deriving (Show, Read)
