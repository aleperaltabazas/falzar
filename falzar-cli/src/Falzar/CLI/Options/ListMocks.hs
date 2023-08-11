{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}

module Falzar.CLI.Options.ListMocks
  ( run
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

run :: App ()
run = do
  ctx <- ask
  res <- runReq defaultHttpConfig $ req GET (http (fromStringToText (ctx.host)) /: "falzar" /: "mocks") NoReqBody (jsonResponse :: Proxy (JsonResponse [Route])) (Req.port 3200)
  forM_ (responseBody res) $ \Route{..} -> liftIO $ do
    putStrLn [i|#{method} #{path}|]
    putStrLn [i|Status: #{status}|]
    let prettyBody = encodePretty body
    LBS.putStrLn (LBS.unlines . take 10 . LBS.lines $ prettyBody)
    when (length (LBS.lines prettyBody) > 10) $ do
      putStrLn "..."
      putStrLn "(body truncated because it's too long)"
    putStrLn ""
