module Falzar.CLI.Options.Restart
  ( run
  )
where

import           Control.Monad.Cont (MonadIO (liftIO))
import           Falzar.CLI.Context

run :: App ()
run = liftIO $ putStrLn "Not yet implemented"
