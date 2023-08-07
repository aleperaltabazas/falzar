module Falzar.CLI.Options where

import           Falzar.CLI.Options.CreateMock
import           Falzar.CLI.Options.DeleteMock
import           Falzar.CLI.Options.Start
import           Falzar.CLI.Options.Stop

data CliOptions
  = ListMocksCommand
  | CreateMockCommand CreateMockOptions
  | DeleteMockCommand DeleteMockOptions
  | StartDaemonCommand StartDaemonOptions
  | StopDaemonCommand StopDaemonOptions
  | DaemonStatusCommand
