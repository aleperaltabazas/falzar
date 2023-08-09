module Falzar.CLI.Config
  ( Config(..)
  , readConfig
) where

import           Data.String.Interpolate (i)
import           Data.Yaml               (FromJSON, decodeFileThrow)
import           GHC.Generics            (Generic)
import           System.Directory        (getHomeDirectory)

data Config
  = Config
  { port :: Int
  , host :: String
  } deriving (Generic)

instance FromJSON Config

readConfig :: IO Config
readConfig = do
  h <- getHomeDirectory
  let path = [i|#{h}/.config/falzar.yaml|]
  decodeFileThrow path
