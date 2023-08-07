module Falzar.CLI.Options.DeleteMock
  ( DeleteMockOptions(..)
  , run
  )
where

import           Falzar.CLI.Context

data DeleteMockOptions
  = DeleteMockOptions

run :: DeleteMockOptions -> App ()
run _ = return ()
