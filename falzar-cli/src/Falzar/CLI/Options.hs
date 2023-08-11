module Falzar.CLI.Options
  ( CliOptions(..)
  ) where

import           Falzar.CLI.Options.DeleteMock
import           Falzar.CLI.Options.RegisterMock
import           Falzar.CLI.Options.Start
import           Falzar.CLI.Options.Stop
import           Options.Applicative
import           Options.Class

data CliOptions
  = ListMocksCommand
  | RegisterMockCommand RegisterMockOptions
  | DeleteMockCommand DeleteMockOptions
  | StartDaemonCommand StartDaemonOptions
  | StopDaemonCommand StopDaemonOptions
  | RestartDaemonCommand

listMocksCommandParser = command "ls" $ makeInfo "List active mocks" $ pure ListMocksCommand

registerMockCommandParser = command "register" $ makeInfo "Register a new mock" $ RegisterMockCommand <$> options

deleteMockCommanParser = command "delete" $ makeInfo "Delete a mock" $ DeleteMockCommand <$> options

startDaemonCommandParser = command "start" $ makeInfo "Start the falzar daemon" $ StartDaemonCommand <$> options

stopDaemonCommandParser = command "stop" $ makeInfo "Stop the falzar daemon" $ StopDaemonCommand <$> options

restartDaemomCommandParser = command "restart" $ makeInfo "Restart the falzar daemon with configuration refreshed" $ pure RestartDaemonCommand


instance Options CliOptions where
  options = subparser $
    listMocksCommandParser
      <> registerMockCommandParser
      <> deleteMockCommanParser
      -- <> startDaemonCommandParser
      -- <> stopDaemonCommandParser
      -- <> restartDaemomCommandParser

