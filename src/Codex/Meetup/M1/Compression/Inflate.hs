{-# LANGUAGE OverloadedStrings #-}
module Codex.Meetup.M1.Compression.Inflate (
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

prefix = ".raw"

instance C.Compression B.ByteString where
 compress = compress
 compressFile = compressFile
 decompress = decompress
 decompressFile = decompressFile

compress :: B.ByteString -> Either String B.ByteString
compress bs = Right $ B.concat [bs,bs]

compressFile :: String -> IO (Either String B.ByteString)
compressFile s = do
 case (stripPrefix (reverse prefix) (reverse s)) of
  Just _ -> return $ Left $ prefix ++ " already exists"
  Nothing -> do
   content <- B.readFile s
   B.writeFile (s++prefix) content
   return $ Right content

decompress :: B.ByteString -> Either String B.ByteString
decompress bs = Right $ B.take half bs
 where
  half = round $ (fromIntegral (B.length bs)) / 2

decompressFile :: String -> IO (Either String B.ByteString)
decompressFile s = do
 case (stripPrefix (reverse prefix) (reverse s)) of
  Nothing -> return $ Left "Incorrect suffix"
  Just s' -> do
   content <- B.readFile s
   B.writeFile (reverse s') content
   return $ Right content
