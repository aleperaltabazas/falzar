{-# LANGUAGE OverloadedStrings #-}

module Falzar.Daemon (runFalzarDaemon) where

import           Control.Monad.Reader  (ReaderT (runReaderT))
import           Falzar.Daemon.API     (createMock, deleteMock, listMocks,
                                        runMocks)
import           Falzar.Daemon.Context (Context (port))
import           Network.HTTP.Types    (status200)
import qualified Web.Scotty.Reader     as Scotty
import           Web.Scotty.Reader     (delete, get, notFound, post, scottyT)

runFalzarDaemon :: Context -> IO ()
runFalzarDaemon ctx = do
  scottyT ctx.port (flip runReaderT ctx) $ do
    get "/falzar/status" $ Scotty.status status200
    get "/falzar/mocks" listMocks
    post "/falzar/mocks" createMock
    delete "/falzar/mocks/:id" deleteMock
    notFound runMocks
