{-# LANGUAGE DeriveGeneric #-}
module Codex.Lib.Geo.World2 (
 Location (..),
 parse
) where

import Codex.Lib.List
 (splitBy)

import System.IO
import Control.Monad
import Data.Aeson
import GHC.Generics

import qualified Data.Map as M

data Location = Location {
 _continent :: String,
 _country2 :: String,
 _country3 :: String
} deriving (Show, Read, Generic)

instance ToJSON Location
instance FromJSON Location

parse :: FilePath -> IO [Location]
parse name = do
 contents <- readFile name
 let parsed = map (\l -> line2rec $ splitBy ' ' l) $ lines contents
 return parsed

line2rec :: [String] -> Location
line2rec (continent:country2:country3:rest) =
 Location {
  _continent = continent,
  _country2 = country2,
  _country3 = country3
 }

--byContinents :: [Location] -> [Location]

