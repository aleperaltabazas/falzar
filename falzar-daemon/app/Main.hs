module Main (main) where

import Falzar.Daemon
import Falzar.Daemon.Context
import Options.Class
import System.Environment

main :: IO ()
main = do
  setProgramHeader "Customizable HTTP server mock"
  args <- getArgs
  ctx <- createContext args
  runFalzarDaemon ctx
