module Data.Maybe.Extra
  ( (?:),
    module Data.Maybe,
    fromMaybeIO,
    getOrElse,
    runMaybeIO,
    exists,
  )
where

import Data.Bool.Extra ((.&.))
import Data.Maybe
import Prelude

infixr 2 ?:

(?:) :: Maybe a -> a -> a
(?:) = flip fromMaybe

fromMaybeIO :: a -> IO (Maybe a) -> IO a
fromMaybeIO a = (>>= return . fromMaybe a)

getOrElse :: Monad m => Maybe a -> m a -> m a
getOrElse (Just a) _ = pure a
getOrElse Nothing ma = ma

runMaybeIO :: Maybe (IO a) -> IO (Maybe a)
runMaybeIO (Just a) = Just <$> a
runMaybeIO Nothing = return Nothing

exists :: (a -> Bool) -> Maybe a -> Bool
exists f = isJust .&. (f . fromJust)