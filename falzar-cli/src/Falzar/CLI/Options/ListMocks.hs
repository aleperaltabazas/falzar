{-# LANGUAGE OverloadedStrings #-}

module Falzar.CLI.Options.ListMocks
  ( run
  )
where

import           Control.Monad.Cont         (MonadIO (liftIO))
import           Control.Monad.Trans.Reader (ask)
import           Data.Aeson.Encode.Pretty   (encodePretty)
import qualified Data.ByteString.Lazy       as LBS (putStr)
import           Data.Map
import           Data.Proxy                 (Proxy)
import           Data.String.Conversions    (fromStringToText)
import           Falzar.CLI.Context
import           Falzar.Route
import           Network.HTTP.Req           hiding (port)
import qualified Network.HTTP.Req           as Req

run :: App ()
run = do
  ctx <- ask
  res <- runReq defaultHttpConfig $ req GET (http (fromStringToText (ctx.host)) /: "falzar" /: "mocks") NoReqBody (jsonResponse :: Proxy (JsonResponse (Map String Route))) (Req.port 3200)
  liftIO $ LBS.putStr (encodePretty $ responseBody res)
