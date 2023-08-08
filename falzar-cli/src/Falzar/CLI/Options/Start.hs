module Falzar.CLI.Options.Start
  ( StartDaemonOptions(..)
  , run
  )
where

import           Falzar.CLI.Context (App)
import           Options.Class

data StartDaemonOptions
  = StartDaemonOptions

instance Options StartDaemonOptions where
  options = pure StartDaemonOptions

run :: StartDaemonOptions -> App ()
run _ = return ()
