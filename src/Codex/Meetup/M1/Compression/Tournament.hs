{-# LANGUAGE OverloadedStrings #-}
module Codex.Meetup.M1.Compression.Tournament (
 runCompressionTournament,
 simpleCompressionTournament
) where

import Codex.Lib.Random

import Control.Monad
import qualified Game.Tournamentx as T
import qualified Data.Map as M

import Control.Monad.State (State, get, put, modify, execState, gets)

import qualified Codex.Meetup.M1.Compression.Raw as Raw
import qualified Codex.Meetup.M1.Compression.Inflate as Inflate
import qualified Codex.Meetup.M1.Compression.RLE as RLE
import qualified Codex.Meetup.M1.Compression.GZip as GZip
import qualified Codex.Meetup.M1.Compression.BZip as BZip
import qualified Codex.Meetup.M1.Compression.LZ4 as LZ4

import qualified Data.ByteString.Lazy.Char8 as B
import qualified Data.ByteString.Char8 as BI

import Data.Int
import System.IO.Unsafe
import Data.Either

lz4Transformer bs =
 case (LZ4.compress bs) of
  (Left err) -> "eh"
  (Right bs') -> B.fromChunks [bs']

lz4ReverseTransformer bs =
  b
 where
  b = Right $ lz4Transformer (BI.concat $ B.toChunks bs)
 

type CompressionTourney = (B.ByteString, T.Tournament)
compressionMap =
 M.fromList [(1, Raw.compress), (2, Inflate.compress), (3, RLE.compress), (4, GZip.compress), (5, BZip.compress), (6, lz4ReverseTransformer)]

compressionNames = ["Raw","Inflate","RLE","GZip","BZip","LZ4"]

simpleCompressionTournament bs =
 map (\i -> (compressionNames !! i, len !! i)) $ [0..(length len)-1]
 where
  len =  map (\s -> B.length s)$ rights $ map (\idx -> ((M.!) compressionMap idx) bs) [1..6]


upd :: [T.Score] -> T.GameId -> State CompressionTourney ()
upd sc gid = do
 (bs, t) <- get
 let (p1:p2:[]) = T.players $ (M.!) (T.games t) gid in
   put $ (bs, T.score gid (scoreCompression p1 p2 bs) t)
 return ()

scoreCompression p1 p2 bs =
 case (p1'res' > p2'res') of
  True -> [p2'res', p1'res']
  False -> [p1'res', p2'res']
 where
  Right p1'res = ((M.!) compressionMap p1) bs
  Right p2'res = ((M.!) compressionMap p2) bs
  p1'res' = fromIntegral $ B.length p1'res
  p2'res' = fromIntegral $ B.length p2'res
 

manipDuel :: [T.GameId] -> State CompressionTourney ()
manipDuel = mapM_ (upd [0,0])

testor :: (B.ByteString, T.Tournament) -> IO ()
testor (bs, t) = do
 maybe (print "no results") (mapM_ print) rs
 where
  ms = T.keys t
  rs = T.results t

tourney :: B.ByteString -> Int -> CompressionTourney
tourney bs numCompetitors = (bs, T.tournament (T.Duel T.Double) numCompetitors)

runCompressionTournament :: B.ByteString -> IO ()
runCompressionTournament bs = do
-- testor $ execState (get >>= \(x,y) -> put (bs, manipDuel (T.keys y))) $ tourney bs 6
-- testor $ execState (get >>= \(x,y) -> put $ manipDuel (T.keys y)) $ tourney bs 6
 testor $ execState (get >>= \l@(x,y) -> manipDuel (T.keys y)) $ tourney bs 6
 print "done"
