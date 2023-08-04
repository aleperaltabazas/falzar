module Data.String.Extra
  ( stringToInt,
    trim,
    joinToString,
    removeSuffix,
    dropSnapshot,
    (+:),
    replace,
    toLowerS,
    escapePath,
  )
where

import Data.Char (isSpace, toLower)
import Data.List.Extra (dropRight, intercalate, isSuffixOf)
import Prelude

-- This functions throws runtime error on a string that contains any non-numeric characters.
-- So please, don't use the function called _stringToInt_ on non-integer numbers.
stringToInt :: String -> Int
stringToInt = read

trim :: String -> String
trim = f . f where f = reverse . dropWhile isSpace

joinToString :: String -> [String] -> String
joinToString _ [] = ""
joinToString separator ws = intercalate separator ws

(+:) :: String -> Int -> String
(+:) s i = show . (+ i) . stringToInt $ s

removeSuffix :: String -> String -> String
removeSuffix suffix str = if suffix `isSuffixOf` str then dropRight (length suffix) str else str

dropSnapshot :: String -> String
dropSnapshot = removeSuffix "-SNAPSHOT"

replace :: Char -> Char -> String -> String
replace _ _ [] = []
replace toReplace replacement (c : remainder)
  | c == toReplace = replacement : replace toReplace replacement remainder
  | otherwise = c : replace toReplace replacement remainder

toLowerS :: String -> String
toLowerS = map toLower

escapePath :: String -> String
escapePath = replace '/' '_' . trimTrailingSlash where trimTrailingSlash s = if "/" `isSuffixOf` s then init s else s