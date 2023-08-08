module Falzar.API
  ( CreateRouteMock(..)
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
