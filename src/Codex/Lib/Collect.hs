module Codex.Lib.Collect (
 Collect (..),
 compareToCollect,
) where

data Collect =
 NEW | KEEP | DISCARD
 deriving (Show, Read, Eq)

compareToCollect :: Ordering -> Collect
compareToCollect o =
 case o of
  GT -> NEW
  EQ -> KEEP
  LT -> DISCARD
