module Falzar.CLI.Options.DeleteMock
  ( DeleteMockOptions(..)
  , run
  )
where

import           Falzar.CLI.Context
import           Options.Class

data DeleteMockOptions
  = DeleteMockOptions

instance Options DeleteMockOptions where
  options = pure DeleteMockOptions

run :: DeleteMockOptions -> App ()
run _ = return ()
