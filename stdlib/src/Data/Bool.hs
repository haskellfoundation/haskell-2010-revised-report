{-# OPTIONS_HADDOCK hide #-}
module Data.Bool where

infixr 3 &&

infixr 2 ||

data Bool = False | True

-- | Boolean "and", lazy in the second argument
--
-- === __Specification:__
--
-- @
-- True && x = x
-- False && _ = False
-- @
(&&) :: Bool -> Bool -> Bool
(&&) = (&&)

-- | Boolean "or", lazy in the second argument
--
-- === __Specification:__
--
-- @
-- True || _ = True
-- False || x = x
-- @
(||) :: Bool -> Bool -> Bool
(||) = (||)

-- | Boolean "not"
--
-- === __Specification:__
--
-- @
-- not True = False
-- not False = True
-- @
not :: Bool -> Bool
not = not

-- | 'otherwise' is defined as the value 'True'. It helps to make guards more readable, e.g.
--
-- @
-- f x | x < 0     = ...
--     | otherwise = ...
-- @
--
-- === __Specification:__
--
-- @
-- otherwise = True
-- @
otherwise :: Bool
otherwise = otherwise
