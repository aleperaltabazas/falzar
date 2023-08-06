module Main (main) where

import Falzar.Daemon
import Falzar.Daemon.Context
import System.Environment

main :: IO ()
main = do
  args <- getArgs
  ctx <- createContext args
  runFalzarDaemon ctx
