module Data.Either.Extra
  ( mapLeft,
    mapRight,
    mapBoth,
    maybeRight,
    getOrThrow,
    toEither,
    module Data.Either,
  )
where

import Data.Either
import Prelude

mapLeft :: (a -> c) -> Either a b -> Either c b
mapLeft f = mapBoth f id

mapRight :: (b -> c) -> Either a b -> Either a c
mapRight = mapBoth id

mapBoth :: (a -> c) -> (b -> d) -> Either a b -> Either c d
mapBoth f _ (Left a) = Left (f a)
mapBoth _ g (Right b) = Right (g b)

maybeRight :: Either a b -> Maybe b
maybeRight (Right r) = Just r
maybeRight _ = Nothing

getOrThrow :: (a -> b) -> Either a b -> b
getOrThrow f (Left e) = f e
getOrThrow _ (Right a) = a

toEither :: a -> Maybe b -> Either a b
toEither _ (Just b) = Right b
toEither a Nothing = Left a