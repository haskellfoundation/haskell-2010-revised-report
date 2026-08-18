{-# OPTIONS_HADDOCK hide #-}
module Data.Eq where

import Data.Bool
import Data.Int
import Data.Word
import Prim

infix 4 ==, /=

class Eq a where
  (==) :: a -> a -> Bool
  (/=) :: a -> a -> Bool

instance Eq Char

instance Eq Bool

instance Eq ()

instance Eq Integer

instance Eq Int

instance Eq Int8

instance Eq Int16

instance Eq Int32

instance Eq Int64

instance Eq Word

instance Eq Word8

instance Eq Word16

instance Eq Word32

instance Eq Word64

instance Eq Float

instance Eq Double

-- 2
instance (Eq a, Eq b) => Eq (a, b)

-- 3
instance (Eq a, Eq b, Eq c) => Eq (a, b, c)

-- 4
instance (Eq a, Eq b, Eq c, Eq d) => Eq (a, b, c, d)

-- 5
instance (Eq a, Eq b, Eq c, Eq d, Eq e) => Eq (a, b, c, d, e)

-- 6
instance (Eq a, Eq b, Eq c, Eq d, Eq e, Eq f) => Eq (a, b, c, d, e, f)

-- 7
instance (Eq a, Eq b, Eq c, Eq d, Eq e, Eq f, Eq g) => Eq (a, b, c, d, e, f, g)

-- 8
instance (Eq a, Eq b, Eq c, Eq d, Eq e, Eq f, Eq g, Eq h) => Eq (a, b, c, d, e, f, g, h)

-- 9
instance (Eq a, Eq b, Eq c, Eq d, Eq e, Eq f, Eq g, Eq h, Eq i) => Eq (a, b, c, d, e, f, g, h, i)

-- 10
instance (Eq a, Eq b, Eq c, Eq d, Eq e, Eq f, Eq g, Eq h, Eq i, Eq j) => Eq (a, b, c, d, e, f, g, h, i, j)

-- 11
instance (Eq a, Eq b, Eq c, Eq d, Eq e, Eq f, Eq g, Eq h, Eq i, Eq j, Eq k) => Eq (a, b, c, d, e, f, g, h, i, j, k)

-- 12
instance (Eq a, Eq b, Eq c, Eq d, Eq e, Eq f, Eq g, Eq h, Eq i, Eq j, Eq k, Eq l) => Eq (a, b, c, d, e, f, g, h, i, j, k, l)

-- 13
instance (Eq a, Eq b, Eq c, Eq d, Eq e, Eq f, Eq g, Eq h, Eq i, Eq j, Eq k, Eq l, Eq m) => Eq (a, b, c, d, e, f, g, h, i, j, k, l, m)

-- 14
instance (Eq a, Eq b, Eq c, Eq d, Eq e, Eq f, Eq g, Eq h, Eq i, Eq j, Eq k, Eq l, Eq m, Eq n) => Eq (a, b, c, d, e, f, g, h, i, j, k, l, m, n)

-- 15
instance (Eq a, Eq b, Eq c, Eq d, Eq e, Eq f, Eq g, Eq h, Eq i, Eq j, Eq k, Eq l, Eq m, Eq n, Eq o) => Eq (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o)