-- |
-- Module: Control.Monad
--
-- The Control.Monad module provides the `Functor`, `Monad` and `MonadPlus` classes, together with some
-- useful operations on monads.
module Control.Monad
  ( -- * Functor and monad classes
    Functor (fmap),
    Monad ((>>=), (>>), return, fail),
    MonadPlus (mzero, mplus),

    -- * Functions

    -- ** Naming conventions

    -- | The functions in this library use the following naming conventions:
    --
    --  * A postfix ’M’ always stands for a function in the Kleisli category: The monad type constructor m is
    --        added to function results (modulo currying) and nowhere else. So, for example,
    --
    --        @
    --        filter :: (a -> Bool) -> [a] -> [a]
    --        filterM :: (Monad m) => (a -> m Bool) -> [a] -> m [a]
    --        @
    --
    -- * A postfix ’_’ changes the result type from (m a) to (m ()). Thus, for example:
    --
    --        @
    --        sequence :: Monad m => [m a] -> m [a]
    --        sequence_ :: Monad m => [m a] -> m ()
    --        @
    --
    -- * A prefix ’m’ generalizes an existing function to a monadic form. Thus, for example:
    --
    --        @
    --        sum :: Num a => [a] -> a
    --        msum :: MonadPlus m => [m a] -> m a
    --        @

    -- ** Basic `Monad` functions
    mapM,
    mapM_,
    forM,
    forM_,
    sequence,
    sequence_,
    (=<<),
    (>=>),
    (<=<),
    forever,
    void,

    -- ** Generalisations of list functions
    join,
    msum,
    filterM,
    mapAndUnzipM,
    zipWithM,
    zipWithM_,
    foldM,
    foldM_,
    replicateM,
    replicateM_,

    -- ** Conditional execution of monadic expressions
    guard,
    when,
    unless,

    -- ** Monadic lifting operators
    liftM,
    liftM2,
    liftM3,
    liftM4,
    liftM5,
    ap,
  )
where

import Data.Array
import Data.Bool
import Data.Int
import Data.Ix
import Data.Maybe
import Data.String
import System.IO

-- | The Functor class is used for types that can be mapped over. Instances of Functor should satisfy the
-- following laws:
--
-- @
--   fmap id == id
--   fmap (f . g) == fmap f . fmap g
-- @
--
-- The instances of 'Functor' for lists, 'Data.Maybe.Maybe' and 'System.IO.IO' satisfy these laws.
class Functor f where
  fmap :: (a -> b) -> f a -> f b

instance Functor []

instance Functor IO

instance Functor Maybe

infixl 1 >>, >>=

infixr 1 =<<

-- |
-- === Specification:
--
-- @
-- instance  (Ix a)          => Functor (Array a) where  
--     fmap fn (MkArray b f) =  MkArray b (fn . f) 
-- @
instance (Ix i) => Functor (Array i)

-- | The Monad class defines the basic operations over a monad, a concept from a branch of mathematics
-- known as category theory. From the perspective of a Haskell programmer, however, it is best to think
-- of a monad as an abstract datatype of actions. Haskell’s do expressions provide a convenient syntax
-- for writing monadic expressions.
--
-- Minimal complete definition: >>= and return.
--
-- Instances of 'Monad' should satisfy the following laws:
--
-- @
--   return a >>= k == k a
--   m >>= return == m
--   m >>= (\x -> k x >>= h) == (m >>= k) >>= h
-- @
--
-- Instances of both 'Monad' and 'Functor' should additionally satisfy the law:
--
-- @
--   fmap f xs == xs >>= return . f
-- @
--
-- The instances of 'Monad' for lists, 'Data.Maybe.Maybe' and 'System.IO.IO' defined in the Prelude
-- satisfy these laws.
class Monad m where
  -- | Sequentially compose two actions, passing any value produced by the first as an argument to the
  -- second.
  (>>=) :: m a -> (a -> m b) -> m b

  -- | Sequentially compose two actions, discarding any value produced by the first, like sequencing
  -- operators (such as the semicolon) in imperative languages.
  (>>) :: m a -> m b -> m b

  -- | Inject a value into the monadic type.
  return :: a -> m a

  -- | Fail with a message. This operation is not part of the mathematical definition of a monad, but is
  -- invoked on pattern-match failure in a do expression.
  fail :: String -> m a

instance Monad []

instance Monad IO

instance Monad Maybe

-- | Monads that also support choice and failure.
class (Monad m) => MonadPlus m where
  -- | the identity of mplus. It should also satisfy the equations
  --
  -- @
  --  mzero >>= f = mzero
  --  v >> mzero = mzero
  -- @
  mzero :: m a

  -- | an associative operation
  mplus :: m a -> m a -> m a

instance MonadPlus []

instance MonadPlus Maybe

-- | @mapM f@ is equivalent to @sequence . map f@.
mapM :: (Monad m) => (a -> m b) -> [a] -> m [b]
mapM = mapM

-- | @mapM_ f@ is equivalent to @sequence_ . map f@.
mapM_ :: (Monad m) => (a -> m b) -> [a] -> m ()
mapM_ = mapM_

-- | @forM@ is @mapM@ with its arguments flipped
forM :: (Monad m) => [a] -> (a -> m b) -> m [b]
forM = forM

-- | @forM_@ is @mapM_@ with its arguments flipped
forM_ :: (Monad m) => [a] -> (a -> m b) -> m ()
forM_ = forM_

-- | Evaluate each action in the sequence from left to right, and collect the results.
sequence :: (Monad m) => [m a] -> m [a]
sequence = sequence

-- | Evaluate each action in the sequence from left to right, and ignore the results.
sequence_ :: (Monad m) => [m a] -> m ()
sequence_ = sequence_

