{-# LANGUAGE RecordWildCards, ScopedTypeVariables #-}
module Codex.Lib.Network.TCP.Server (
 TCPServer,
 TCPConnection,
 runTCPServer,
 destroyTCPServer,
 buildTCPServer
) where

import Prelude hiding (catch)
import Network
import System.IO
import Control.Monad
import Control.Exception as E
import Control.Concurrent
import Data.IORef

data TCPServer = TCPServer {
 _port :: PortNumber,
 _sock :: Socket,
 _cb :: Handle -> Int -> IO (),
 _connections :: [Handle], 
 _maxConnections :: Int,
 _connected :: IORef Int,
 _counter :: Int
}

data TCPConnection = TCPConnection {
 _id :: Int,
 _conn :: Handle
}

buildTCPServer :: PortNumber -> Int -> (Handle -> Int -> IO ()) -> TCPServer
buildTCPServer port maxConnections cb = TCPServer { _port = port, _maxConnections = maxConnections, _cb = cb }

runTCPServer :: TCPServer -> IO TCPServer
runTCPServer serv@TCPServer{..} =
 withSocketsDo $ do
  sock <- listenOn $ PortNumber _port
  ioref <- newIORef 0
  let serv' = serv { _sock = sock, _connections = [], _connected = ioref, _counter = 0 }
  forkIO $ accept' serv'
  return serv'

destroyTCPServer :: TCPServer -> IO ()
destroyTCPServer serv@TCPServer{..} = do
 sClose _sock
 return ()

accept' :: TCPServer -> IO ()
accept' serv@TCPServer{..} = do
 let counter = _counter + 1
 (conn,_,_) <- accept _sock
 connected <- incr _connected
-- putStrLn $ "connection count: " ++ show connected
 case (connected > _maxConnections && _maxConnections >= 0) of
  True -> do
   disconnect serv conn
   accept' serv
  False -> do
   let client = TCPConnection { _id = 0, _conn = conn }
   hSetBuffering conn NoBuffering
   forkIO $ _cb conn counter `catch` disconnected `finally` disconnect serv conn
   accept' $ serv { _counter = counter }
   where
    disconnected (ex :: IOException) = do
--     hPutStrLn stderr $ "Disconnected"
     return ()

disconnect :: TCPServer -> Handle -> IO ()
disconnect serv@TCPServer{..} h = do
 _ <- decr _connected
 hClose h

incr :: IORef Int -> IO Int
incr ioref = do
 atomicModifyIORef' ioref (\a -> (a+1,a+1))

decr :: IORef Int -> IO Int
decr ioref = do
 atomicModifyIORef' ioref (\a -> (a-1,a-1))

get :: IORef Int -> IO Int
get ioref = do
 atomicModifyIORef' ioref (\a -> (a,a))
