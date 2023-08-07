{-# LANGUAGE OverloadedStrings #-}

module Falzar.CLI.Options.ListMocks
  ( run
  )
where

import           Control.Monad.Cont       (MonadIO (liftIO))
import           Data.Aeson.Encode.Pretty (encodePretty)
import qualified Data.ByteString.Lazy     as LBS (putStr)
import           Data.Map
import           Data.Proxy               (Proxy)
import           Falzar.CLI.Context       (App)
import           Falzar.Route
import           Network.HTTP.Req

run :: App ()
run = do
  res <- runReq defaultHttpConfig $ req GET (http "localhost" /: "falzar" /: "mocks") NoReqBody (jsonResponse :: Proxy (JsonResponse (Map String Route))) (port 3200)
  let json = encodePretty $ responseBody res
  liftIO $ LBS.putStr json
