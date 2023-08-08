module Falzar.CLI.Options
  ( CliOptions(..)
  ) where

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
  | RestartDaemonCommand
  | DaemonStatusCommand

listMocksCommandParser = command "ls" $ makeInfo "List active mocks" $ pure ListMocksCommand

createMockCommandParser = command "mock" $ makeInfo "Create a new mock" $ CreateMockCommand <$> options

deleteMockCommanParser = command "delete" $ makeInfo "Delete a mock" $ DeleteMockCommand <$> options

startDaemonCommandParser = command "start" $ makeInfo "Start the falzar daemon" $ StartDaemonCommand <$> options

stopDaemonCommandParser = command "stop" $ makeInfo "Stop the falzar daemon" $ StopDaemonCommand <$> options

restartDaemomCommandParser = command "restart" $ makeInfo "Restart the falzar daemon with configuration refreshed" $ pure RestartDaemonCommand

daemonStatusCommandParser = command "status" $ makeInfo "Display the falzar daemon status" $ pure RestartDaemonCommand

instance Options CliOptions where
  options = subparser $
    listMocksCommandParser
      <> createMockCommandParser
      <> deleteMockCommanParser
      <> startDaemonCommandParser
      <> stopDaemonCommandParser
      <> restartDaemomCommandParser
      <> daemonStatusCommandParser

