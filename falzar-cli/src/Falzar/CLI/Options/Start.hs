module Falzar.CLI.Options.Start
  ( StartDaemonOptions(..)
  , run
  )
where

import           Falzar.CLI.Context (App)

data StartDaemonOptions
  = StartDaemonOptions

run :: StartDaemonOptions -> App ()
run _ = return ()
