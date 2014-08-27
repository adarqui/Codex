module Codex.Lib.Network.TCPServer (
 TCPServer (..),
 TCPInternal,
 TCPConnection (..),
 Message (..),
 ID,
 runTCPServer,
 destroyTCPServer
) where

import Prelude hiding (catch)
import Network
import System.IO
import Control.Monad
import Control.Exception as E
import Control.Concurrent
import Control.Concurrent.MVar

type ID = Int

data Message = Message ID | Broadcast [ID] | Wall

data TCPConnection = TCPConnection {
 _id :: ID,
 _conn :: Handle
}

data TCPServer a = TCPServer {
 _data :: a,
 _port :: PortNumber,
 _disconnect :: TCPServer a -> ID -> IO (),
 _connected :: TCPServer a -> ID -> IO (),
 _disconnected :: TCPServer a -> ID -> IO (),
 _interrupted :: TCPServer a -> ID -> IO (),
 _incoming :: TCPServer a -> ID -> String -> IO ()
-- _send :: TCPServer a -> Message -> String -> IO ()
}

data TCPInternal a = TCPInternal {
 __sock :: Socket,
 __server :: TCPServer a,
 __connected :: TCPServer a -> TCPConnection -> IO (),
 __disconnected :: TCPServer a -> TCPConnection -> IO (),
 __interrupted :: TCPServer a -> TCPConnection -> IO (),
 __data :: TCPServer a -> TCPConnection -> String -> IO (),
 __connections :: [TCPConnection],
 __counter :: Int
}

runTCPServer :: TCPServer a -> IO (TCPInternal a)
runTCPServer tcp =
 withSocketsDo $ do
  let int = TCPInternal { __server = tcp }
  sock <- listenOn $ PortNumber (_port $ __server int)
  let int' = int { __sock = sock, __connections = [], __counter = 0 }
  forkIO $ accept' int'
  return int'
--  where
--   interrupted = \s ex -> do
--    let err = show (ex :: SomeException)
--    sClose s
--    putStrLn "Closing"
--    sClose s

destroyTCPServer :: TCPInternal a -> IO ()
destroyTCPServer int = do
 sClose $ __sock int

accept' :: TCPInternal a -> IO ()
accept' int = do
 let counter = (__counter int) + 1
 let int' = int { __counter = counter }
 (conn,_,_) <- accept (__sock int)
 let client = TCPConnection { _id = counter, _conn = conn }
 hSetBuffering conn NoBuffering
-- forkIO $
--  talk client `catch` disconnected `finally` disconnect conn
 accept' int'
{-
 where
  disconnected = \ex -> do
   let err = show (ex :: IOException)
   hPutStrLn stderr $ "Disconnected: " ++ err
-}
 
disconnected :: TCPInternal a -> SomeException -> IO ()
disconnected int ex = do
 return ()

interrupted :: TCPInternal a -> SomeException -> IO ()
interrupted int ex = do
 return ()
 
disconnect :: Handle -> IO ()
disconnect conn = do
 hClose conn
 putStrLn $ "Disconnecting"

{-
talk :: TCPConnection -> IO ()
talk client = do
 hPutStrLn (_conn client) "hello"
-}

send :: TCPInternal a -> Message -> String -> IO ()
send int Wall s = do
 putStrLn $ "Wall" ++ s
send int (Broadcast l@(x:xs)) s = do
 putStrLn $ "Broadcast " ++ show l ++ ": " ++ s
send int (Message id') s = do
 putStrLn $ "Message " ++ show id' ++ ": " ++ s
