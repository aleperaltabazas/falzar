module Falzar.CLI.Options.Stop
  ( StopDaemonOptions(..)
  , run
  )
where

import           Falzar.CLI.Context (App)

data StopDaemonOptions
  = StopDaemonOptions

run :: App ()
run = return ()
