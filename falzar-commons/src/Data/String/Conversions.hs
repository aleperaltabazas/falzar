module Data.String.Conversions
  ( fromStringToText,
    fromTextToString,
    fromStringToByteString,
    fromByteStringToString,
    fromLazyToStrict,
    fromStrictToLazy,
    fromLazyByteStringToString,
    fromStringToLazyByteString,
    Text,
    ByteString,
    LazyByteString,
  )
where

import qualified Data.ByteString as S (ByteString, concat)
import qualified Data.ByteString.Char8 as C8 (pack)
-- from utf8-string
import qualified Data.ByteString.Lazy as BL
import qualified Data.ByteString.UTF8 as BSU (toString)
import Data.Text (Text)
import qualified Data.Text.Conversions as Text
import Prelude

type ByteString = S.ByteString

type LazyByteString = BL.ByteString

fromStringToText :: String -> Text
fromStringToText = Text.toText

fromTextToString :: Text -> String
fromTextToString = Text.fromText

fromStringToByteString :: String -> ByteString
fromStringToByteString = C8.pack

fromByteStringToString :: ByteString -> String
fromByteStringToString = BSU.toString

fromLazyToStrict :: LazyByteString -> ByteString
fromLazyToStrict = S.concat . BL.toChunks

fromStrictToLazy :: ByteString -> LazyByteString
fromStrictToLazy = BL.fromStrict

fromLazyByteStringToString :: LazyByteString -> String
fromLazyByteStringToString = fromByteStringToString . fromLazyToStrict

fromStringToLazyByteString :: String -> LazyByteString
fromStringToLazyByteString = BL.fromStrict . fromStringToByteString