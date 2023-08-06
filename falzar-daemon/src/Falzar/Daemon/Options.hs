{-# LANGUAGE ApplicativeDo   #-}
{-# LANGUAGE RecordWildCards #-}

module Falzar.Daemon.Options
  ( DaemonOptions(..)
  ) where

import           Options.Applicative
import           Options.Class

data DaemonOptions
  = DaemonOptions
  { port          :: Int
  , dataDirectory :: FilePath
  }

instance Options DaemonOptions where
  options = do
    port          <- option auto (long "port" <> metavar "PORT" <> short 'p' <> help "port to run the daemon (default)" <> value 3200)
    dataDirectory <- strOption (long "data" <> metavar "FOLDER" <> help "directory in which to read/load mocks")
    return DaemonOptions {..}
