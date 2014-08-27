{-# LANGUAGE ScopedTypeVariables #-}
module Codex.Lib.Network.TCP.Client (
 PortID (..),
 runTCPClient
) where

import Prelude hiding (catch)
import Network
import System.IO
import Control.Monad
import Control.Exception as E

runTCPClient :: String -> PortID -> (Handle -> IO ()) -> IO Handle
runTCPClient host port cb =
 withSocketsDo $ do
  h <- connectTo host port
  cb h `catch` disconnected `finally` disconnect h
  return h
  where
   disconnected (ex :: IOException) = do
    return ()
   disconnect h = do
    hClose h
    return ()
