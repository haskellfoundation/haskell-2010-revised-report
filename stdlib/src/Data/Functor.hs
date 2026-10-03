module Data.Functor
  ( Functor(fmap, (<$))
  , (<$>)
  ) where

import Data.Maybe
import System.IO

-- | The Functor class is used for types that can be mapped over. Instances of Functor should satisfy the
-- following laws:
--
-- @
--   fmap id == id
--   fmap (f . g) == fmap f . fmap g
-- @
--
-- The instances of 'Functor' for lists, 'Data.Maybe.Maybe' and 'System.IO.IO' satisfy these laws.
class Functor f where
  fmap :: (a -> b) -> f a -> f b
  (<$) :: a -> f b -> f a
  (<$) = fmap . const


instance Functor []

instance Functor IO

instance Functor Maybe

instance (Ix i) => Functor (Array i)

infixl 4 <$>
-- | An infix synonym for 'fmap'.
(<$>) :: Functor f => (a -> b) -> f a -> f b
(<$>) = fmap
