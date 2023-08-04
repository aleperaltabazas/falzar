module Control.Monad.Extra
  ( whenM,
    unlessM,
    flatten,
    ifM,
    MonadPlus (..),
    module Control.Monad,
  )
where

import Control.Monad hiding (join)
import qualified Control.Monad as Monad
import Prelude

whenM :: (Monad m) => m Bool -> m () -> m ()
whenM cond f = do
  c <- cond
  when c f

unlessM :: (Monad m) => m Bool -> m () -> m ()
unlessM cond f = do
  c <- cond
  unless c f

flatten :: (Monad m) => m (m a) -> m a
flatten = Monad.join

ifM :: (Monad m) => m Bool -> m a -> m a -> m a
ifM cond ifTrue ifFalse = do
  c <- cond
  if c then ifTrue else ifFalse