module Data.Tuple.Extra
  ( mapFst,
    mapSnd,
  )
where

mapFst :: (a -> b) -> (a, c) -> (b, c)
mapFst f (a, c) = (f a, c)

mapSnd :: (a -> c) -> (b, a) -> (b, c)
mapSnd f (b, a) = (b, f a)