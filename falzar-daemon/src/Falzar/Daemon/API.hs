{-# LANGUAGE DuplicateRecordFields #-}

module Falzar.Daemon.API
  ( listMocks
  , createMock
  , deleteMock
  , runMocks
  ) where

import           Control.Monad.Cont      (MonadIO (liftIO))
import           Data.Aeson              (ToJSON, decode, encodeFile)
import           Data.IORef              (modifyIORef, readIORef)
import qualified Data.Map                as Map
import           Data.Maybe.Extra        ((?:))
import           Data.String.Conversions (fromStringToByteString,
                                          fromTextToString)
import           Data.String.Extra       (joinToString, replace)
import           Data.String.Interpolate (i)
import           Falzar.API              (CreateRouteMock (..))
import           Falzar.Daemon.Context   (Context (dataDirectory, mappedRoutes))
import           Falzar.Route            (Route (..))
import           GHC.Generics            (Generic)
import           Network.HTTP.Types      (parseMethod, renderStdMethod,
                                          status200, status400, status404)
import           Network.Wai             (Request (pathInfo, requestMethod))
import           System.Directory        (removeFile)
import qualified Web.Scotty.Reader       as Scotty
import           Web.Scotty.Reader       (ReaderActionM, ask, json, request)

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
  json . map snd . Map.toList $ routes

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
          ctx <- ask
          let r = Route
                { method = renderStdMethod m
                , body = route.body
                , status = route.status ?: 200
                , path = route.path
                }
          liftIO $ do
            modifyIORef routes $ Map.insert route.path r
            let p = route.path
            let dd = ctx.dataDirectory
            encodeFile [i|#{dd}/#{replace '/' '+'  p}.json|] r
          Scotty.status status200
    Nothing -> do
      json ErrorMessage{ message = "error: malformed request body" }
      Scotty.status status400

deleteMock :: ReaderActionM Context ()
deleteMock = do
  req <- request
  let requestPath = "/" ++ (joinToString "/" . map fromTextToString . pathInfo) req
  routes <- mappedRoutes <$> ask
  ctx <- ask
  liftIO $ do
    modifyIORef routes (Map.delete requestPath)
    let p = requestPath
    let dd = ctx.dataDirectory
    removeFile [i|#{dd}/#{replace '/' '_'  p}.json|]

runMocks :: ReaderActionM Context ()
runMocks = do
  req <- request
  routes <- ask >>= (liftIO . readIORef . mappedRoutes)
  let requestPath = "/" ++ (joinToString "/" . map fromTextToString . pathInfo) req
  let route = Map.lookup requestPath routes
  case route of
    Nothing -> do
      json ErrorMessage { message = [i|error: route #{requestPath} with method #{requestMethod req} is not registered|] }
      Scotty.status status404
    Just r -> do
      Scotty.status status200
      json r.body
