#import "@preview/cetz:0.5.1"

The Haskell Prelude contains predefined classes, types,
and functions that are implicitly imported into every Haskell
program.  In this chapter, we describe the types and classes found in
the Prelude.
Most functions are not described in detail here as they
can easily be understood from their definitions as given in @chapter:standard-prelude.
Other predefined types such as arrays, complex numbers, and rationals
are defined in part:libraries[Part]

== Standard Haskell Types <sec:standard-haskell-types>

These types are defined by the Haskell Prelude.  Numeric types are described in @sec:numbers
When appropriate, the Haskell
definition of the type is given.  Some definitions may not be
completely valid on syntactic grounds but they faithfully convey the
meaning of the underlying type.

=== Booleans <subsec:booleans>

```haskell
data  Bool  =  False | True deriving
                             (Read, Show, Eq, Ord, Enum, Bounded)
```

The boolean type `Bool` is an enumeration.
The basic boolean functions are `&&` (and), `||` (or), and `not`.
The name `otherwise` is defined as `True` to make guarded expressions
more readable.

=== Characters and Strings <subsec:characters>

The character type `Char` is an enumeration whose values represent Unicode characters @Unicode.
The lexical syntax for
characters is defined in @sec:lexemes-char; character
literals are nullary constructors in the datatype `Char`.  Type `Char`
is an instance of the classes `Read`, `Show`, `Eq`, `Ord`, `Enum`, and `Bounded`.
The `toEnum` and `fromEnum` functions,
standard functions from class `Enum`, map characters to and from the
`Int` type.

Note that ASCII control characters each have several representations
in character literals: numeric escapes, ASCII mnemonic escapes,
and the `\^X` notation.
In addition, there are the following equivalences:
`\a` and `\BEL`, `\b` and `\BS`, `\f` and `\FF`, `\r` and `\CR`, `\t` and `\HT`, `\v` and `\VT`, and `\n` and `\LF`.

A _string_ is a list of characters:
```haskell
type  String  =  [Char]
```

Strings may be abbreviated using the lexical syntax described in
@sec:lexemes-char.  For example, `"A string"` abbreviates
```haskell
['A', ' ', 's', 't', 'r', 'i', 'n', 'g']
```

=== Lists <subsec:basic-lists>

```haskell
data  [a]  =  [] | a : [a]  deriving (Eq, Ord)
```

Lists are an algebraic datatype of two constructors, although
with special syntax, as described in @sec:lists.
The first constructor is the null list, written `'[]'` ("nil"),
and the second is `':'` ("cons").
The module `PreludeList` (see @sec:preludelist)
defines many standard list functions.
Arithmetic sequences
and list comprehensions,
two convenient
syntaxes for special kinds of lists, are described in
@sec:arithmetic-sequences and @sec:list-comprehensions,
respectively.
Lists are an instance of classes `Read`, `Show`, `Eq`, `Ord`, `Monad`, `Functor`, and `MonadPlus`.

=== Tuples <subsec:basic-tuples>

Tuples are algebraic datatypes with special syntax, as defined
in @sec:tuple-expression.  Each tuple type has a single constructor.
All tuples are instances of `Eq`, `Ord`, `Bounded`, `Read`,
and `Show` (provided, of course, that all their component types are).

There is no upper bound on the size of a tuple, but some Haskell
implementations may restrict the size of tuples, and limit the
instances associated with larger tuples.  However, every Haskell
implementation must support tuples up to size 15, together with the instances
for `Eq`, `Ord`, `Bounded`, `Read`, and `Show`.  
The Prelude and
libraries define tuple functions such as `zip` for tuples up to a size
of 7.

The constructor for a tuple is written by omitting the expressions
surrounding the commas; thus `(x,y)` and `(,) x y` produce the same
value. The same holds for tuple type constructors; thus, `(Int,Bool,Int)`
and `(,,) Int Bool Int` denote the same type.

The following functions are defined for pairs (2-tuples):
`fst`, `snd`, `curry`, and `uncurry`.  Similar functions are not predefined for larger tuples.

=== The Unit Datatype <subsec:basic-trivial>

```haskell
data  () = () deriving (Eq, Ord, Bounded, Enum, Read, Show)
```

The unit datatype `()` has one non-$bot$ member, the nullary constructor `()`.  See also @sec:unit-expression.

=== Function Types

Functions are an abstract type: no constructors directly create
functional values.  The following simple functions are found in the Prelude:
`id`, `const`, `(.)`, `flip`, `($)`, and `until`.

