{-# LANGUAGE DuplicateRecordFields #-}

module Falzar.Daemon.API
  ( listMocks
  , createMock
  , deleteMock
  , runMocks
  ) where

import           Control.Monad.Cont      (MonadIO (liftIO))
import           Data.Aeson              (FromJSON, ToJSON, Value, decode)
import           Data.IORef              (modifyIORef, readIORef)
import qualified Data.Map                as Map
import           Data.Maybe.Extra
import           Data.String.Conversions (fromByteStringToString,
                                          fromStringToByteString,
                                          fromTextToString)
import           Data.String.Extra       (joinToString)
import           Data.String.Interpolate (i)
import           Falzar.Daemon
import           Falzar.Route            (Route (..))
import           GHC.Generics
import           Network.HTTP.Types      (parseMethod, renderStdMethod,
                                          status200, status400, status404)
import           Network.Wai             (Request (pathInfo, requestMethod))
import qualified Web.Scotty.Reader       as Scotty
import           Web.Scotty.Reader

data CreateRouteMock
  = CreateRouteMock
  { path   :: String
  , body   :: Maybe Value
  , method :: String
  , status :: Maybe Int
  } deriving (Generic)

instance FromJSON CreateRouteMock

data NotFound
  = NotFound
  { path   :: String
  , method :: String
  } deriving (Generic)

newtype ErrorMessage
  = ErrorMessage
  { message :: String
  } deriving (Generic)

instance ToJSON NotFound
instance ToJSON ErrorMessage

listMocks :: ReaderActionM Context ()
listMocks = do
  routes <- ask >>= (liftIO . readIORef . mappedRoutes)
  json routes

createMock :: ReaderActionM Context ()
createMock = do
  b <- decode <$> Scotty.body
  case b of
    Just route@CreateRouteMock{} -> do
      routes <- mappedRoutes <$> ask
      case parseMethod (fromStringToByteString route.method) of
        Left _ -> do
          let m = route.method
          json ErrorMessage { message = [i|error: unknown http method #{m}|] }
          Scotty.status status400
        Right m -> do
          liftIO $ modifyIORef routes $ Map.insert route.path Route
            { method = renderStdMethod m
            , body = route.body
            , status = route.status ?: 200
            }
          Scotty.status status200
    Nothing -> do
      json ErrorMessage{ message = "error: malformed request body" }
      Scotty.status status400

deleteMock :: ReaderActionM Context ()
deleteMock = do
  req <- request
  let requestPath = "/" ++ (joinToString "/" . map fromTextToString . pathInfo) req
  routes <- mappedRoutes <$> ask
  liftIO $ modifyIORef routes (Map.delete requestPath)

runMocks :: ReaderActionM Context ()
runMocks = do
  req <- request
  routes <- ask >>= (liftIO . readIORef . mappedRoutes)
  let requestPath = "/" ++ (joinToString "/" . map fromTextToString . pathInfo) req
  let route = Map.lookup requestPath routes
  case route of
    Nothing -> do
      json $ NotFound{method = fromByteStringToString (requestMethod req), path =  requestPath}
      Scotty.status status404
    Just r -> json r.body
