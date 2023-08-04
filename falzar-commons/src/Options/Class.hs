module Options.Class
  ( Options (..),
  )
where

import           Options.Applicative
import           Prelude

class Options o where
  options :: Parser o

  parseArgs :: [String] -> IO o
  parseArgs args = do
    let opts = info (options <**> helper) (fullDesc <> header "Henry - a command line pipeline")
    let result = execParserPure defaultPrefs opts args
    handleParseResult result
