module Web.Scotty.Reader
  ( ReaderActionM
  , ask
  , scottyReaderT
  , module Web.Scotty.Trans
) where

import           Control.Monad.Reader       (ReaderT, lift)
import qualified Control.Monad.Reader       as Reader
import           Control.Monad.Trans.Reader (runReaderT)
import           Data.Text.Lazy             (Text)
import           Network.Wai.Handler.Warp   (Port)
import           Web.Scotty.Trans

type ReaderActionM e = ActionT Text (ReaderT e IO)

ask :: ReaderActionM e e
ask = lift Reader.ask

scottyReaderT :: Port -> ScottyT r (ReaderT r IO) () -> (r -> IO ())
scottyReaderT port app e = scottyT port (`runReaderT` e) app
