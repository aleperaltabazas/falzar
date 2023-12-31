{-# LANGUAGE ApplicativeDo     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}

module Falzar.CLI.Options.Register
  ( RegisterMockOptions(..)
  , run
  )
where

import           Control.Monad.Reader    (MonadIO (liftIO), MonadReader (ask))
import           Data.Aeson              (Value, eitherDecode,
                                          eitherDecodeFileStrict)
import qualified Data.ByteString.Char8   as BS
import           Data.String.Conversions (fromStringToLazyByteString,
                                          fromStringToText)
import           Falzar.API
import           Falzar.CLI.Context
import           Network.HTTP.Req        hiding (port)
import qualified Network.HTTP.Req        as Req
import           Options.Applicative
import           Options.Class
import           System.Exit             (exitFailure)

data RegisterMockOptions
  = RegisterMockOptions
  { bodyParser :: BodyParser
  , status     :: Maybe Int
  , path       :: String
  , method     :: String
  }

data BodyParser
  = FromFile FilePath
  | Literal String
  | NoResponseBody

instance Options RegisterMockOptions where
  options = do
    bodyParser <- (Literal <$> strOption (long "data" <> help "Response body for the mock" <> metavar "DATA"))
      <|> (FromFile <$> strOption (long "file" <> metavar "FILE" <> help "File where the response body is stored"))
      <|> flag' NoResponseBody (long "no-response-body" <> help "Set response body to null")
    status <- optional $ option auto (long "status" <> help "Response status code (default 200)" <> metavar "STATUS")
    path <- strOption (long "path" <> metavar "PATH" <> help "Service path")
    method <- strOption (long "method" <> metavar "METHOD" <> help "HTTP Method")
    return RegisterMockOptions{..}

run :: RegisterMockOptions -> App ()
run opts = do
  ctx <- ask
  maybeBody <- parseBody $ opts.bodyParser
  case maybeBody of
    Left err -> liftIO $ do
      putStrLn "Error parsing body:"
      putStrLn err
      exitFailure
    Right body -> do
      let createRoute
            = CreateRouteMock
            { path = opts.path
            , status = opts.status
            , method = opts.method
            , body  = body
            }
      res <- runReq defaultHttpConfig $ req POST (http (fromStringToText (ctx.host)) /: "falzar" /: "mocks") (ReqBodyJson createRoute) bsResponse (Req.port ctx.port)
      -- liftIO $ LBS.putStr (encodePretty $ responseBody res)
      case responseStatusCode res of
        200 -> return ()
        _ -> liftIO $ do
          putStrLn "Failed to create mock:"
          BS.putStrLn (responseBody res)
  where
    parseBody :: MonadIO m => BodyParser -> m (Either String (Maybe Value))
    parseBody NoResponseBody = return $ Right $ Nothing
    parseBody (Literal v) = return $ eitherDecode (fromStringToLazyByteString v)
    parseBody (FromFile fp) = liftIO $ do
      f <- eitherDecodeFileStrict fp
      return $ Just <$> f
