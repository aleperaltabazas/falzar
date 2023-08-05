module Main (main) where

import           Network.HTTP.Types
import           Network.Wai
import           Network.Wai.Handler.Warp (run)
import           Web.Scotty
import Falzar
import Falzar.App

main :: IO ()
main = do
  ctx <- createContext
  runFalzar ctx
