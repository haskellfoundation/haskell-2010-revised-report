{-# OPTIONS_HADDOCK hide #-}
module Prim (Char, Float, Double, Integer) where

-- | The character type @Char@ is an enumeration whose values represent Unicode (or equivalently ISO/IEC
-- 10646) characters (see http://www.unicode.org/ for details). This set extends the ISO 8859-1
-- (Latin-1) character set (the first 256 charachers), which is itself an extension of the ASCII character set
-- (the first 128 characters). A character literal in Haskell has type @Char@.
-- To convert a @Char@ to or from the corresponding @Int@ value defined by Unicode, use @Prelude.toEnum@
-- and @Prelude.fromEnum@ from the @Prelude.Enum@ class respectively (or equivalently @ord@ and @chr@).
data Char = AbstractChar

data Float = AbstractFloat

data Double = AbstractDouble

data Integer = AbstractInteger
