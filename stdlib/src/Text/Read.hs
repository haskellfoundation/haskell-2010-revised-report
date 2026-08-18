{-# OPTIONS_HADDOCK hide #-}
module Text.Read where

import Data.Bool
import Data.Int
import Data.String
import Data.Word
import Prim

type ReadS a = String -> [(a, String)]

class Read a where
  readsPrec :: Int -> ReadS a
  readList :: ReadS [a]

instance Read Word

instance Read Word8

instance Read Word16

instance Read Word32

instance Read Word64

instance Read Int

instance Read Int8

instance Read Int16

instance Read Int32

instance Read Int64

instance Read Integer

instance Read Float

instance Read Double

instance Read ()

instance Read Char

instance (Read a) => Read [a]

instance (Read a, Read b) => Read (a, b)

read :: (Read a) => String -> a
read = read

reads :: (Read a) => ReadS a
reads = reads

readParen :: Bool -> ReadS a -> ReadS a
readParen = readParen

lex :: ReadS String
lex = lex