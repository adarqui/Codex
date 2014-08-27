module Codex.Lib.Network.EchoServer (
 runEchoServer,
 destroyEchoServer
) where

import Codex.Lib.Network.TCPServer

defaultEchoServer :: TCPServer Int
defaultEchoServer = TCPServer {
 _data = 1,
 _port = 7,
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

runEchoServer :: IO (TCPInternal Int)
runEchoServer = do
 es <- runTCPServer defaultEchoServer
 return es

destroyEchoServer :: TCPInternal Int -> IO ()
destroyEchoServer = destroyTCPServer
