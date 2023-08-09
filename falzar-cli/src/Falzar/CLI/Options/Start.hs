{-# LANGUAGE ApplicativeDo   #-}
{-# LANGUAGE RecordWildCards #-}

module Falzar.CLI.Options.Start
  ( StartDaemonOptions(..)
  , run
  )
where

import           Control.Monad.Cont  (MonadIO (liftIO))
import           Falzar.CLI.Context  (App)
import           Options.Applicative
import           Options.Class

newtype StartDaemonOptions
  = StartDaemonOptions
  { port :: Int
  }

instance Options StartDaemonOptions where
  options = do
    port <- option auto (long "port" <> short 'p' <> metavar "PORT" <> help "Falzar service port")
    return StartDaemonOptions{..}

run :: StartDaemonOptions -> App ()
run _ = liftIO $ putStrLn "Not yet implemented"
