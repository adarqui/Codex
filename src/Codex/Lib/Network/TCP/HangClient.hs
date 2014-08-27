module Codex.Lib.Network.TCP.HangClient (
 PortID (..),
 runTCPHangClient,
 hangClient
) where

import Codex.Lib.Network.TCP.Client
import Codex.Lib.Random

import Prelude hiding (catch)
import Network
import System.IO
import Control.Monad
import Control.Concurrent
import Control.Exception as E

runTCPHangClient :: String -> PortID -> IO ()
runTCPHangClient host port = do
 runTCPClient host port $ \h -> hangClient h
 return ()

hangClient :: Handle -> IO ()
hangClient h = do
 to <- rangeRandom 100000 1000000
 threadDelay to
 hClose h
 return ()
