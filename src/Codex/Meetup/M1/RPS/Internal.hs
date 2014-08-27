module Codex.Meetup.M1.RPS.Internal (
 play,
-- runRPSServer
) where

import Codex.Meetup.M1.RPS.Include
import Codex.Lib.Game.Match
import Codex.Lib.Random

import Control.Monad
import qualified Game.Tournamentx as T
import qualified Data.Map as M


-- testing stuff
import Control.Monad.State (State, get, put, modify, execState, gets)

randomHand :: RPS
randomHand = toEnum (rangeRandomUnsafe 0 2) :: RPS

upd :: [T.Score] -> T.GameId -> State T.Tournament ()
upd sc id = do
  t <- get
--  let p1 = rangeRandomUnsafe 0 100
--  let p2 = rangeRandomUnsafe 0 100
  let p1 = rangeRandomUnsafe 0 2
  let p2 = rangeRandomUnsafe 0 2
  put $ T.score id [p1, p2] t
  return ()
{-
  let p1 = randomHand
  let p2 = randomHand
  case (play p1 p2) of
--   Draw -> upd sc id
   _ -> do
--    put $ T.score id [fromEnum p1, fromEnum p2] t
    put $ T.score id [1, 2] t
    return ()
-}

manipDuel :: [T.GameId] -> State T.Tournament ()
manipDuel = mapM_ (upd [100,10])

testcase :: IO ()
testcase = do
 let t = tourney
 print $ T.keys t
--  testor $ execState (manipDuel (M.keys t)) t

testor :: T.Tournament -> IO ()
testor t = do
 maybe (print "no results") (mapM_ print) rs
 where
  ms = T.keys t
  rs = T.results t

tourney = T.tournament (T.Duel T.Double) 24

k t =  execState (manipDuel (T.keys t)) t

testcase2 :: IO ()
testcase2 = do
 let t = tourney
 testor $ k t
 print "done"



{-
import Codex.Lib.Network.TCPServer

defaultRPSServer :: TCPServer Int
defaultRPSServer = TCPServer {
 _data = 1,
 _port = 6660,
 _connected = connected,
 _disconnected = disconnected,
 _interrupted = interrupted
}

disconnected :: TCPServer a -> ID -> IO ()
disconnected tcp client = return ()

connected :: TCPServer a -> ID -> IO ()
connected tcp client = return ()

interrupted :: TCPServer a -> ID -> IO ()
interrupted tcp client = return ()


runRPSServer :: IO ()
runRPSServer = do
 return ()
-}

{-
 player1 vs player2, everything relative to player1
-}
play :: RPS -> RPS -> MatchResult
play Rock Scissors = Win
play Rock Paper = Lose
play Paper Rock = Win
play Paper Scissors = Lose
play Scissors Rock = Lose
play Scissors Paper = Win
play _ _ = Draw
