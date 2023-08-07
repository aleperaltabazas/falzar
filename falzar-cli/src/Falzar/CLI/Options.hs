module Falzar.CLI.Options where

import           Falzar.CLI.Options.CreateMock
import           Falzar.CLI.Options.DeleteMock
import           Falzar.CLI.Options.Start
import           Falzar.CLI.Options.Stop
import           Options.Applicative
import           Options.Class

data CliOptions
  = ListMocksCommand
  | CreateMockCommand CreateMockOptions
  | DeleteMockCommand DeleteMockOptions
  | StartDaemonCommand StartDaemonOptions
  | StopDaemonCommand StopDaemonOptions
  | DaemonStatusCommand

listMocksCommandParser = subparser (command "ls" $ makeInfo "List active mocks" $ pure ListMocksCommand)

createMockCommandParser = subparser (command "mock" $ makeInfo "Create a new mock" $ CreateMockCommand <$> options)
