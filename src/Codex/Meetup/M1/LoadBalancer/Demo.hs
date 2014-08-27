module Codex.Meetup.M1.LoadBalancer.Demo (
 Strategies (..),
 AutoScale (..),
 LoadBalancer (..)
) where

data Strategies =
   Random
 | Robin
 | Least
 | Most
 | Source
 | Sticky
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