-- | Same as @>>=@, but with the arguments interchanged.
(=<<) :: (Monad m) => (a -> m b) -> m a -> m b
(=<<) = (=<<)

-- | Left-to-right Kleisli composition of monads.
(>=>) :: (Monad m) => (a -> m b) -> (b -> m c) -> a -> m c
(>=>) = (>=>)

-- | Right-to-left Kleisli composition of monads. @(>=>)@, with the arguments flipped
(<=<) :: (Monad m) => (b -> m c) -> (a -> m b) -> a -> m c
(<=<) = (<=<)

-- | @forever act@ repeats the action infinitely
forever :: (Monad m) => m a -> m b
forever = forever

-- | @void value@ discards or ignores the result of evaluation, such as the return value of an 'IO' action.
void :: (Functor f) => f a -> f ()
void = void

-- | The @join@ function is the conventional monad join operator. It is used to remove one level of monadic
-- structure, projecting its bound argument into the outer level.
join :: (Monad m) => m (m a) -> m a
join = join

-- | This generalizes the list-based @concat@ function.
msum :: (MonadPlus m) => [m a] -> m a
msum = msum

-- | This generalizes the list-based @filter@ function.
filterM :: (Monad m) => (a -> m Bool) -> [a] -> m [a]
filterM = filterM

-- | The @mapAndUnzipM@ function maps its first argument over a list, returning the result as a pair of lists.
-- This function is mainly used with complicated data structures or a state-transforming monad.
mapAndUnzipM :: (Monad m) => (a -> m (b, c)) -> [a] -> m ([b], [c])
mapAndUnzipM = mapAndUnzipM

-- | The @zipWithM@ function generalizes @zipWith@ to arbitrary monads.
zipWithM :: (Monad m) => (a -> b -> m c) -> [a] -> [b] -> m [c]
zipWithM = zipWithM

-- | @zipWithM_@ is the extension of @zipWithM@ which ignores the final result
zipWithM_ :: (Monad m) => (a -> b -> m c) -> [a] -> [b] -> m ()
zipWithM_ = zipWithM_

-- | The @foldM@ function is analogous to @foldl@, except that its result is encapsulated in a monad. Note that
-- @foldM@ works from left-to-right over the list arguments. This could be an issue where @(>>)@ and the
-- "folded function" are not commutative.
--
-- @
--   foldM f a1 [x1, x2, ..., xm]
-- ==
--   do
--     a2 <- f a1 x1
--     a3 <- f a2 x2
--     ...
--     f am xm
-- @
--
-- If right-to-left evaluation is required, the input list should be reversed.
foldM :: (Monad m) => (a -> b -> m a) -> a -> [b] -> m a
foldM = foldM

-- | Like @foldM@, but discards the result.
foldM_ :: (Monad m) => (a -> b -> m a) -> a -> [b] -> m ()
foldM_ = foldM_

-- | @replicateM n act@ performs the action @n@ times, gathering the results.
replicateM :: (Monad m) => Int -> m a -> m [a]
replicateM = replicateM

-- | Like @replicateM@, but discards the result.
replicateM_ :: (Monad m) => Int -> m a -> m ()
replicateM_ = replicateM_

-- | @guard b@ is @return ()@ if @b@ is @True@, and @mzero@ if @b@ is @False@
guard :: (MonadPlus m) => Bool -> m ()
guard = guard

-- | Conditional execution of monadic expressions. For example,
--
-- @
-- when debug (putStr "Debugging\\n")
-- @
--
-- will output the string @Debugging\\n@ if the Boolean value @debug@ is @True@, and otherwise do nothing.
when :: (Monad m) => Bool -> m () -> m ()
when = when

-- | The reverse of @when@.
unless :: (Monad m) => Bool -> m () -> m ()
unless = unless

-- | Promote a function to a monad.
liftM :: (Monad m) => (a1 -> r) -> m a1 -> m r
liftM = liftM

-- | Promote a function to a monad, scanning the monadic arguments from left to right. For example,
--
-- @
-- liftM2 (+) [0,1] [0,2] = [0,2,1,3]
-- liftM2 (+) (Just 1) Nothing = Nothing
-- @
liftM2 :: (Monad m) => (a1 -> a2 -> r) -> m a1 -> m a2 -> m r
liftM2 = liftM2

-- | Promote a function to a monad, scanning the monadic arguments from left to right (cf. @liftM2@).
liftM3 :: (Monad m) => (a1 -> a2 -> a3 -> r) -> m a1 -> m a2 -> m a3 -> m r
liftM3 = liftM3

-- | Promote a function to a monad, scanning the monadic arguments from left to right (cf. @liftM2@).
liftM4 ::
  (Monad m) =>
  (a1 -> a2 -> a3 -> a4 -> r) ->
  m a1 ->
  m a2 ->
  m a3 ->
  m a4 ->
  m r
liftM4 = liftM4

-- | Promote a function to a monad, scanning the monadic arguments from left to right (cf. @liftM2@).
liftM5 ::
  (Monad m) =>
  (a1 -> a2 -> a3 -> a4 -> a5 -> r) ->
  m a1 ->
  m a2 ->
  m a3 ->
  m a4 ->
  m a5 ->
  m r
liftM5 = liftM5

-- | In many situations, the @liftM@ operations can be replaced by uses of @ap@, which promotes function
-- application.
--
-- @
-- return f \`ap\` x1 \`ap\` ... \`ap\` xn
-- @
--
-- is equivalent to
--
-- @
-- liftMn f x1 x2 ... xn
-- @
ap :: (Monad m) => m (a -> b) -> m a -> m b
ap = ap