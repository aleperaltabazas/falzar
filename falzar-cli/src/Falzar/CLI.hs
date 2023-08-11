module Falzar.CLI
  ( runFalzarCLI
  )
where

import           Control.Monad.Reader            (ReaderT (runReaderT))
import           Falzar.CLI.Context
import           Falzar.CLI.Options              (CliOptions (..))
import qualified Falzar.CLI.Options.DeleteMock   as Delete
import qualified Falzar.CLI.Options.ListMocks    as List
import qualified Falzar.CLI.Options.RegisterMock as Register
import qualified Falzar.CLI.Options.Restart      as Restart
import qualified Falzar.CLI.Options.Start        as Start
import qualified Falzar.CLI.Options.Stop         as Stop

import           Options.Class                   (Options (parseArgs))

runFalzarCLI :: [String] -> Context -> IO ()
runFalzarCLI args ctx = do
  command <- parseArgs args
  flip runReaderT ctx $ case command of
    ListMocksCommand         -> List.run
    RegisterMockCommand opts -> Register.run opts
    DeleteMockCommand opts   -> Delete.run opts
    StartDaemonCommand opts  -> Start.run opts
    StopDaemonCommand opts   -> Stop.run opts
    RestartDaemonCommand     -> Restart.run
