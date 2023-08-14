{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE OverloadedStrings     #-}

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
import           Data.List.Extra         (startsWith)
import           Data.Maybe.Extra        ((?:))
import           Data.String.Conversions (fromByteStringToString,
                                          fromStringToByteString)
import           Data.String.Interpolate (i)
import           Data.UUID.V4            (nextRandom)
import           Falzar.API              (CreateRouteMock (..), DeleteMock (..))
import           Falzar.Daemon.Context   (Context (dataDirectory, mappedRoutes))
import           Falzar.Route
import           GHC.Generics            (Generic)
import           Network.HTTP.Types
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
  pathFilter <- Scotty.param "path" `Scotty.rescue` (\_ -> return "")
  json . filter (\r -> r.path `startsWith` pathFilter) . map fst $ routes

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
    Just (r, _) -> do
      Scotty.status (assignStatus r.status)
      json r.body
    where
      -- fuck
      assignStatus :: Int -> Status
      assignStatus 200 = status200
      assignStatus 201 = status201
      assignStatus 202 = status202
      assignStatus 203 = status203
      assignStatus 204 = status204
      assignStatus 205 = status205
      assignStatus 206 = status206
      assignStatus 300 = status300
      assignStatus 301 = status301
      assignStatus 302 = status302
      assignStatus 303 = status303
      assignStatus 304 = status304
      assignStatus 305 = status305
      assignStatus 307 = status307
      assignStatus 308 = status308
      assignStatus 400 = status400
      assignStatus 401 = status401
      assignStatus 402 = status402
      assignStatus 403 = status403
      assignStatus 404 = status404
      assignStatus 405 = status405
      assignStatus 406 = status406
      assignStatus 407 = status407
      assignStatus 408 = status408
      assignStatus 409 = status409
      assignStatus 410 = status410
      assignStatus 411 = status411
      assignStatus 412 = status412
      assignStatus 413 = status413
      assignStatus 414 = status414
      assignStatus 415 = status415
      assignStatus 416 = status416
      assignStatus 417 = status417
      assignStatus 418 = status418
      assignStatus 422 = status422
      assignStatus 428 = status428
      assignStatus 429 = status429
      assignStatus 431 = status431
      assignStatus 500 = status500
      assignStatus 501 = status501
      assignStatus 502 = status502
      assignStatus 503 = status503
      assignStatus 504 = status504
      assignStatus 505 = status505
      assignStatus 511 = status511
      assignStatus st  = mkStatus 500 [i|unknown status code #{st}|]
