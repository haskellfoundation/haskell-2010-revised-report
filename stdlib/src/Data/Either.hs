{-# OPTIONS_HADDOCK hide #-}
-- |
-- Module: Data.Either
module Data.Either (Either (Left, Right), either) where

data Either a b = Left a | Right b

either :: (a -> c) -> (b -> c) -> Either a b -> c
either f g (Left x) = f x
either f g (Right y) = g y