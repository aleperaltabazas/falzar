module Falzar.App
  ( App
  , Context(..)
  , createContext
  , register
  )
where

import           Control.Monad.Reader (MonadIO (liftIO), ReaderT, asks)
import           Data.Aeson           (Value (Null))
import           Data.IORef
import           Data.Map             (Map, empty)
import qualified Data.Map             as Map
import           Falzar.Route         (Route (..))
import           Network.HTTP.Types   (methodGet)

type App = ReaderT Context IO

data Context
  = Context
  { mappedRoutes :: IORef (Map String Route)
  }

createContext :: IO Context
createContext = do
  routes <- newIORef (Map.singleton "/test" Route{method = methodGet, status = 200, body = Null} :: Map String Route)
  return $ Context { mappedRoutes = routes}

register :: String -> Route -> App ()
register path route = do
  routes <- asks mappedRoutes
  liftIO $ modifyIORef routes $ Map.insert path route
