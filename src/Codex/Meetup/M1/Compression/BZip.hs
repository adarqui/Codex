{-# LANGUAGE OverloadedStrings #-}
module Codex.Meetup.M1.Compression.BZip (
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
import qualified Codec.Compression.BZip as BZip

prefix = ".bz2"

instance C.Compression B.ByteString where
 compress = compress
 compressFile = compressFile
 decompress = decompress
 decompressFile = decompressFile

compress :: B.ByteString -> Either String B.ByteString
compress = Right . BZip.compress

compressFile :: String -> IO (Either String B.ByteString)
compressFile s = do
 case (stripPrefix (reverse prefix) (reverse s)) of
  Just _ -> return $ Left $ prefix ++ " already exists"
  Nothing -> do
   content <- fmap BZip.compress (B.readFile s)
   B.writeFile (s++prefix) content
   return $ Right content

decompress :: B.ByteString -> Either String B.ByteString
decompress = Right . BZip.decompress

decompressFile :: String -> IO (Either String B.ByteString)
decompressFile s = do
 case (stripPrefix (reverse prefix) (reverse s)) of
  Nothing -> return $ Left "Incorrect suffix"
  Just s' -> do
   content <- fmap BZip.decompress (B.readFile s)
   B.writeFile (reverse s') content
   return $ Right content
