{-# LANGUAGE DuplicateRecordFields #-}

module Falzar.Daemon.Context
  ( App
  , Context(..)
  , createContext
  )
where

import           Control.Monad.Reader    (ReaderT)
import           Data.Aeson              (decodeFileStrict)
import           Data.IORef              (IORef, newIORef)
import           Data.Maybe              (fromJust)
import           Data.String.Interpolate (i)
import           Falzar.Daemon.Options   (DaemonOptions (..))
import           Falzar.Route            (Route)
import           Options.Class           (Options (parseArgs))
import           System.Directory        (listDirectory)

type App = ReaderT Context IO

data Context
  = Context
  { mappedRoutes  :: IORef [(Route, FilePath)]
  , port          :: Int
  , dataDirectory :: FilePath
  }

createContext :: [String] -> IO Context
createContext args = do
  opts <- parseArgs args :: IO DaemonOptions
  persistedRoutes <- readRoutes opts.dataDirectory
  routes <- newIORef persistedRoutes
  return $ Context
    { mappedRoutes = routes
    , port = opts.port
    , dataDirectory = opts.dataDirectory
    }
  where
    readRoutes :: FilePath -> IO [(Route, FilePath)]
    readRoutes dd = do
      routePaths <- listDirectory dd
      sequence $ do
        r <- routePaths
        return $ do
          route <- fromJust <$> (decodeFileStrict [i|#{dd}/#{r}|] :: IO (Maybe Route))
          return (route, r)
