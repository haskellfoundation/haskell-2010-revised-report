{-# OPTIONS_HADDOCK hide #-}
module Data.Function
  ( id,
    const,
    (.),
    flip,
    ($),
  )
where

id :: a -> a
id = id

const :: a -> b -> a
const = const

infixr 9 .

(.) :: (b -> c) -> (a -> b) -> a -> c
(.) = (.)

flip :: (a -> b -> c) -> b -> a -> c
flip = flip

infixr 0 $

($) :: (a -> b) -> a -> b
($) = ($)