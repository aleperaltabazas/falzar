module Falzar.CLI.Context
  ( App
  , Context(..)
  )
where

import           Control.Monad.Reader (ReaderT)

data Context
  = Context
  { port :: Int
  , host :: String
  }

type App = ReaderT Context IO
