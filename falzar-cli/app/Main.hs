module Main (main) where

import Falzar.CLI
import Falzar.CLI.Context
import Options.Class
import System.Environment

main :: IO ()
main = do
  setProgramHeader "Customizable HTTP server mock"
  args <- getArgs
  ctx <- createContext
  runFalzarCLI args ctx
