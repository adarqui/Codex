{-# LANGUAGE ParallelListComp #-}
module Codex.Meetup.M1.OlympicRings.Haha (
 drawRings
) where

import Graphics.Ascii.Haha.Terminal
import Graphics.Ascii.Haha.Geometry
import Graphics.Ascii.Haha.Bitmap
import Graphics.Ascii.Haha.Plot
import qualified Graphics.Ascii.Haha.Bitmap as Bm

import Data.List

screen :: Rect Integer
screen = Rect (Point 1 1) (Point 150 40)

view :: Rect Double
view = Rect (Point 1 1) (Point 150 80)

plot :: Bitmap Double Pixel -> String
plot = string False screen (Point 1 1) " " "" . list 0.4 view

drawRings :: IO ()
drawRings = do
 putStr $ move 1 (0::Int)
 putStr $ plot $ apply $ olyRings 25.0 20.0
 return ()

apply [] = empty
apply (x:xs) = x $ apply xs

circle x y r chr color chain = drawCircle (Circle (Point x y) r) 360.0 (Pixel chr color) chain

ys x = take 5 $ cycle [x, x*2]
xs x = take 5 $ map (\i -> x * i * 0.90) [1..5]
colors = [blue, yellow, black, green, red]
symbols = ['-','#','*','$','.']

olyRings x r = [ circle x' y' r chr' color' | x' <- xs x | y' <- ys x | color' <- colors | chr' <- symbols ]

rounder n d = (fromInteger $ round $ n * (10^d)) / (10.0^^d)
-- front back front back, front back front back

{-
orderPoint' (Point x0 y0) (Point x1 y1)
  | y0 > y1   = GT
  | y0 < y1   = LT
  | x0 > x1   = GT
  | x0 < x1   = LT
  | otherwise = EQ

-- Create an ordered list of all pixels in grid.
list' :: (Integral i, RealFrac u) => u -> Rect u -> Bm.Bitmap u p -> [(Point i, p)]
list' m r =
    sortBy (\a b -> orderPoint' (fst a) (fst b))
  . Bm.toList
  . Bm.mapPoints discrete
  . Bm.mapPoints (\(Point x y) -> Point x (y * m))
 ' . Bm.clip r
-}
