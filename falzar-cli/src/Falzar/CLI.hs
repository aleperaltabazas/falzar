module Falzar.CLI where

import           Control.Monad.Reader         (ReaderT (runReaderT))
import           Falzar.CLI.Context           (Context (Context))
import           Falzar.CLI.Options.ListMocks

runFalzarCLI :: IO ()
runFalzarCLI = do
  let ctx = Context
  runReaderT run ctx
