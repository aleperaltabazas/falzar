{-# LANGUAGE DuplicateRecordFields #-}

module Falzar.Daemon.Context
  ( App
  , Context(..)
  , createContext
  , register
  )
where

import           Control.Monad.Reader    (MonadIO (liftIO), ReaderT, asks)
import           Data.Aeson              (decodeFileStrict)
import           Data.IORef              (IORef, modifyIORef, newIORef)
import           Data.Map                (Map)
import qualified Data.Map                as Map
import           Data.Maybe              (fromJust)
import           Data.String.Extra       (replace)
import           Data.String.Interpolate (i)
import           Falzar.Daemon.Options   (DaemonOptions (..))
import           Falzar.Route            (Route (..))
import           Options.Class           (Options (parseArgs))
import           System.Directory        (getCurrentDirectory, listDirectory)

type App = ReaderT Context IO

data Context
  = Context
  { mappedRoutes  :: IORef (Map String Route)
  , port          :: Int
  , dataDirectory :: FilePath
  }

createContext :: [String] -> IO Context
createContext args = do
  getCurrentDirectory >>= putStrLn
  opts <- parseArgs args :: IO DaemonOptions
  persistedRoutes <- readRoutes opts.dataDirectory
  routes <- newIORef $ Map.fromList persistedRoutes
  return $ Context
    { mappedRoutes = routes
    , port = opts.port
    , dataDirectory = opts.dataDirectory
    }
  where
    readRoutes :: FilePath -> IO [(String, Route)]
    readRoutes dd = do
      routePaths <- listDirectory dd
      sequence $ do
        r <- routePaths
        return $ do
          route <- (decodeFileStrict [i|#{dd}/#{r}|] :: IO (Maybe Route))
          return (replace '+' '/' r, fromJust route)


register :: String -> Route -> App ()
register path route = do
  routes <- asks mappedRoutes
  liftIO $ modifyIORef routes $ Map.insert path route
