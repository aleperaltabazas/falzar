module Main (main) where

import Falzar.Daemon
import Falzar.Daemon.Context
import Options.Class
import System.Environment

main :: IO ()
main = do
  setProgramHeader "falzard - falzar mock server"
  args <- getArgs
  ctx <- createContext args
  runFalzarDaemon ctx
