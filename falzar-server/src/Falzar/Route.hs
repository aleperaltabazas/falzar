module Falzar.Route
  ( Route(..)
  )
where

import           Network.HTTP.Types (Method)

data Route
  = Route
  { method :: Method
  , status :: Int
  , body   :: String
  }
