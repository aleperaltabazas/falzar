{-# LANGUAGE OverloadedStrings #-}

module Falzar.Route
  ( Route(..)
  )
where

import           Data.Aeson              (KeyValue ((.=)), ToJSON (toJSON),
                                          Value, object)
import           Data.String.Conversions (fromByteStringToString)
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
