-- |
-- Module: Data.Ix
module Data.Ix
  ( -- * The Ix class
    Ix (range, index, inRange, rangeSize),
  )
where

import Data.Bool
import Data.Int
import Data.Ord
import Data.Word
import Prim

-- | The @Ix@ class is used to map a contiguous subrange of values in a type onto integers. It is used primarily
-- for array indexing (see the array package).
--
-- The first argument @(l,u)@ of each of these operations is a pair specifying the lower and upper bounds
-- of a contiguous subrange of values.
--
-- An implementation is entitled to assume the following laws about these operations:
--
-- * @inRange (l,u) i == elem i (range (l,u))@
-- * @range (l,u) !! index (l,u) i == i, when inRange (l,u) i@
-- * @map (index (l,u)) (range (l,u))) == [0..rangeSize (l,u)-1]@
-- * @rangeSize (l,u) == length (range (l,u))@
--
-- Minimal complete instance: @range@, @index@ and @inRange@.
class (Ord a) => Ix a where
  -- | The list of values in the subrange defined by a bounding pair.
  range :: (a, a) -> [a]

  -- | The position of a subscript in the subrange.
  index :: (a, a) -> a -> Int

  -- | Returns @True@ the given subscript lies in the range defined the bounding pair.
  inRange :: (a, a) -> a -> Bool

  -- | The size of the subrange defined by a bounding pair.
  rangeSize :: (a, a) -> Int

instance Ix Char

instance Ix Bool

instance Ix Ordering

instance Ix ()

instance Ix Integer

instance Ix Int

instance Ix Int8

instance Ix Int16

instance Ix Int32

instance Ix Int64

instance Ix Word

instance Ix Word8

instance Ix Word16

instance Ix Word32

instance Ix Word64

instance (Ix a, Ix b) => Ix (a, b)

instance (Ix a1, Ix a2, Ix a3) => Ix (a1, a2, a3)

instance (Ix a1, Ix a2, Ix a3, Ix a4) => Ix (a1, a2, a3, a4)

instance (Ix a1, Ix a2, Ix a3, Ix a4, Ix a5) => Ix (a1, a2, a3, a4, a5)