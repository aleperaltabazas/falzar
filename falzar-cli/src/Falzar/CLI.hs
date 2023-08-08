module Falzar.CLI
  ( runFalzarCLI
  )
where

import           Control.Monad.Reader          (ReaderT (runReaderT))
import           Falzar.CLI.Context
import           Falzar.CLI.Options            (CliOptions (..))
import qualified Falzar.CLI.Options.CreateMock as Create
import qualified Falzar.CLI.Options.DeleteMock as Delete
import qualified Falzar.CLI.Options.ListMocks  as List
import qualified Falzar.CLI.Options.Restart    as Restart
import qualified Falzar.CLI.Options.Start      as Start
import qualified Falzar.CLI.Options.Status     as Status
import qualified Falzar.CLI.Options.Stop       as Stop

import           Options.Class                 (Options (parseArgs))

runFalzarCLI :: [String] -> Context -> IO ()
runFalzarCLI args ctx = do
  command <- parseArgs args
  flip runReaderT ctx $ case command of
    ListMocksCommand        -> List.run
    CreateMockCommand opts  -> Create.run opts
    DeleteMockCommand opts  -> Delete.run opts
    StartDaemonCommand opts -> Start.run opts
    StopDaemonCommand opts  -> Stop.run opts
    DaemonStatusCommand     -> Status.run
    RestartDaemonCommand    -> Restart.run