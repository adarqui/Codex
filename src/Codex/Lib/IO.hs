module Codex.Lib.IO (
 --read'
) where

import System.IO
--import Control.Frame
--import Control.IMonad.Do
--import Control.IMonad.Trans
--import Prelude hiding (Monad(..))

{-
readFile' :: Handle -> Frame Text IO C C ()
readFile' h = do
    eof <- liftU $ hIsEOF h
    whenR (not eof) $ do
        s <- liftU $ hGetLine h
        yield s
        readFile' h
-}

{-

read' :: FilePath -> Frame Text IO C C ()
read' file = do
    liftU $ putStrLn "Opening file..."
    h <- liftU $ openFile file ReadMode
    -- The following requires "import qualified Control.Monad as M"
    finallyD (putStrLn "Closing file ..." M.>> hClose h) $ readFile' h
-}
