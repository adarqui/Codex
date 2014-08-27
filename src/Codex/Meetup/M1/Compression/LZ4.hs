{-# LANGUAGE OverloadedStrings #-}
module Codex.Meetup.M1.Compression.LZ4 (
 compress,
 decompress,
 compressFile,
 decompressFile
) where

import qualified Codex.Lib.Compression as C
 (Compression (..))

import Data.List
 (stripPrefix)

import Data.Maybe
 (fromJust)

import qualified Data.ByteString as B
import qualified Codec.Compression.LZ4 as LZ4

prefix = ".lz4"

instance C.Compression B.ByteString where
 compress = compress
 compressFile = compressFile
 decompress = decompress
 decompressFile = decompressFile

compress :: B.ByteString -> Either String B.ByteString
compress = Right . fromJust . LZ4.compressHC

compressFile :: String -> IO (Either String B.ByteString)
compressFile s = do
 case (stripPrefix (reverse prefix) (reverse s)) of
  Just _ -> return $ Left $ prefix ++ " already exists"
  Nothing -> do
   content <- fmap (fromJust . LZ4.compressHC) (B.readFile s)
   B.writeFile (s++prefix) content
   return $ Right content

decompress :: B.ByteString -> Either String B.ByteString
decompress = Right . fromJust . LZ4.decompress

decompressFile :: String -> IO (Either String B.ByteString)
decompressFile s = do
 case (stripPrefix (reverse prefix) (reverse s)) of
  Nothing -> return $ Left "Incorrect suffix"
  Just s' -> do
   content <- fmap (fromJust . LZ4.decompress) (B.readFile s)
   B.writeFile (reverse s') content
   return $ Right content
