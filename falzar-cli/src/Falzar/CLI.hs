module Falzar.CLI 
  ( runFalzarCLI
  ) 
where

import           Control.Monad.Reader         (ReaderT (runReaderT))
import           Falzar.CLI.Context
import qualified Falzar.CLI.Options.ListMocks as List

runFalzarCLI :: IO ()
runFalzarCLI = do
  let ctx = Context { port = 3200, host = "localhost"}
  runReaderT List.run ctx
