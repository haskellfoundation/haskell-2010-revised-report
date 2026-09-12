{-# OPTIONS_HADDOCK hide #-}
-- |
-- Module: Data.Either
module Data.Either (Either (Left, Right), either) where

data Either a b = Left a | Right b

-- | Case analysis for the 'Either' type.
-- If the value is @'Left' a@, apply the first function to @a@;
-- if it is @'Right' b@, apply the second function to @b@.
--
-- === __Specification:__
--
-- @
-- either f g (Left x)  =  f x  
-- either f g (Right y) =  g y 
-- @
either :: (a -> c) -> (b -> c) -> Either a b -> c
either f g (Left x) = f x
either f g (Right y) = g y