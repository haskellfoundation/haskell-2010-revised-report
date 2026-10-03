
module Control.Applicative
  ( Applicative(pure, (<*>), liftA2, (<*), (*>))
  ) where

import Data.Functor
import Data.Maybe
import System.IO

class (Functor f) => Applicative f where
  pure :: a -> f a

  (<*>) :: f (a -> b) -> f a -> f b
  (<*>) = liftA2 id
  
  liftA2 :: (a -> b -> c) -> f a -> f b -> f c
  liftA2 f x = (<*>) (fmap f x)
  
  (<*) :: f a -> f b -> f a
  (<*) = liftA2 const
  
  (*>) :: f a -> f b -> f b
  a1 *> a2 = (id <$ a1) <*> a2

instance Applicactive []

instance Applicactive IO

instance Applicactive Maybe
