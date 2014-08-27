module Codex.Lib.Network.TCP.EchoServer (
 runEchoServer
) where

import Codex.Lib.Network.TCP.Server

import Prelude hiding (catch)
import Network
import System.IO
import Control.Monad
import Control.Exception as E
import Control.Concurrent
import Control.Concurrent.MVar

runEchoServer :: IO TCPServer
runEchoServer = do
 let serv = buildTCPServer 7 (-1) cb'echo
 runTCPServer serv

cb'echo :: Handle -> Int -> IO ()
cb'echo h id' = do
 l <- hGetLine h
 hPutStrLn h l
 cb'echo h id'
