{-# OPTIONS_HADDOCK hide #-}
module NumHierarchy where

import Data.Bool
import Data.Enum
import Data.Eq
import Data.Int
import Data.Ord
import Data.Word
import Prim
import Text.Read
import Text.Show

-- Data.Ratio
-- Must be defined together with the Num typeclasses

-- | Rational numbers, with numerator and denominator of some @Integral@ type.
data (Integral a) => Ratio a = AbstractRatio

instance (Integral a) => Enum (Ratio a)

instance (Integral a) => Eq (Ratio a)

instance (Integral a) => Fractional (Ratio a)

instance (Integral a) => Num (Ratio a)

instance (Integral a) => Ord (Ratio a)

instance (Integral a, Read a) => Read (Ratio a)

instance (Integral a) => Real (Ratio a)

instance (Integral a) => RealFrac (Ratio a)

instance (Integral a) => Show (Ratio a)

-- | Arbitrary-precision rational numbers, represented as a ratio of two @Integer@ values. A rational number
-- may be constructed using the @%@ operator.
type Rational = Ratio Integer

infixl 7 %

-- | Forms the ratio of two integral numbers.
(%) :: (Integral a) => a -> a -> Ratio a
(%) = (%)

-- | Extract the numerator of the ratio in reduced form: the numerator and denominator have no common
-- factor and the denominator is positive.
numerator :: (Integral a) => Ratio a -> a
numerator = numerator

-- | Extract the denominator of the ratio in reduced form: the numerator and denominator have no common
-- factor and the denominator is positive.
denominator :: (Integral a) => Ratio a -> a
denominator = denominator

-- | @approxRational@, applied to two real fractional numbers @x@ and @epsilon@, returns the simplest rational
-- number within @epsilon@ of @x@. A rational number @y@ is said to be simpler than another @y’@ if
--
-- * @abs (numerator y) <= abs (numerator y’)@, and
-- * @denominator y <= denominator y’@.
--
-- Any real interval contains a unique simplest rational; in particular, note that @0/1@ is the simplest rational
-- of all.
approxRational :: (RealFrac a) => a -> a -> Rational
approxRational = approxRational

-- Numeric classes

infixl 6 +, -

infixl 7 *

class (Eq a, Show a) => Num a where
  (+), (-), (*) :: a -> a -> a
  negate :: a -> a
  abs, signum :: a -> a
  fromInteger :: Integer -> a

instance Num Integer

instance Num Int

instance Num Int8

instance Num Int16

instance Num Int32

instance Num Int64

instance Num Word

instance Num Word8

instance Num Word16

instance Num Word32

instance Num Word64

instance Num Float

instance Num Double

class (Num a, Ord a) => Real a where
  toRational :: a -> Rational

instance Real Word

instance Real Word8

instance Real Word16

instance Real Word32

instance Real Word64

instance Real Integer

instance Real Int

instance Real Int8

instance Real Int16

instance Real Int32

instance Real Int64

instance Real Float

instance Real Double

class (Real a, Enum a) => Integral a where
  quot, rem :: a -> a -> a
  div, mod :: a -> a -> a
  quotRem, divMod :: a -> a -> (a, a)
  toInteger :: a -> Integer

instance Integral Word

instance Integral Word8

instance Integral Word16

instance Integral Word32

instance Integral Word64

instance Integral Integer

instance Integral Int

instance Integral Int8

instance Integral Int16

instance Integral Int32

instance Integral Int64

infixl 7 /, `quot`, `rem`, `div`, `mod`

class (Num a) => Fractional a where
  (/) :: a -> a -> a
  recip :: a -> a
  fromRational :: Rational -> a

instance Fractional Float

instance Fractional Double

infixr 8 **

class (Fractional a) => Floating a where
  pi :: a
  exp, log, sqrt :: a -> a
  (**), logBase :: a -> a -> a
  sin, cos, tan :: a -> a
  asin, acos, atan :: a -> a
  sinh, cosh, tanh :: a -> a
  asinh, acosh, atanh :: a -> a

instance Floating Float

instance Floating Double

class (Real a, Fractional a) => RealFrac a where
  properFraction :: (Integral b) => a -> (b, a)
  truncate, round :: (Integral b) => a -> b
  ceiling, floor :: (Integral b) => a -> b

instance RealFrac Float

instance RealFrac Double

class (RealFrac a, Floating a) => RealFloat a where
  floatRadix :: a -> Integer
  floatDigits :: a -> Int
  floatRange :: a -> (Int, Int)
  decodeFloat :: a -> (Integer, Int)
  encodeFloat :: Integer -> Int -> a
  exponent :: a -> Int
  significand :: a -> a
  scaleFloat :: Int -> a -> a
  isNaN :: a -> Bool
  isInfinite :: a -> Bool
  isDenormalized :: a -> Bool
  isNegativeZero :: a -> Bool
  isIEEE :: a -> Bool
  atan2 :: a -> a -> a

instance RealFloat Float

instance RealFloat Double
