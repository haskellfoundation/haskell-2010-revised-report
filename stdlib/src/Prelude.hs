-- |
-- Module: Prelude
module Prelude
  ( -- * Standard types, classes and related functions
    -- ** Basic data types
    Bool (False, True),
    (&&),
    (||),
    not,
    otherwise,
    Maybe (Nothing, Just),
    maybe,
    Either (Left, Right),
    either,
    Ordering (LT, EQ, GT),
    Char,
    String,
    -- *** Tuples
    fst,
    snd,
    curry,
    uncurry,
    -- ** Basic type classes
    Eq ((==), (/=)),
    Ord (compare, (<), (<=), (>=), (>), max, min),
    Enum
      ( succ,
        pred,
        toEnum,
        fromEnum,
        enumFrom,
        enumFromThen,
        enumFromTo,
        enumFromThenTo
      ),
    Bounded (minBound, maxBound),
    -- ** Numbers
    -- *** Numeric types
    Int,
    Integer,
    Float,
    Double,
    Rational,
    -- *** Numeric type classes
    Num ((+), (-), (*), negate, abs, signum, fromInteger),
    Real (toRational),
    Integral (quot, rem, div, mod, quotRem, divMod, toInteger),
    Fractional ((/), recip, fromRational),
    Floating
      ( pi,
        exp,
        log,
        sqrt,
        (**),
        logBase,
        sin,
        cos,
        tan,
        asin,
        acos,
        atan,
        sinh,
        cosh,
        tanh,
        asinh,
        acosh,
        atanh
      ),
    RealFrac (properFraction, truncate, round, ceiling, floor),
    RealFloat
      ( floatRadix,
        floatDigits,
        floatRange,
        decodeFloat,
        encodeFloat,
        exponent,
        significand,
        scaleFloat,
        isNaN,
        isInfinite,
        isDenormalized,
        isIEEE,
        isNegativeZero,
        atan2
      ),
    -- *** Numeric functions
    subtract,
    even,
    odd,
    gcd,
    lcm,
    (^),
    (^^),
    fromIntegral,
    realToFrac,
    -- ** Monads and functors
    Functor (fmap),
    Monad ((>>=), (>>), return, fail),
    mapM,
    mapM_,
    sequence,
    sequence_,
    (=<<),
    -- ** Miscellaneous functions
    id,
    const,
    (.),
    flip,
    ($),
    until,
    asTypeOf,
    error,
    undefined,
    seq,
    ($!),
    -- * List operations
    map,
    (++),
    filter,
    concat,
    concatMap,
    head,
    last,
    tail,
    init,
    null,
    length,
    (!!),
    foldl,
    foldl1,
    scanl,
    scanl1,
    foldr,
    foldr1,
    scanr,
    scanr1,
    iterate,
    repeat,
    replicate,
    cycle,
    take,
    drop,
    splitAt,
    takeWhile,
    dropWhile,
    span,
    break,
    lines,
    words,
    unlines,
    unwords,
    reverse,
    and,
    or,
    any,
    all,
    elem,
    notElem,
    lookup,
    sum,
    product,
    maximum,
    minimum,
    zip,
    zip3,
    zipWith,
    zipWith3,
    unzip,
    unzip3,
    -- * Converting to and from String
    -- ** Converting to String
    ShowS,
    Show (showsPrec, show, showList),
    shows,
    showChar,
    showString,
    showParen,
    -- ** Converting from String
    ReadS,
    Read (readsPrec, readList),
    reads,
    readParen,
    read,
    lex,
    -- * Basic Input and output
    IO,
    -- ** Simple I/O operations
    -- *** Output functions
    putChar,
    putStr,
    putStrLn,
    print,
    -- *** Input functions
    getChar,
    getLine,
    getContents,
    interact,
    -- *** Files
    FilePath,
    readFile,
    writeFile,
    appendFile,
    readIO,
    readLn,
    -- ** Exception handling in the I/O monad
    IOError,
    ioError,
    userError,
    catch,
  )
where

import Control.Monad
import Data.Bool
import Data.Char
import Data.Either
import Data.Enum
import Data.Eq
import Data.Function
import Data.Int
import Data.List
import Data.Maybe
import Data.Ord
import Data.Ratio (Rational)
import Data.String
import Data.Tuple
import NumHierarchy
import Prim
import System.IO
import System.IO.Error
import Text.Read
import Text.Show

-- Standard types, classes, instances and related functions

-- Numeric functions

subtract :: (Num a) => a -> a -> a
subtract = undefined

even :: (Integral a) => a -> Bool
even = even

odd :: (Integral a) => a -> Bool
odd = odd

gcd :: (Integral a) => a -> a -> a
gcd = gcd

lcm :: (Integral a) => a -> a -> a
lcm = lcm

infixr 8 ^, ^^

(^) :: (Num a, Integral b) => a -> b -> a
(^) = (^)

(^^) :: (Fractional a, Integral b) => a -> b -> a
(^^) = (^^)

fromIntegral :: (Integral a, Num b) => a -> b
fromIntegral = fromIntegral

realToFrac :: (Real a, Fractional b) => a -> b
realToFrac = undefined

infixr 0 $!, `seq`

seq :: a -> b -> b
seq = seq

($!) :: (a -> b) -> a -> b
f $! x = x `seq` f x

-- Character type

-- Ordering type

-- Standard numeric types.  The data declarations for these types cannot
-- be expressed directly in Haskell since the constructor lists would be
-- far too large.

-- The Enum instances for Floats and Doubles are slightly unusual.
-- The ‘toEnum' function truncates numbers to Int.  The definitions
-- of enumFrom and enumFromThen allow floats to be used in arithmetic
-- series: [0,0.1 .. 0.95].  However, roundoff errors make these somewhat
-- dubious.  This example may have either 10 or 11 elements, depending on
-- how 0.1 is represented.

numericEnumFrom :: (Fractional a) => a -> [a]
numericEnumFrom = numericEnumFrom

numericEnumFromThen :: (Fractional a) => a -> a -> [a]
numericEnumFromThen = numericEnumFromThen

numericEnumFromTo :: (Fractional a, Ord a) => a -> a -> [a]
numericEnumFromTo = numericEnumFromTo

numericEnumFromThenTo :: (Fractional a, Ord a) => a -> a -> a -> [a]
numericEnumFromThenTo = numericEnumFromThenTo

-- Lists

-- data  [a]  =  [] | a : [a]  deriving (Eq, Ord)
-- Not legal Haskell; for illustration only

-- Misc functions

-- until p f  yields the result of applying f until p holds.
until :: (a -> Bool) -> (a -> a) -> a -> a
until = until

-- asTypeOf is a type-restricted version of const.  It is usually used
-- as an infix operator, and its typing forces its first argument
-- (which is usually overloaded) to have the same type as the second.
asTypeOf :: a -> a -> a
asTypeOf = asTypeOf

-- error stops execution and displays an error message

error :: String -> a
error = error

-- It is expected that compilers will recognize this and insert error
-- messages that are more appropriate to the context in which undefined
-- appears.

undefined :: a
undefined = undefined