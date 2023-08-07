module Falzar.CLI.Context
  ( App
  , Context(..)
  )
where

import           Control.Monad.Reader (ReaderT)

data Context
  = Context

type App = ReaderT Context IO
