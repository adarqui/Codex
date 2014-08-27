{-# LANGUAGE ScopedTypeVariables #-}
module Codex.Lib.Network.TCP.Proxy (
 PortID (..),
 runTCPProxy
) where

import Codex.Lib.Network.TCP.Client

import Prelude hiding (catch)
import Network
import System.IO
import Control.Monad
import Control.Concurrent
import Control.Exception as E

runTCPProxy :: Handle -> BufferMode -> String -> PortID -> IO ()
runTCPProxy hSource bMode host port = do
 putStrLn "proxy"
 runTCPClient host port $ \hTarget -> loopTarget hSource hTarget bMode `catch` disconnected `finally` disconnect hSource hTarget
 return ()
 where
  disconnected (ex :: IOException) = do
   putStrLn "disconnected"

disconnect :: Handle -> Handle -> IO ()
disconnect hSource hTarget = do
 putStrLn "disconnect"
 hClose hSource
 hClose hTarget

loopTarget :: Handle -> Handle -> BufferMode -> IO ()
loopTarget hSource hTarget bMode = do
  hSetBuffering hTarget bMode
  loopTarget' hSource hTarget
  loopSource hSource hTarget

loopSource :: Handle -> Handle -> IO ()
loopSource hSource hTarget = do
 src <- hGetLine hSource
 hPutStrLn hTarget src
 loopSource hSource hTarget

loopTarget' :: Handle -> Handle -> IO ()
loopTarget' hSource hTarget = do
 _ <- forkIO $ forever $ do
  dst <- hGetLine hTarget
  hPutStrLn hSource dst
 return ()

{-
 withSocketsDo $ do
  h <- connectTo host port
  cb h `catch` disconnected `finally` disconnect h
  where
   disconnected (ex :: IOException) = do
    return ()
   disconnect h = do
    hClose h
    return ()
-}
