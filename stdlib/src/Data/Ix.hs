-- |
-- Module: Data.Ix
module Data.Ix
  ( -- * The Ix class
    Ix (range, index, inRange, rangeSize),

    -- * Deriving Instances of Ix

    -- | It is possible to derive an instance of 'Ix' automatically, using a @deriving@ clause on a @data@ declaration.
    -- Such derived instance declarations for the class 'Ix' are only possible for enumerations (i.e. datatypes having only nullary constructors) and single-constructor datatypes, whose constituent types are instances of 'Ix'.
    -- A Haskell implementation must provide 'Ix' instances for tuples up to at least size 15.
    --
    -- For an /enumeration/, the nullary constructors are assumed to be numbered left-to-right with the indices being 0 to n-1 inclusive. This is the same numbering defined by the 'Enum' class. For example, given the datatype:
    --
    -- @
    -- data Colour = Red | Orange | Yellow | Green | Blue | Indigo | Violet
    -- @
    --
    -- we would have:
    --
    -- @
    -- range   (Yellow,Blue)        ==  [Yellow,Green,Blue]
    -- index   (Yellow,Blue) Green  ==  1
    -- inRange (Yellow,Blue) Red    ==  False
    -- @
    --
    -- For /single-constructor datatypes/, the derived instance declarations are as shown for tuples:
    --
    -- @
    --  instance  (Ix a, Ix b)  => Ix (a,b) where
    --          range ((l,l'),(u,u'))
    --                  = [(i,i') | i <- range (l,u), i' <- range (l',u')]
    --          index ((l,l'),(u,u')) (i,i')
    --                  =  index (l,u) i * rangeSize (l',u') + index (l',u') i'
    --          inRange ((l,l'),(u,u')) (i,i')
    --                  = inRange (l,u) i && inRange (l',u') i'
    --
    --  -- Instances for other tuples are obtained from this scheme:
    --  --
    --  --  instance  (Ix a1, Ix a2, ... , Ix ak) => Ix (a1,a2,...,ak)  where
    --  --      range ((l1,l2,...,lk),(u1,u2,...,uk)) =
    --  --          [(i1,i2,...,ik) | i1 <- range (l1,u1),
    --  --                            i2 <- range (l2,u2),
    --  --                            ...
    --  --                            ik <- range (lk,uk)]
    --  --
    --  --      index ((l1,l2,...,lk),(u1,u2,...,uk)) (i1,i2,...,ik) =
    --  --        index (lk,uk) ik + rangeSize (lk,uk) * (
    --  --         index (lk-1,uk-1) ik-1 + rangeSize (lk-1,uk-1) * (
    --  --          ...
    --  --           index (l1,u1)))
    --  --
    --  --      inRange ((l1,l2,...lk),(u1,u2,...,uk)) (i1,i2,...,ik) =
    --  --          inRange (l1,u1) i1 && inRange (l2,u2) i2 &&
    --  --              ... && inRange (lk,uk) ik
    -- @
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