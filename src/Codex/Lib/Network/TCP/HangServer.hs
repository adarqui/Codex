module Codex.Lib.Network.TCP.HangServer (
 runHangServer,
 destroyHandServer
) where

import Codex.Lib.Network.TCP.Server
import Codex.Lib.Random

import Prelude hiding (catch)
import Network
import System.IO
import Control.Monad
import Control.Exception as E
import Control.Concurrent
import Control.Concurrent.MVar

runHangServer :: PortNumber -> Int -> IO TCPServer
runHangServer port maxConnections  = do
 let serv = buildTCPServer port maxConnections cb'hang
 runTCPServer serv

destroyHandServer = destroyTCPServer

cb'hang :: Handle -> Int -> IO ()
cb'hang h id' = do
 to <- rangeRandom 100000 1000000
 hPutStrLn h $ "You are " ++ show id' ++ ". Sleeping for " ++ show to ++ " ms."
 threadDelay to
 return ()
