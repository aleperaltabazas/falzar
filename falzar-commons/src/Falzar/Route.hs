{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}

module Falzar.Route
  ( Route(..)
  )
where

import           Data.Aeson
import           Data.String.Conversions (fromByteStringToString,
                                          fromStringToByteString)
import           GHC.Generics            (Generic)
import           Network.HTTP.Types      (Method)

data Route
  = Route
  { method :: Method
  , status :: Int
  , body   :: Maybe Value
  } deriving (Generic)

instance ToJSON Route where
  toJSON route = object
    [ "method" .= fromByteStringToString route.method
    , "status" .= route.status
    , "body" .= route.body
    ]

instance FromJSON Route where
  parseJSON = withObject "route" $ \o -> do
    method <- fromStringToByteString <$> o .: "method"
    status <- o .: "status"
    body   <- o .: "body"
    return Route {..}
