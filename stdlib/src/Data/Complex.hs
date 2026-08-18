-- |
-- Module: Data.Complex
module Data.Complex
  ( -- * Rectangular form
    Complex ((:+)),
    realPart,
    imagPart,
    -- * Polar form
    mkPolar,
    cis,
    polar,
    magnitude,
    phase,
    -- * Conjugate
    conjugate,
  )
where

import Prelude

infix 6 :+

-- | Complex numbers are an algebraic type.
--
-- For a complex number @z@, @abs z@ is a number with the magnitude of @z@, but oriented in the positive real
-- direction, whereas @signum z@ has the phase of @z@, but unit magnitude.
data (RealFloat a) => Complex a
  = !a :+ !a -- ^ forms a complex number from its real and imaginary rectangular components.

instance (RealFloat a) => Eq (Complex a)

instance (RealFloat a) => Floating (Complex a)

instance (RealFloat a) => Fractional (Complex a)

instance (RealFloat a) => Num (Complex a)

instance (Read a, RealFloat a) => Read (Complex a)

instance (RealFloat a) => Show (Complex a)

-- | Extracts the real part of a complex number.
realPart :: (RealFloat a) => Complex a -> a
realPart = realPart

-- | Extracts the imaginary part of a complex number.
imagPart :: (RealFloat a) => Complex a -> a
imagPart = imagPart

-- | Form a complex number from polar components of magnitude and phase.
mkPolar :: (RealFloat a) => a -> a -> Complex a
mkPolar = mkPolar

-- | cis t is a complex value with magnitude 1 and phase t (modulo 2 * pi).
cis :: (RealFloat a) => a -> Complex a
cis = cis

-- | The function polar takes a complex number and returns a (magnitude, phase) pair in canonical form: the magnitude is nonnegative, and the phase in the range (-pi, pi]; if the magnitude is zero, then so is the phase.
polar :: (RealFloat a) => Complex a -> (a, a)
polar = polar

-- | The nonnegative magnitude of a complex number.
magnitude :: (RealFloat a) => Complex a -> a
magnitude = magnitude

-- | The phase of a complex number, in the range (-pi, pi]. If the magnitude is zero, then so is the phase.
phase :: (RealFloat a) => Complex a -> a
phase = phase

-- | The conjugate of a complex number.
conjugate :: (RealFloat a) => Complex a -> Complex a
conjugate = conjugate