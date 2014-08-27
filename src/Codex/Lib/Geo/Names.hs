{-# LANGUAGE DeriveGeneric #-}
module Codex.Lib.Geo.Names (
 Names (..),
 parseMales,
 parseFemales
) where

import Codex.Lib.List
 (splitBy)

import System.IO
import Control.Monad
import Data.Aeson
import GHC.Generics

import qualified Data.Map as M

data Names = Male String | Female String deriving (Show, Read, Eq, Generic)

instance ToJSON Names
instance FromJSON Names

parseMales :: FilePath -> IO [Names]
parseMales name = parseToks name >>= \toks -> return $ concat $ mapM (\x -> return $ Male x) toks

parseFemales :: FilePath -> IO [Names]
parseFemales name = parseToks name >>= \toks -> return $ concat $ mapM (\x -> return $ Female x) toks

parseToks :: FilePath -> IO [String]
parseToks name = do
 contents <- readFile name
 let parsed = map (\l -> fstTok $ splitBy ' ' l) $ lines contents
 return parsed

fstTok :: [String] -> String
fstTok (name:rest) = name
