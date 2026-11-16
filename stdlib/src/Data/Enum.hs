-- |
--  Module: Data.Enum
module Data.Enum where

import Data.Int
import Data.Word
import Prim

class Enum a where
  succ, pred :: a -> a
  toEnum :: Int -> a
  fromEnum :: a -> Int
  enumFrom :: a -> [a]
  enumFromThen :: a -> a -> [a]
  enumFromTo :: a -> a -> [a]
  enumFromThenTo :: a -> a -> a -> [a]

instance Enum Char

instance Enum Word

instance Enum Word8

instance Enum Word16

instance Enum Word32

instance Enum Word64

instance Enum Integer

instance Enum Int

instance Enum Int8

instance Enum Int16

instance Enum Int32

instance Enum Int64

instance Enum Float

instance Enum Double

class Bounded a where
  minBound :: a
  maxBound :: a

instance Bounded Char

instance Bounded Word

instance Bounded Word8

instance Bounded Word16

instance Bounded Word32

instance Bounded Word64

instance Bounded Int

instance Bounded Int8

instance Bounded Int16

instance Bounded Int32

instance Bounded Int64