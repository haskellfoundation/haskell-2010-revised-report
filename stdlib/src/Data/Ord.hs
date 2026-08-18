{-# OPTIONS_HADDOCK hide #-}
module Data.Ord where

import Data.Bool
import Data.Eq
import Data.Int
import Data.Word
import Prim

infix 4 <, <=, >=, >

data Ordering = LT | EQ | GT

instance Eq Ordering

class (Eq a) => Ord a where
  compare :: a -> a -> Ordering
  (<), (<=), (>=), (>) :: a -> a -> Bool
  max, min :: a -> a -> a

instance Ord Char

instance Ord Bool

instance Ord Ordering

instance Ord ()

instance Ord Integer

instance Ord Int

instance Ord Int8

instance Ord Int16

instance Ord Int32

instance Ord Int64

instance Ord Word

instance Ord Word8

instance Ord Word16

instance Ord Word32

instance Ord Word64

instance Ord Float

instance Ord Double

-- 2
instance (Ord a, Ord b) => Ord (a, b)

-- 3
instance (Ord a, Ord b, Ord c) => Ord (a, b, c)

-- 4
instance (Ord a, Ord b, Ord c, Ord d) => Ord (a, b, c, d)

-- 5
instance (Ord a, Ord b, Ord c, Ord d, Ord e) => Ord (a, b, c, d, e)

-- 6
instance (Ord a, Ord b, Ord c, Ord d, Ord e, Ord f) => Ord (a, b, c, d, e, f)

-- 7
instance (Ord a, Ord b, Ord c, Ord d, Ord e, Ord f, Ord g) => Ord (a, b, c, d, e, f, g)

-- 8
instance (Ord a, Ord b, Ord c, Ord d, Ord e, Ord f, Ord g, Ord h) => Ord (a, b, c, d, e, f, g, h)

-- 9
instance (Ord a, Ord b, Ord c, Ord d, Ord e, Ord f, Ord g, Ord h, Ord i) => Ord (a, b, c, d, e, f, g, h, i)

-- 10
instance (Ord a, Ord b, Ord c, Ord d, Ord e, Ord f, Ord g, Ord h, Ord i, Ord j) => Ord (a, b, c, d, e, f, g, h, i, j)

-- 11
instance (Ord a, Ord b, Ord c, Ord d, Ord e, Ord f, Ord g, Ord h, Ord i, Ord j, Ord k) => Ord (a, b, c, d, e, f, g, h, i, j, k)

-- 12
instance (Ord a, Ord b, Ord c, Ord d, Ord e, Ord f, Ord g, Ord h, Ord i, Ord j, Ord k, Ord l) => Ord (a, b, c, d, e, f, g, h, i, j, k, l)

-- 13
instance (Ord a, Ord b, Ord c, Ord d, Ord e, Ord f, Ord g, Ord h, Ord i, Ord j, Ord k, Ord l, Ord m) => Ord (a, b, c, d, e, f, g, h, i, j, k, l, m)

-- 14
instance (Ord a, Ord b, Ord c, Ord d, Ord e, Ord f, Ord g, Ord h, Ord i, Ord j, Ord k, Ord l, Ord m, Ord n) => Ord (a, b, c, d, e, f, g, h, i, j, k, l, m, n)

-- 15
instance (Ord a, Ord b, Ord c, Ord d, Ord e, Ord f, Ord g, Ord h, Ord i, Ord j, Ord k, Ord l, Ord m, Ord n, Ord o) => Ord (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o)