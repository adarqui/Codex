{-# LANGUAGE MultiParamTypeClasses, TypeSynonymInstances, FlexibleInstances #-}
module Codex.Meetup.M1.Compression.RLE (
 compress,
 compressFile,
 decompress,
 decompressFile
) where

import Codex.Lib.List
 (FV (..), frequency)

import qualified Codex.Lib.Compression as C
 (Compression (..))

import qualified Data.ByteString.Lazy as B

prefix = ".rle"

instance C.Compression B.ByteString where
 compress = compress
 compressFile = compressFile
 decompress = decompress
 decompressFile = decompressFile

{-
frequencyBS :: B.ByteString -> B.ByteString
frequencyBS [] = []
frequencyBS l = xs
 where
  x = B.head xs
  xs = B.tail xs
  half'fst = succ $ length $ B.takeWhile (== x) xs
  half'snd = B.dropWhile (== x) xs
-}

compress :: B.ByteString -> Either String B.ByteString
compress bs = Right bs

compressFile :: String -> IO (Either String B.ByteString)
compressFile bs = do
 return $ Left "unimplemented"

decompress :: B.ByteString -> Either String B.ByteString
decompress bs = Right bs

decompressFile :: String -> IO (Either String B.ByteString)
decompressFile bs = do
 return $ Left "unimplemented"

compress' :: (Eq a) => [a] -> [FV a]
compress' z = frequency z

decompress' :: [FV a] -> [a]
decompress' [] = []
decompress' ((n, x):xs) = (take n (repeat x)) ++ decompress' xs
