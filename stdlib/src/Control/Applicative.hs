
module Control.Applicative
  ( Applicative(pure, (<*>), liftA2, (<*), (*>))
  ) where

import Data.Function
import Data.Functor
import Data.Maybe
import System.IO

class (Functor f) => Applicative f where
  pure :: a -> f a

  (<*>) :: f (a -> b) -> f a -> f b
  (<*>) = liftA2 (\f a -> f a)
  
  liftA2 :: (a -> b -> c) -> f a -> f b -> f c
  liftA2 f x = (<*>) (fmap f x)
  
  (<*) :: f a -> f b -> f a
  u <* v = liftA2 const u v
  
  (*>) :: f a -> f b -> f b
  u *> v = (id <$ u) <*> v

instance Applicative []

instance Applicative IO

instance Applicative Maybe
