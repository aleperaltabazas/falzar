module Falzar.CLI.Options.Stop
  ( StopDaemonOptions(..)
  , run
  )
where

import           Falzar.CLI.Context (App)
import           Options.Class

data StopDaemonOptions
  = StopDaemonOptions

instance Options StopDaemonOptions where
  options = pure StopDaemonOptions

run :: StopDaemonOptions -> App ()
run _ = return ()