=== The IO and IOError Types

The `IO` type serves as a tag for operations (actions) that interact
with the outside world.  The `IO` type is abstract: no constructors are
visible to the user.  `IO` is an instance of the `Monad` and `Functor`
classes.  @chapter:basic-input-output describes I/O operations.

`IOError` is an abstract type representing errors raised by I/O
operations.  It is an instance of `Show` and `Eq`.  Values of this type
are constructed by the various I/O functions and are not presented in
any further detail in this report.  The Prelude contains a few
I/O functions (defined in @sec:preludeio), and part:libraries[Part]
contains many more.

=== Other Types

```haskell
data  Maybe a     =  Nothing | Just a  deriving (Eq, Ord, Read, Show)
data  Either a b  =  Left a | Right b  deriving (Eq, Ord, Read, Show)
data  Ordering    =  LT | EQ | GT deriving
                                  (Eq, Ord, Bounded, Enum, Read, Show)
```

The `Maybe` type is an instance of classes `Functor`, `Monad`,
and `MonadPlus`.  The `Ordering` type is used by `compare` in the class `Ord`. The functions `maybe` and `either` are found in
the Prelude.

== Strict Evaluation <sec:strict-eval>

Function application in Haskell is non-strict; that is, a function
argument is evaluated only when required.  Sometimes it is desirable to
force the evaluation of a value, using the `seq` function:
```haskell
seq :: a -> b -> b
```
The function `seq` is defined by the equations:
$
  italic("seq") bot med b &= bot \
  italic("seq") a med b &= b quad (text("if") a eq.not bot)
$

`seq` is usually introduced to improve performance by
avoiding unneeded laziness.  Strict datatypes (see
@sec:datatype-decls) are defined in terms of the `$!` operator.
However, the provision of `seq` has important semantic consequences, because it is available
_at every type_.
As a consequence, $bot$ is
not the same as `\x ->` $bot$, since `seq` can be used to distinguish them.
For the same reason, the existence of `seq` weakens Haskell's parametricity properties.

The operator `$!` is strict (call-by-value) application, and is defined
in terms of `seq`.  The Prelude also defines the `$` operator to perform non-strict application.
```haskell
infixr 0 $, $!
($), ($!) :: (a -> b) -> a -> b
f $  x   =          f x
f $! x   =  x `seq` f x
```
The non-strict application operator `$` may appear redundant, since
ordinary application `(f x)` means the same as `(f $ x)`.
However, `$` has low, right-associative binding precedence,
so it sometimes allows parentheses to be omitted; for example:
```haskell
f $ g $ h x  =  f (g (h x))
```
It is also useful in higher-order situations, such as `map ($ 0) xs`,
or `zipWith ($) fs xs`.

== Standard Haskell Classes

@fig:standard-classes shows the hierarchy of
Haskell classes defined in the Prelude and the Prelude types that
are instances of these classes.

// Cf. https://forum.typst.app/t/how-to-export-cetz-diagrams-in-html/3034/5
#let drawing(..args) = {
  let canvas = cetz.canvas(..args)
  context if target() == "html" {
    html.frame(canvas)
  } else {
    canvas
  }
}

