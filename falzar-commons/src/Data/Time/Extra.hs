module Data.Time.Extra
  ( currentTimestamp,
    toISO,
  )
where

import           Data.String.Interpolate (i)
import           Data.Time.Clock         (UTCTime)
import           Data.Time.Format        (defaultTimeLocale, formatTime)
import           Data.Time.LocalTime     (LocalTime (localDay, localTimeOfDay),
                                          ZonedTime (zonedTimeToLocalTime),
                                          getZonedTime)
import           Prelude

currentTimestamp :: IO String
currentTimestamp = do
  now <- getZonedTime
  let day = show . localDay . zonedTimeToLocalTime $ now
  let time = show . localTimeOfDay . zonedTimeToLocalTime $ now
  return [i|#{day} #{take 8 time}|]

toISO :: UTCTime -> String
toISO = (++ "Z") . take 23 . formatTime defaultTimeLocale "%FT%T%QZ"
