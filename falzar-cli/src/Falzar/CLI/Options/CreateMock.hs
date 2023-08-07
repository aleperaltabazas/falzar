{-# LANGUAGE ApplicativeDo   #-}
{-# LANGUAGE RecordWildCards #-}

module Falzar.CLI.Options.CreateMock
  ( CreateMockOptions(..)
  , run
  )
where

import           Falzar.CLI.Context  (App)
import           Options.Applicative
import           Options.Class

data CreateMockOptions
  = CreateMockOptions
  { body   :: BodyParser
  , status :: Maybe Int
  }

data BodyParser
  = FromFile FilePath
  | Literal String

instance Options CreateMockOptions where
  options = do
    body <- (Literal <$> strOption (long "data" <> help "Response body for the mock" <> metavar "DATA")) <|> (FromFile <$> strOption (long "file" <> metavar "FILE" <> help "File where the response body is stored"))
    status <- optional $ option auto (long "status" <> help "Response status code (default 200)" <> metavar "STATUS")
    return CreateMockOptions{..}

run :: CreateMockOptions -> App ()
run _ = return ()
