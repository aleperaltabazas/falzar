{-# LANGUAGE DuplicateRecordFields #-}

module Falzar.API
  ( CreateRouteMock(..)
  , DeleteMock(..)
  )
where

import           Data.Aeson   (FromJSON, ToJSON, Value)
import           GHC.Generics (Generic)

data CreateRouteMock
  = CreateRouteMock
  { path   :: String
  , body   :: Maybe Value
  , method :: String
  , status :: Maybe Int
  } deriving (Generic)

instance FromJSON CreateRouteMock
instance ToJSON CreateRouteMock

data DeleteMock
  = DeleteMock
  { path   :: String
  , method :: String
  } deriving (Generic)

instance FromJSON DeleteMock
instance ToJSON DeleteMock
