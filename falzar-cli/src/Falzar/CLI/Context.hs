module Falzar.CLI.Context
  ( App
  , Context(..)
  , createContext
  )
where

import           Control.Monad.Reader (ReaderT)

data Context
  = Context
  { port :: Int
  , host :: String
  }

type App = ReaderT Context IO

createContext :: IO Context
createContext = return Context{port = 3200, host = "localhost"}
