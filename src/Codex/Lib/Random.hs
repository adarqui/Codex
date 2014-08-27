module Codex.Lib.Random (
 rangeRandom,
 rangeRandomUnsafe
) where

import System.Random
import System.IO.Unsafe (unsafePerformIO)

rangeRandom :: (Num n, Random n, Integral n) => n -> n -> IO n
rangeRandom x y = do
 randomRIO (x,y)

rangeRandomUnsafe :: (Num n, Random n, Integral n) => n -> n -> n
rangeRandomUnsafe x y = do
 unsafePerformIO $ rangeRandom x y

{-
modRandom :: (Num n, Random n, Integral n) => n -> IO n
modRandom n = do
 r <- randomIO
 return $ r `mod` n
-}
