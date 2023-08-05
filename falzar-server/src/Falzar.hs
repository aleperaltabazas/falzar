{-# LANGUAGE OverloadedStrings #-}

module Falzar (runFalzar) where

import           Control.Monad.Reader (MonadIO (liftIO), ReaderT (runReaderT))
import           Data.IORef           (readIORef)
import           Falzar.App           (Context (mappedRoutes))
import           Web.Scotty.Reader
import           Web.Scotty.Trans

runFalzar :: Context -> IO ()
runFalzar env = do
  scottyT 3000 (flip runReaderT env) $ do
    get "/falzar/mocks" listMocks
    post "/falzar/mocks" createMock
    delete "/falzar/mocks/:id" deleteMock
    notFound runMocks


listMocks :: ReaderActionM Context ()
listMocks = do
  routes <- ask >>= (liftIO . readIORef . mappedRoutes)
  json routes

createMock :: ReaderActionM Context ()
createMock = do
  return ()

deleteMock :: ReaderActionM Context ()
deleteMock = do
  return ()

runMocks :: ReaderActionM Context ()
runMocks = do
  return ()
