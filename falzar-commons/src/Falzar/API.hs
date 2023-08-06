module Falzar.API
  ( CreateRouteMock(..)
  )
where

import           Data.Aeson   (FromJSON, Value)
import           GHC.Generics (Generic)
import           Prelude

data CreateRouteMock
  = CreateRouteMock
  { path   :: String
  , body   :: Maybe Value
  , method :: String
  , status :: Maybe Int
  } deriving (Generic)

instance FromJSON CreateRouteMock
