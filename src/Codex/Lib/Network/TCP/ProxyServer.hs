module Codex.Lib.Network.TCP.ProxyServer (
 PortID (..),
 runProxyServer
) where

import Codex.Lib.Network.TCP.Server
import Codex.Lib.Network.TCP.Proxy

import Prelude hiding (catch)
import Network
import System.IO
import Control.Monad
import Control.Exception as E
import Control.Concurrent
import Control.Concurrent.MVar

runProxyServer :: PortNumber -> String -> PortID -> IO TCPServer
runProxyServer local_port remote_host remote_port = do
-- let serv = buildTCPServer local_port (-1) $ \h id' -> do (forkIO $ runTCPProxy h NoBuffering remote_host remote_port) >> return ()
 let serv = buildTCPServer local_port (-1) r
 runTCPServer serv

r h id' = do
 runTCPProxy h NoBuffering "localhost" $ PortNumber 1337
 return ()
