module Data.Bool.Extra
  ( module Data.Bool,
    (.&.),
    (.|.),
  )
where

import Data.Bool

(.|.) :: (a -> Bool) -> (a -> Bool) -> (a -> Bool)
f .|. g = \x -> f x || g x

(.&.) :: (a -> Bool) -> (a -> Bool) -> (a -> Bool)
f .&. g = \x -> f x && g x