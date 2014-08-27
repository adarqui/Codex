{-# LANGUAGE RecordWildCards #-}
module Codex.Lib.Server.MVar (
 Server,
 ID,
 Message (..),
 Event (..),
 Client (..),
 initServer,
 deliverWall,
 deliverBroadcast,
 deliverMessage,
 send'event'connection,
 send'event'disconnect,
 send'event'debug
) where

import Codex.Lib.Map

import Control.Monad
import Control.Concurrent
import Control.Concurrent.MVar
import Control.Concurrent.Chan
import qualified Data.Map as M
import qualified Data.Vector.Unboxed as V

type ID = Int

data Message =
   Wall String
 | Broadcast [ID] String
 | Message ID String

data Event =
   Init
 | Destroy
 | Connection (MVar (Maybe Client))
 | Disconnect ID
 | Delivery Message
 | Debug (MVar String)

data Client = Client {
 _id :: ID,
 _ch :: Chan String
}

data Server = Server {
 _mv :: MVar (Event),
 _clients :: M.Map ID Client,
 _maxConnections :: Int,
 _connections :: Int,
 _counter :: Int
}

instance Show Client where
 show (Client a b) = "id: " ++ show a

instance Show Server where
 show (Server a b c d e) = "clients: " ++ M.showTree b ++ ", maxConnections: " ++ show c ++ ", connections: " ++ show d ++ ", counter: " ++ show e

initServer :: Int -> IO Server
initServer maxConn = do
 mv <- newEmptyMVar
 let serv = Server { _mv = mv, _clients = M.empty, _maxConnections = maxConn, _connections = 0, _counter = 0 }
 forkIO $ dispatchLoop serv
 return serv

dispatchLoop :: Server -> IO ()
dispatchLoop serv = do
 e <- takeMVar $ _mv serv
 putStrLn "got event"
 serv' <- case e of
  Init -> do recv'event'id serv "init"
  Destroy -> do recv'event'id serv "destroy"
  Connection mv -> do recv'event'connection serv mv
  Disconnect id' -> do recv'event'disconnect serv id'
  Delivery _ -> do recv'event'id serv "destroy"
  Debug mv -> do recv'event'debug serv mv
 dispatchLoop serv'

recv'event'id :: Server -> String -> IO Server
recv'event'id serv s = do
 putStrLn $ "got " ++ s
 return serv

recv'event'connection :: Server -> MVar (Maybe Client) -> IO Server
recv'event'connection serv@Server{..} mv = do
 putStrLn $ "recv'event'connection"
 case (_connections >= _maxConnections) of
  False -> recv'event'connection'ok serv mv
  True-> recv'event'connection'fail serv mv

recv'event'connection'fail :: Server -> MVar (Maybe Client) -> IO Server
recv'event'connection'fail serv mv = do
 putMVar mv Nothing
 return serv
 
recv'event'connection'ok :: Server -> MVar (Maybe Client) -> IO Server
recv'event'connection'ok serv@Server{..} mv = do
 let counter = _counter + 1
 let connections = _connections + 1
 ch <- newChan
 let client = Client { _id = counter, _ch = ch }
 let clients = M.insert counter client _clients
 putMVar mv (Just client)
 let serv' = serv { _counter = counter, _connections = connections, _clients = clients }
 return serv'

recv'event'disconnect :: Server -> ID -> IO Server
recv'event'disconnect serv@Server{..} id' = do
 putStrLn $ "recv'event'disconnect: " ++ show id'
 let connections = _connections - 1
 let clients = deleteMaybe id' _clients
 case clients of
  Nothing -> return serv
  (Just clients') -> do
   let serv' = serv { _connections = connections, _clients = clients' }
   return serv'

recv'event'debug :: Server -> MVar String -> IO Server
recv'event'debug serv mv = do
 putStrLn $ "recv'event'debug"
 putMVar mv $ show serv
 return serv

send'event'connection :: Server -> IO (Maybe Client)
send'event'connection serv = do
 mv <- newEmptyMVar
 putMVar (_mv serv) $ Connection mv
 client <- takeMVar mv
 case client of
  Nothing -> return Nothing
  (Just client') -> do
   putStrLn $ "new connection: " ++ (show $ _id client')
   return client


send'event'disconnect :: Server -> ID -> IO ()
send'event'disconnect serv id' = do
 putMVar (_mv serv) $ Disconnect id'
 putStrLn $ "disconnect: " ++ show id'
 return ()

send'event'debug :: Server -> IO ()
send'event'debug serv = do
 mv <- newEmptyMVar
 putMVar (_mv serv) $ Debug mv
 msg <- takeMVar mv
 putStrLn $ "debug info: " ++ msg
 return ()

deliverWall :: Server -> String -> IO ()
deliverWall serv s = do
 return ()

deliverBroadcast :: Server -> [ID] -> String -> IO ()
deliverBroadcast serv ids s = do
 return ()

deliverMessage :: Server -> ID -> String -> IO ()
deliverMessage serv id' s = do
 putMVar (_mv serv) Init
 return ()
