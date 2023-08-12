module Falzar.CLI.Options
  ( CliOptions(..)
  ) where

import           Falzar.CLI.Options.Browse
import           Falzar.CLI.Options.Delete
import           Falzar.CLI.Options.Register
import           Falzar.CLI.Options.Start
import           Falzar.CLI.Options.Stop
import           Options.Applicative
import           Options.Class

data CliOptions
  = BrowseMocksCommand BrowseMocksOptions
  | RegisterMockCommand RegisterMockOptions
  | DeleteMockCommand DeleteMockOptions
  | StartDaemonCommand StartDaemonOptions
  | StopDaemonCommand StopDaemonOptions
  | RestartDaemonCommand

listMocksCommandParser = command "browse" $ makeInfo "List active mocks" $ BrowseMocksCommand <$> options

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

