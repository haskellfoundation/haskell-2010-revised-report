{-# OPTIONS_HADDOCK hide #-}
module Data.Tuple
  ( fst,
    snd,
    curry,
    uncurry,
  )
where

fst :: (a, b) -> a
fst = fst

snd :: (a, b) -> b
snd = snd

curry :: ((a, b) -> c) -> a -> b -> c
curry = curry

uncurry :: (a -> b -> c) -> ((a, b) -> c)
uncurry = uncurry