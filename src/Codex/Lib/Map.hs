module Codex.Lib.Map (
 deleteMaybe
) where

import qualified Data.Map as M

deleteMaybe :: Ord k => k -> M.Map k a -> Maybe (M.Map k a)
deleteMaybe k m =
 case (sz'original /= sz'new) of
  True -> Just map'new
  False -> Nothing
 where
  sz'original = M.size m
  map'new = M.delete k m
  sz'new = M.size map'new
