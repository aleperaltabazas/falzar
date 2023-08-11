{-# LANGUAGE DuplicateRecordFields #-}

module Falzar.Daemon.API
  ( listMocks
  , createMock
  , deleteMock
  , runMocks
  ) where

import           Control.Monad.Cont      (MonadIO (liftIO))
import           Data.Aeson              (ToJSON, encodeFile)
import           Data.IORef              (modifyIORef, readIORef)
import           Data.List               (find)
import qualified Data.List               as List
import           Data.Maybe.Extra        ((?:))
import           Data.String.Conversions (fromByteStringToString,
                                          fromStringToByteString)
import           Data.String.Interpolate (i)
import           Data.UUID.V4            (nextRandom)
import           Falzar.API              (CreateRouteMock (..), DeleteMock (..))
import           Falzar.Daemon.Context   (Context (dataDirectory, mappedRoutes))
import           Falzar.Route            (Route (..))
import           GHC.Generics            (Generic)
import           Network.HTTP.Types      (parseMethod, renderStdMethod,
                                          status200, status400, status404)
import           Network.Wai             (Request (requestMethod))
import           System.Directory        (removeFile)
import qualified Web.Scotty.Reader       as Scotty
import           Web.Scotty.Reader       (ReaderActionM, ask, json,
                                          jsonRequestBody, request, requestPath)

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
  json . map fst $ routes

createMock :: ReaderActionM Context ()
createMock = do
  b <- jsonRequestBody
  case b of
    Right route@CreateRouteMock{} -> do
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
            let dd = ctx.dataDirectory
            key <- show <$> nextRandom
            modifyIORef routes $ ((r, key) :)
            encodeFile [i|#{dd}/#{key}.json|] r
          Scotty.status status200
    Left err -> do
      json ErrorMessage { message = "malformed request body: " ++ err }
      Scotty.status status400

deleteMock :: ReaderActionM Context ()
deleteMock = do
  b <- jsonRequestBody :: ReaderActionM Context (Either String DeleteMock)
  case b of
    Left err -> do
      json ErrorMessage { message = "malformed request body: " ++ err }
      Scotty.status status400
    Right delete -> do
      routes <- mappedRoutes <$> ask
      ctx <- ask
      maybeRoute <- liftIO $ List.find (\(r, _) -> fromByteStringToString (r.method) == delete.method && r.path == delete.path) <$> readIORef routes
      case maybeRoute of
        Just r@(_, filePath) -> liftIO $ do
          modifyIORef routes (List.delete r)
          let dd = ctx.dataDirectory
          removeFile [i|#{dd}/#{filePath}|]
        Nothing -> do
          Scotty.status status400
          json ErrorMessage { message = delete.method ++ " " ++ delete.path ++ " mock not found"}

runMocks :: ReaderActionM Context ()
runMocks = do
  req <- request
  routes <- ask >>= (liftIO . readIORef . mappedRoutes)
  rp <- requestPath
  let route = Data.List.find (\(r, _) -> r.path == rp && r.method == requestMethod req) routes
  case route of
    Nothing -> do
      json ErrorMessage { message = [i|error: route #{rp} with method #{requestMethod req} is not registered|] }
      Scotty.status status404
    Just r -> do
      Scotty.status status200
      json (fst r).body
