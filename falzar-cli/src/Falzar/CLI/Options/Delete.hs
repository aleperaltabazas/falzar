{-# LANGUAGE ApplicativeDo     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}

module Falzar.CLI.Options.Delete
  ( DeleteMockOptions(..)
  , run
  )
where

import           Control.Monad.Reader    (MonadIO (liftIO), MonadReader (ask))
import qualified Data.ByteString.Char8   as BS
import           Data.String.Conversions (fromStringToText)
import           Falzar.API
import           Falzar.CLI.Context
import           Network.HTTP.Req
import qualified Network.HTTP.Req        as Req
import           Options.Applicative
import           Options.Class

data DeleteMockOptions
  = DeleteMockOptions
  { path   :: String
  , method :: String
  }

instance Options DeleteMockOptions where
  options = do
    path <- strOption (long "path" <> metavar "PATH" <> help "Path of the mock to delete")
    method <- strOption (long "method" <> metavar "METHOD" <> help "Method of the mock to delete")
    return DeleteMockOptions{..}

run :: DeleteMockOptions -> App ()
run opts = do
  ctx <- ask
  let createRoute
        = DeleteMock
        { path = opts.path
        , method = opts.method
        }
  res <- runReq defaultHttpConfig $ req DELETE (http (fromStringToText (ctx.host)) /: "falzar" /: "mocks") (ReqBodyJson createRoute) bsResponse (Req.port ctx.port)
  -- liftIO $ LBS.putStr (encodePretty $ responseBody res)
  case responseStatusCode res of
    200 -> return ()
    _ -> liftIO $ do
      putStrLn "Failed to delete mock:"
      BS.putStrLn (responseBody res)
