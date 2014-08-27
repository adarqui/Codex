module Codex.Lib.Network.TCP.Stresser (
 PortID (..),
 stressTCPServer
) where

import Codex.Lib.Network.TCP.Client
import Codex.Lib.Random

import Prelude hiding (catch)
import Network
import System.IO
import Control.Monad
import Control.Concurrent
import Control.Exception as E

stressTCPServer :: Int -> Int -> Int -> IO () -> IO ()
stressTCPServer threads connections iter thunk = do
 putStrLn $ "testing connections and disconnects: threads="++show threads++", connections="++show connections++", iter: "++show iter
 forM_ [1..threads] (\_ -> forkIO $ stressTCPServer' connections iter thunk)
 return ()
 
stressTCPServer' :: Int -> Int -> IO () -> IO ()
stressTCPServer' connections iter thunk = do
 forM_ [1..connections] (\thread -> forkIO $ replicateM_ iter $ stressTCPServer'' thread thunk)

stressTCPServer'' :: Int -> IO () -> IO ()
stressTCPServer'' thread thunk = do
 thunk
