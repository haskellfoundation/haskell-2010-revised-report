{-# OPTIONS_HADDOCK hide #-}
module Data.Bool where

infixr 3 &&

infixr 2 ||

data Bool = False | True

(&&) :: Bool -> Bool -> Bool
(&&) = (&&)

(||) :: Bool -> Bool -> Bool
(||) = (||)

not :: Bool -> Bool
not = not

otherwise :: Bool
otherwise = otherwise
