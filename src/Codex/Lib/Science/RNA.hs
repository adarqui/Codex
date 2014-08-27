module Codex.Lib.Science.RNA (
 RNA (..)
) where

data RNA = G | A | C | U deriving (Show, Read, Eq, Enum)
