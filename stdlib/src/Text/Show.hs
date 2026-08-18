{-# OPTIONS_HADDOCK hide #-}
module Text.Show where

import Data.Bool
import Data.Int
import Data.String
import Data.Word
import Prim

type ShowS = String -> String

class Show a where
  showsPrec :: Int -> a -> ShowS
  show :: a -> String
  showList :: [a] -> ShowS

instance Show Int

instance Show Int8

instance Show Int16

instance Show Int32

instance Show Int64

instance Show Word

instance Show Word8

instance Show Word16

instance Show Word32

instance Show Word64

instance Show Integer

instance Show Float

instance Show Double

instance Show ()

instance Show Char

instance (Show a) => Show [a]

instance (Show a, Show b) => Show (a, b)

shows :: (Show a) => a -> ShowS
shows = shows

showChar :: Char -> ShowS
showChar = showChar

showString :: String -> ShowS
showString = showString

showParen :: Bool -> ShowS -> ShowS
showParen = showParen