#figure(
  caption: "Standard Haskell Classes",
  drawing({    
    import cetz.draw: *
      let ellipse_size = (60pt, 40pt)
      // Eq
      let eq_pos = (0,0)
      circle(eq_pos, radius: ellipse_size, name: "eq")
      content(eq_pos, [#set align(center); *Eq*\ All except IO, (->)])
      // Show
      let show_pos = (5,0)
      circle(show_pos, radius: ellipse_size, name: "show")
      content(show_pos, [#set align(center);*Show*\ All except IO, (->)])
      // Read
      let read_pos = (10,0)
      circle(read_pos, radius: ellipse_size, name: "read")
      content(read_pos, [#set align(center);*Read*\ All except IO, (->)])
      // Ord
      let ord_pos = (0,-4)
      circle(ord_pos, radius: ellipse_size, name: "ord")
      content(ord_pos, [#set align(center);*Ord*\ All except (->)\ IO, IOError])
      // Num
      let num_pos = (5,-4)
      circle(num_pos, radius: ellipse_size, name: "num")
      content(num_pos, [#set align(center);*Num*\ Int, Integer\ Float, Double])
      // Bounded
      let bounded_pos = (10,-4)
      circle(bounded_pos, radius: ellipse_size, name: "bounded")
      content(bounded_pos, [#set align(center);*Bounded*\ Int, Char, Bool, ()\ Ordering, tuples])
      // Enum
      let enum_pos = (0,-8)
      circle(enum_pos, radius: ellipse_size, name: "enum")
      content(enum_pos, [#set align(center);*Enum*\ (), Bool, Char, Ordering,\ Int, Integer, Float,\ Double])
      // Real
      let real_pos = (5,-8)
      circle(real_pos, radius: ellipse_size, name: "real")
      content(real_pos, [#set align(center);*Real*\ Int, Integer\ Float, Double])
      // Fractional
      let fractional_pos = (10,-8)
      circle(fractional_pos, radius: ellipse_size, name: "fractional")
      content(fractional_pos, [#set align(center);*Fractional*\ Float, Double])
      // Integral
      let integral_pos = (0,-12)
      circle(integral_pos, radius: ellipse_size, name: "integral")
      content(integral_pos, [#set align(center);*Integral*\ Int, Integer])
      // RealFrac
      let realfrac_pos = (5,-12)
      circle(realfrac_pos, radius: ellipse_size, name: "realfrac")
      content(realfrac_pos, [#set align(center);*RealFrac*\ Float, Double])
      // Floating
      let floating_pos = (10,-12)
      circle(floating_pos, radius: ellipse_size, name: "floating")
      content(floating_pos, [#set align(center);*Floating*\ Float, Double])
      // RealFloat
      let realfloat_pos = (7.5,-16)
      circle(realfloat_pos, radius: ellipse_size, name: "realfloat")
      content(realfloat_pos, [#set align(center);*RealFloat*\ Float, Double])
      // Monad
      let monad_pos = (2.5,-20)
      circle(monad_pos, radius: ellipse_size, name: "monad")
      content(monad_pos, [#set align(center);*Monad*\ IO,`[]`,Maybe])
      // Functor
      let functor_pos = (7.5,-20)
      circle(functor_pos, radius: ellipse_size, name: "functor")
      content(functor_pos, [#set align(center);*Functor*\ IO,`[]`,Maybe])

      // Superclasses
      set-style(mark: (end: ">", fill: black))
      line("eq", "ord")
      line("eq", "num")
      line("show", "num")
      line("ord", "real")
      line("num", "real")
      line("num", "fractional")
      line("enum", "integral")
      line("real", "integral")
      line("real", "realfrac")
      line("fractional", "realfrac")
      line("fractional", "floating")
      line("realfrac", "realfloat")
      line("floating", "realfloat")
    }
  )
)<fig:standard-classes>

Default class method declarations (@sec:type-classes) are provided
for many of the methods in standard classes.  A comment with each
`class` declaration in @chapter:standard-prelude specifies the
smallest collection of method definitions that, together with the
default declarations, provide a reasonable definition for all the
class methods.  If there is no such comment, then all class methods
must be given to fully specify an instance.



=== The Eq Class <subsec:eq-class>

```haskell
class  Eq a  where
      (==), (/=)  ::  a -> a -> Bool

      x /= y  = not (x == y)
      x == y  = not (x /= y)
```

The `Eq` class provides equality (`==`) and inequality (`/=`) methods.
All basic datatypes except for functions and `IO` are instances of this class.
Instances of `Eq` can be derived for any user-defined datatype whose
constituents are also instances of `Eq`.

This declaration gives default method declarations for both `/=` and `==`,
each being defined in terms of the other.  If an instance declaration
for `Eq` defines neither `==` nor `/=`, then both will loop.
If one is defined, the default method for the other will make use of
the one that is defined.  If both are defined, neither default method is used.


=== The Ord Class <subsec:ord-class>

```haskell
class  (Eq a) => Ord a  where
  compare              :: a -> a -> Ordering
  (<), (<=), (>=), (>) :: a -> a -> Bool
  max, min             :: a -> a -> a

  compare x y | x == y    = EQ
              | x <= y    = LT
              | otherwise = GT

  x <= y  = compare x y /= GT
  x <  y  = compare x y == LT
  x >= y  = compare x y /= LT
  x >  y  = compare x y == GT

  -- Note that (min x y, max x y) = (x,y) or (y,x)
  max x y | x <= y    =  y
          | otherwise =  x
  min x y | x <= y    =  x
          | otherwise =  y
```

The `Ord` class is used for totally ordered datatypes.  All basic
datatypes
except for functions, `IO`, and `IOError`, are instances of this class.  Instances
of `Ord`
can be derived for any user-defined datatype whose constituent types
are in `Ord`.  The declared order
of the constructors in the data declaration determines the ordering in
derived `Ord` instances.
The `Ordering` datatype
allows a single comparison to determine the precise ordering of two
objects.

The default declarations allow a user to create an `Ord` instance
either with a type-specific `compare` function or with type-specific
`==` and `<=` functions.

=== The Read and Show Classes

```haskell
type  ReadS a = String -> [(a,String)]
type  ShowS   = String -> String

class  Read a  where
    readsPrec :: Int -> ReadS a
    readList  :: ReadS [a]
    -- ... default decl for readList given in Prelude

class  Show a  where
    showsPrec :: Int -> a -> ShowS
    show      :: a -> String
    showList  :: [a] -> ShowS

    showsPrec _ x s   = show x ++ s
    show x            = showsPrec 0 x ""
    -- ... default decl for showList given in Prelude
```
The `Read` and `Show` classes are used to convert values to
or from strings.
The `Int` argument to `showsPrec` and `readsPrec` gives the operator
precedence of the enclosing context (see @sec:derived-text).

`showsPrec` and `showList` return a `String`-to-`String`
function, to allow constant-time concatenation of its results using function
composition.
A specialised variant, `show`, is also provided, which
uses precedence context zero, and returns an ordinary `String`.
The method  `showList` is provided to allow the programmer to
give a specialised way of showing lists of values.  This is particularly
useful for the `Char` type, where values of type `String` should be
shown in double quotes, rather than between square brackets.

Derived instances of `Read` and `Show` replicate the style in which a
constructor is declared: infix constructors and field names are used
on input and output.  Strings produced by `showsPrec` are usually
readable by `readsPrec`.

All `Prelude` types, except function types and `IO` types,
are instances of `Show` and `Read`.
(If desired, a programmer can easily make functions and `IO` types
into (vacuous) instances of `Show`, by providing an instance declaration.)

For convenience, the Prelude provides the following auxiliary
functions:
```haskell
reads   :: (Read a) => ReadS a
reads   =  readsPrec 0

shows   :: (Show a) => a -> ShowS
shows   =  showsPrec 0

read    :: (Read a) => String -> a
read s  =  case [x | (x,t) <- reads s, ("","") <- lex t] of
              [x] -> x
              []  -> error "PreludeText.read: no parse"
              _   -> error "PreludeText.read: ambiguous parse"
```
`shows` and `reads` use a default precedence of 0.  The `read` function reads
input from a string, which must be completely consumed by the input
process.

The function `lex :: ReadS String`, used by `read`, is also part of the Prelude.
It reads a single lexeme from the input, discarding initial white space, and
returning the characters that constitute the lexeme.  If the input string contains
only white space, `lex` returns a single successful "lexeme" consisting of the
empty string.  (Thus `lex ""` = `[("","")]`.)  If there is no legal lexeme at the
beginning of the input string, `lex` fails (i.e. returns `[]`).


=== The Enum Class <subsec:enum-class>
```haskell
class  Enum a  where
    succ, pred     :: a -> a
    toEnum         :: Int -> a
    fromEnum       :: a -> Int
    enumFrom       :: a -> [a]            -- [n..]
    enumFromThen   :: a -> a -> [a]       -- [n,n'..]
    enumFromTo     :: a -> a -> [a]       -- [n..m]
    enumFromThenTo :: a -> a -> a -> [a]  -- [n,n'..m]

    -- Default declarations given in Prelude
```
Class `Enum` defines operations on sequentially ordered types.
The functions `succ` and `pred` return the successor and predecessor,
respectively, of a value.
The functions `fromEnum` and `toEnum` map values from a type in
`Enum` to and from `Int`.
The `enumFrom`... methods are used when translating arithmetic
sequences (@sec:arithmetic-sequences).

Instances of `Enum` may be derived for any enumeration type (types
whose constructors have no fields); see @chapter:derived-instances.

For any type that is an instance of class `Bounded` as well as `Enum`, the following should hold:

- The calls `succ maxBound` and `pred minBound` should result in a runtime error.
- `fromEnum` and `toEnum` should give a runtime error if the
  result value is not representable in the result type.  For example, `toEnum 7 :: Bool` is an error.
- `enumFrom` and `enumFromThen` should be defined with
  an implicit bound, thus:
  ```haskell
  enumFrom     x   = enumFromTo     x maxBound
  enumFromThen x y = enumFromThenTo x y bound
    where
      bound | fromEnum y >= fromEnum x = maxBound
            | otherwise                = minBound
  ```

The following `Prelude` types are instances of `Enum`:
- Enumeration types: `()`, `Bool`, and `Ordering`. The
  semantics of these instances is given by @chapter:derived-instances.
  For example, `[LT ..]` is the list `[LT,EQ,GT]`.
- `Char`: the instance is given in @chapter:standard-prelude,   based
  on the primitive functions that convert between a `Char` and an `Int`.
  For example, `enumFromTo 'a' 'z'` denotes
  the list of lowercase letters in alphabetical order.
- Numeric types: `Int`, `Integer`, `Float`, `Double`.  The semantics of these instances is given next.

For all four numeric types, `succ` adds 1, and `pred` subtracts 1.
The conversions `fromEnum` and `toEnum` convert between the type and `Int`.
In the case of `Float` and `Double`, the digits after the decimal point may be lost.
It is implementation-dependent what `fromEnum` returns when applied to
a value that is too large to fit in an `Int`.

For the types `Int` and `Integer`, the enumeration functions
have the following meaning:


- The sequence $mono("enumFrom") e_1$ is the list $[e_1, e_1 + 1, e_1 + 2, dots]$.
- The sequence $mono("enumFromThen") e_1 e_2$ is the list $[e_1, e_1 + i, e_1 + 2i, dots]$,
  where the increment, $i$, is $e_2 - e_1$.  The increment may be zero or negative.
  If the increment is zero, all the list elements are the same.
- The sequence $mono("enumFromTo") e_1 e_3$ is
  the list $[e_1, e_1 + 1, e_1 + 2, dots, e_3]$.
  The list is empty if $e_1 > e_3$.
- The sequence $mono("enumFromThenTo") e_1 e_2 e_3$
  is the list $[e_1, e_1 + i, e_1 + 2i, dots, e_3]$,
  where the increment, $i$, is $e_2 - e_1$.  If the increment
  is positive or zero, the list terminates when the next element would
  be greater than $e_3$; the list is empty if $e_1 > e_3$.
  If the increment is negative, the list terminates when the next element would be less than $e_3$; the list is empty if $e_1 < e_3$.


For `Float` and `Double`, the semantics of the `enumFrom` family is
given by the rules for `Int` above, except that the list terminates
when the elements become greater than $e_3 + i mono("/") 2$ for positive increment
$i$, or when they become less than $e_3 + i mono("/") 2$ for negative $i$.

For all four of these Prelude numeric types, all of the `enumFrom` family of functions are strict in all their arguments.

=== The Functor Class

```haskell
class  Functor f  where
    fmap    :: (a -> b) -> f a -> f b
```
The `Functor` class is used for types that can be mapped over.  Lists, `IO`, and `Maybe` are in this class.

Instances of `Functor` should satisfy the following laws:
$
  mono("fmap id") &= mono("id") \
  mono("fmap (f . g)") &= mono("fmap f . fmap g")
$

All instances of `Functor` defined in the Prelude satisfy these laws.

=== The Monad Class <sec:monad-class>

```haskell
class  Monad m  where
    (>>=)   :: m a -> (a -> m b) -> m b
    (>>)    :: m a -> m b -> m b
    return  :: a -> m a
    fail    :: String -> m a

    m >> k  =  m >>= \_ -> k
    fail s  = error s
```

The `Monad` class defines the basic operations over a _monad_.
See @chapter:basic-input-output for more information about monads.

"`do`" expressions provide a convenient syntax for writing
monadic expressions (see @sec:do-expressions).
The `fail` method is invoked on pattern-match failure in a `do`
expression.

In the Prelude, lists,
`Maybe`, and `IO` are all instances of `Monad`.
The `fail` method for lists returns the empty list `[]`,
for `Maybe` returns `Nothing`, and for `IO` raises a user
exception in the IO monad (see @sec:io-exceptions).

Instances of `Monad` should satisfy the following laws:

$
  mono("return a >>= k") &= mono("k a") \
  mono("m >> return") &= mono("m") \
  mono("m >>= (\x -> k x >>= h)") &= mono("(m >>= k) >>= h")
$

Instances of both `Monad` and `Functor` should additionally satisfy the law:
$
  mono("fmap f xs") &= mono("xs >>= return . f")
$

All instances of `Monad` defined in the Prelude satisfy these laws.

The Prelude provides the following auxiliary functions:
```haskell
sequence  :: Monad m => [m a] -> m [a]
sequence_ :: Monad m => [m a] -> m ()
mapM      :: Monad m => (a -> m b) -> [a] -> m [b]
mapM_     :: Monad m => (a -> m b) -> [a] -> m ()
(=<<)     :: Monad m => (a -> m b) -> m a -> m b
```

=== The Bounded Class

```haskell
class  Bounded a  where
    minBound, maxBound :: a
```

The `Bounded` class is used to name the upper and lower limits of a
type.  `Ord` is not a superclass of `Bounded` since types that are not
totally ordered may also have upper and lower bounds.
The types `Int`, `Char`, `Bool`,
`()`, `Ordering`, and all tuples are instances of `Bounded`.
The `Bounded` class may be derived
for any enumeration type; `minBound` is the first constructor listed
in the `data` declaration and `maxBound` is the last. `Bounded` may
also be derived for single-constructor datatypes whose constituent
types are in `Bounded`.

== Numbers <sec:numbers>

Haskell provides several kinds of numbers; the numeric
types and the operations upon them have been heavily influenced by Common Lisp and Scheme.
Numeric function names and operators are usually overloaded, using
several type classes with an inclusion relation shown in @fig:standard-classes.
The class `Num` of numeric
types is a subclass of `Eq`, since all numbers may be compared for equality; its subclass `Real` is also a subclass of `Ord`, since the other comparison operations
apply to all but complex numbers (defined in the `Complex` library).
The class `Integral` contains integers of both
limited and unlimited range; the class
`Fractional` contains all non-integral types; and
the class `Floating` contains all floating-point
types, both real and complex.

The Prelude defines only the most basic numeric types: fixed sized
integers `Int`, arbitrary precision integers `Integer`, single
precision floating `Float`, and double precision floating
`Double`.  Other numeric types such as rationals and complex numbers
are defined in libraries.  In particular, the type `Rational` is a
ratio of two `Integer`n values, as defined in the `Ratio`
library.

#figure(
  caption: "Standard Numeric Types",
  table(
    columns: 3,
    stroke: none,
    table.vline(x: 0),
    table.vline(x: 1),
    table.vline(x: 2),
    table.vline(x: 3),
    table.hline(),
    table.header("Type", "Class", "Description"),
    table.hline(),
    [`Integer`], [`Integral`], [Arbitrary-precision integers],
    [`Int`], [`Integral`], [Rational numbers],
    [`Ratio a`], [`RealFrac`], [Rational numbers],
    [`Float`], [`RealFloat`], [Real floating-point, single precision],
    [`Double`], [`RealFloat`], [Real floating-point, double precision],
    [`Complex a`], [`Floating`], [Complex floating-point],
    table.hline(),
  )
)<fig:numeric-types>

The default floating point operations defined by the Haskell
Prelude do not 
conform to current language independent arithmetic (LIA) standards.  These
standards require considerably more complexity in the numeric
structure and have thus been relegated to a library.  Some, but not
all, aspects of the IEEE floating point standard have been
accounted for in Prelude class `RealFloat`.

The standard numeric types are listed in @fig:numeric-types.
The finite-precision integer type `Int` covers at
least the range $[-2^(29), 2^(29) -1]$.
As `Int` is an instance of the `Bounded` class, `maxBound` and `minBound` can be used to determine the exact
`Int` range defined by an implementation.
`Float` is implementation-defined; it is desirable that
this type be at least equal in range and precision to the IEEE
single-precision type.  Similarly, `Double` should
cover IEEE double-precision.  The results of exceptional
conditions (such as overflow or underflow) on the fixed-precision
numeric types are undefined; an implementation may choose error
($bot$, semantically), a truncated value, or a special value such as
infinity, indefinite, etc.

The standard numeric classes and other numeric functions defined in
the Prelude are shown
in @fig:basic-numeric-1 @fig:basic-numeric-2.
@fig:standard-classes shows the class dependencies and
built-in types that are instances of the numeric classes.

#figure(
  caption: "Standard Numeric Classes and Related Operations, Part 1",
  ```haskell
class  (Eq a, Show a) => Num a  where
    (+), (-), (*)  :: a -> a -> a
    negate         :: a -> a
    abs, signum    :: a -> a
    fromInteger    :: Integer -> a

class  (Num a, Ord a) => Real a  where
    toRational ::  a -> Rational

class  (Real a, Enum a) => Integral a  where
    quot, rem, div, mod :: a -> a -> a
    quotRem, divMod     :: a -> a -> (a,a)
    toInteger           :: a -> Integer

class  (Num a) => Fractional a  where
    (/)          :: a -> a -> a
    recip        :: a -> a
    fromRational :: Rational -> a

class  (Fractional a) => Floating a  where
    pi                  :: a
    exp, log, sqrt      :: a -> a
    (**), logBase       :: a -> a -> a
    sin, cos, tan       :: a -> a
    asin, acos, atan    :: a -> a
    sinh, cosh, tanh    :: a -> a
    asinh, acosh, atanh :: a -> a
  ```
)<fig:basic-numeric-1>

#figure(
  caption: "Standard Numeric Classes and Related Operations, Part 2",
  ```haskell
class  (Real a, Fractional a) => RealFrac a  where
    properFraction   :: (Integral b) => a -> (b,a)
    truncate, round  :: (Integral b) => a -> b
    ceiling, floor   :: (Integral b) => a -> b

class  (RealFrac a, Floating a) => RealFloat a  where
    floatRadix          :: a -> Integer
    floatDigits         :: a -> Int
    floatRange          :: a -> (Int,Int)
    decodeFloat         :: a -> (Integer,Int)
    encodeFloat         :: Integer -> Int -> a
    exponent            :: a -> Int
    significand         :: a -> a
    scaleFloat          :: Int -> a -> a
    isNaN, isInfinite, isDenormalized, isNegativeZero, isIEEE 
                        :: a -> Bool
    atan2               :: a -> a -> a

gcd, lcm :: (Integral a) => a -> a-> a
(^)      :: (Num a, Integral b) => a -> b -> a
(^^)     :: (Fractional a, Integral b) => a -> b -> a

fromIntegral :: (Integral a, Num b) => a -> b
realToFrac   :: (Real a, Fractional b) => a -> b
  ```
)<fig:basic-numeric-2>

=== Numeric Literals <sec:numeric-literals>

The syntax of numeric literals is given in
@sec:lexemes-numeric.  An integer literal represents the
application
of the function `fromInteger` to the appropriate
value of type `Integer`.  Similarly, a floating literal stands for an application of
`fromRational` to a value of type `Rational` (that is, `Ratio Integer`).  Given the typings:
```haskell
fromInteger  :: (Num a) => Integer -> a
fromRational :: (Fractional a) => Rational -> a
```
integer and floating literals have the
typings `(Num a) => a` and `(Fractional a) => a`, respectively.
Numeric literals are defined in this indirect way so that they may be
interpreted as values of any appropriate numeric type.
See @sec:default-decls for a discussion of overloading ambiguity.

=== Arithmetic and Number-Theoretic Operations

The infix class methods `(+)`, `(*)`, `(-)`, and the unary function `negate` (which can also be written as a prefix minus sign; see
@sec:operator-applications) apply to all numbers.  
The class methods
`quot`, `rem`, `div`, and `mod` apply only to integral numbers, while the class method `(/)`
applies only to fractional ones.
The `quot`, `rem`,
`div`, and `mod` class methods satisfy these laws if `y` is non-zero:
```haskell
(x `quot` y)*y + (x `rem` y) == x
(x `div`  y)*y + (x `mod` y) == x
```
`quot` is integer division truncated toward zero,
while the result of `div` is truncated toward
negative infinity.
The `quotRem` class method takes a dividend and a divisor as arguments
and returns a (quotient, remainder) pair; `divMod` is defined similarly:
```haskell
quotRem x y  =  (x `quot` y, x `rem` y)
divMod  x y  =  (x `div`  y, x `mod` y)
```
Also available on integral numbers are the even and odd predicates:
```haskell
even x =  x `rem` 2 == 0
odd    =  not . even
```
Finally, there are the greatest common divisor and least common
multiple functions.  `gcd` $x$ $y$ is the greatest
(positive) integer that divides both $x$ and $y$; for example `gcd (-3) 6 = 3`, `gcd (-3) (-6) = 3`, 
`gcd 0 4 = 4`. `gcd 0 0` raises a runtime error.

`lcm` $x$ $y$ is the smallest positive integer that both $x$ and $y$ divide.

=== Exponentiation and Logarithms

The one-argument exponential function `exp` and the
logarithm function `log` act on floating-point numbers and
use base $e$.  `logBase` $a$ $x$ returns the
logarithm of $x$ in base $a$.  `sqrt` returns the
principal square root of a floating-point number.
There are three two-argument exponentiation operations:
`(^)` raises any number to a nonnegative integer power,
`(^^)` raises a
fractional number to any integer power, and `(**)`
takes two floating-point arguments.  The value of `x ^ 0` or `x ^^ 0`}
is `1` for any $x$, including zero; `0**y` is `1` if $y$ is `0`, and `0` otherwise.

=== Magnitude and Sign

A number has a _magnitude_ and a _sign_.  The functions `abs` and `signum` apply to any number and satisfy the law:
```haskell
abs x * signum x == x
```
For real numbers, these functions are defined by:
```haskell
abs x    | x >= 0  = x
         | x <  0  = -x

signum x | x >  0  = 1
         | x == 0  = 0
         | x <  0  = -1
```

=== Trigonometric Functions

Class `Floating` provides the
circular and hyperbolic sine, cosine,
and tangent functions and their inverses.
Default implementations of `tan`, `tanh`, `logBase`, `**`, and `sqrt` are
provided, but implementors are free to provide more accurate implementations.

Class `RealFloat` provides a version of arctangent
taking two real floating-point arguments.
For real floating $x$ and $y$, `atan2` $y$ $x$
computes the angle (from the positive x-axis) of the vector from the origin
to the point $(x,y)$.  `atan2` $y$ $x$
returns a value in the range `[-pi,pi]`.  It
follows the Common Lisp semantics for the origin when signed zeroes are
supported.  `atan2` $y$ `1`, with $y$ in a type that is `RealFloat`, should return the
same value as `atan` $y$.  A default definition of `atan2` is provided, but
implementors can provide a more accurate implementation.

The precise definition of the above functions is as in Common Lisp,
which in turn follows Penfield's proposal for
APL @Penfield1981.  See these references for discussions
of branch cuts, discontinuities, and implementation.

=== Coercions and Component Extraction <sec:coercions>

The `ceiling`, `floor`, `truncate`, and `round`
functions each take a real fractional argument and return an integral
result.  `ceiling` $x$ returns the least integer not less than $x$, and
`floor` $x$, the greatest integer not greater than $x$.  `truncate` $x$
yields the integer nearest $x$ between $0$ and $x$, inclusive.
`round` $x$ returns the nearest integer to $x$, the even integer if
$x$ is equidistant between two integers.


The function `properFraction` takes a real
fractional number $x$ and returns a pair $(n,f)$ such that $x = n + f$, and:
$n$ is an integral number with the same sign as $x$; and $f$ is a
fraction $f$ with the same type and sign as $x$, and with absolute
value less than 1.
The `ceiling`,  `floor`, `truncate`, and `round`
functions can be defined in terms of `properFraction`.

Two functions convert numbers to type `Rational`:
`toRational` returns the rational equivalent of
its real argument with full precision;
`approxRational` takes two real fractional arguments
$x$ and $epsilon$ and returns the simplest rational number within
$epsilon$ of $x$, where a rational $p italic("/") q$ in reduced form is
_simpler_ than another $p' italic("/") q'$ if
$|p| <= |p'|$ and $q <= q^'$.
Every real interval contains a unique simplest rational;
in particular, note that $0 italic("/") 1$ is the simplest rational of all.

The class methods of class `RealFloat` allow
efficient, machine-independent
access to the components of a floating-point number.
The functions `floatRadix`,
`floatDigits`, and
`floatRange` give the parameters of a
floating-point type:  the radix of the representation, the number of
digits of this radix in the significand, and the lowest and highest
values the exponent may assume, respectively.
The function `decodeFloat` applied to a real floating-point number returns the significand
expressed as an `Integer` and an appropriately scaled exponent (an
`Int`).  If `decodeFloat` $x$ yields $(m,n)$, then `x` is
equal in value to $m b^n$, where $b$ is the floating-point radix, and
furthermore, either $m$ and $n$ are both zero or else
$b^(d-1) <= |m| < b^d$, where $d$ is the value of `floatDigits x`.
`encodeFloat` performs the inverse of this
transformation.  The functions `significand`
and `exponent` together provide the same
information as `decodeFloat`,  but rather than an `Integer`,
`significand` $x$ yields a value of the same type as `x`, scaled to lie
in the open interval $(-1,1)$.  `exponent 0` is zero.
`scaleFloat` multiplies a floating-point number by an integer power of the radix.

The functions `isNaN`, `isInfinite`, `isDenormalized`, `isNegativeZero`, and `isIEEE` all support numbers represented using
the IEEE standard.  For non-IEEE floating point numbers, these may all
return false.

Also available are the following coercion functions:
```haskell
fromIntegral :: (Integral a, Num b)    => a -> b
realToFrac   :: (Real a, Fractional b) => a -> b
```