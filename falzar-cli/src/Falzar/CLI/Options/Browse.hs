{-# LANGUAGE ApplicativeDo     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}

module Falzar.CLI.Options.Browse
  ( run
  , BrowseMocksOptions(..)
  )
where

import           Control.Monad.Cont         (MonadIO (liftIO), forM_, when)
import           Control.Monad.Trans.Reader (ask)
import           Data.Aeson.Encode.Pretty   (encodePretty)
import qualified Data.ByteString.Lazy.Char8 as LBS
import           Data.Proxy                 (Proxy)
import           Data.String.Conversions    (fromStringToText)
import           Data.String.Interpolate    (i)
import           Falzar.CLI.Context
import           Falzar.Route
import           Network.HTTP.Req           hiding (port)
import qualified Network.HTTP.Req           as Req
import           Options.Applicative
import           Options.Class

newtype BrowseMocksOptions
  = BrowseMocksOptions
  { pathPrefix :: Maybe String
  } deriving (Show, Eq)

instance Options BrowseMocksOptions where
  options = do
    pathPrefix <- optional $ strArgument (metavar "PATH" <> help "Look for mocks with routes starting with <PATH>")
    return BrowseMocksOptions {..}

run :: BrowseMocksOptions -> App ()
run opts = do
  ctx <- ask
  res <- runReq defaultHttpConfig $
    req
      GET
      (http (fromStringToText ctx.host) /: "falzar" /: "mocks")
      NoReqBody (jsonResponse :: Proxy (JsonResponse [Route]))
      (Req.port 3200 <> maybe mempty ("path" =:) opts.pathPrefix)
  forM_ (responseBody res) $ \Route{..} -> liftIO $ do
    putStrLn [i|#{method} #{path}|]
    putStrLn [i|Status: #{status}|]
    let prettyBody = encodePretty body
    LBS.putStrLn (LBS.unlines . take 10 . LBS.lines $ prettyBody)
    when (length (LBS.lines prettyBody) > 10) $ do
      putStrLn "..."
      putStrLn "(body truncated because it's too long)"
    putStrLn ""
