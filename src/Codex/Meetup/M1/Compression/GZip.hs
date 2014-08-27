{-# LANGUAGE OverloadedStrings #-}
module Codex.Meetup.M1.Compression.GZip (
 compress,
 decompress,
 compressFile,
 decompressFile
) where

import qualified Codex.Lib.Compression as C
 (Compression (..))

import Data.List
 (stripPrefix)

import qualified Data.ByteString.Lazy as B
import qualified Codec.Compression.GZip as GZip

prefix = ".gz"

instance C.Compression B.ByteString where
 compress = compress
 compressFile = compressFile
 decompress = decompress
 decompressFile = decompressFile

compress :: B.ByteString -> Either String B.ByteString
compress = Right . GZip.compress

compressFile :: String -> IO (Either String B.ByteString)
compressFile s = do
 case (stripPrefix (reverse prefix) (reverse s)) of
  Just _ -> return $ Left $ prefix ++ " already exists"
  Nothing -> do
   content <- fmap GZip.compress (B.readFile s)
   B.writeFile (s++prefix) content
   return $ Right content

decompress :: B.ByteString -> Either String B.ByteString
decompress = Right . GZip.decompress

decompressFile :: String -> IO (Either String B.ByteString)
decompressFile s = do
 case (stripPrefix (reverse prefix) (reverse s)) of
  Nothing -> return $ Left "Incorrect suffix"
  Just s' -> do
   content <- fmap GZip.decompress (B.readFile s)
   B.writeFile (reverse s') content
   return $ Right content
