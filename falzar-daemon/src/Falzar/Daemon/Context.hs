{-# LANGUAGE DuplicateRecordFields #-}

module Falzar.Daemon.Context
  ( App
  , Context(..)
  , createContext
  , register
  )
where

import           Control.Monad.Reader  (MonadIO (liftIO), ReaderT, asks)
import           Data.IORef            (IORef, modifyIORef, newIORef)
import           Data.Map              (Map)
import qualified Data.Map              as Map
import           Falzar.Daemon.Options (DaemonOptions (..))
import           Falzar.Route          (Route (..))
import           Options.Class         (Options (parseArgs))

type App = ReaderT Context IO

data Context
  = Context
  { mappedRoutes  :: IORef (Map String Route)
  , port          :: Int
  , dataDirectory :: FilePath
  }

createContext :: [String] -> IO Context
createContext args = do
  opts <- parseArgs args :: IO DaemonOptions
  routes <- newIORef Map.empty
  return $ Context
    { mappedRoutes = routes
    , port = opts.port
    , dataDirectory = opts.dataDirectory
    }

register :: String -> Route -> App ()
register path route = do
  routes <- asks mappedRoutes
  liftIO $ modifyIORef routes $ Map.insert path route
