module Main (main) where

import Falzar.CLI
import Options.Class

main :: IO ()
main = do
  setProgramHeader "Customizable HTTP server mock" 
  runFalzarCLI
