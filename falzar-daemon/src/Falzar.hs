{-# LANGUAGE OverloadedStrings #-}

module Falzar (runFalzar) where

import           Control.Monad.Reader (ReaderT (runReaderT))
import           Falzar.Daemon        (Context)
import           Falzar.Daemon.API
import           Web.Scotty.Reader

runFalzar :: Context -> IO ()
runFalzar env = do
  scottyT 3000 (flip runReaderT env) $ do
    get "/falzar/mocks" listMocks
    post "/falzar/mocks" createMock
    delete "/falzar/mocks/:id" deleteMock
    notFound runMocks
