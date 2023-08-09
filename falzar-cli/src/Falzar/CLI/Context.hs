{-# LANGUAGE DuplicateRecordFields #-}

module Falzar.CLI.Context
  ( App
  , Context(..)
  , createContext
  )
where

import           Control.Monad.Reader (ReaderT)
import           Falzar.CLI.Config

data Context
  = Context
  { port :: Int
  , host :: String
  }

type App = ReaderT Context IO

createContext :: IO Context
createContext = do
  conf <- readConfig
  return Context { port = conf.port, host = conf.host }
