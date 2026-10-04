Some compiler implementations support compiler _pragmas_, which
are used to give additional instructions or hints to the compiler, but
which do not form part of the Haskell language proper and do not
change a program's semantics.  This chapter summarizes this existing
practice.  An implementation is not required to respect any pragma,
although pragmas that are not recognised by the implementation should
be ignored.
Implementations are strongly encouraged to support the
LANGUAGE pragma described below as there are many language extensions
being used in practice.

Lexically, pragmas appear as comments, except that the enclosing
syntax is `{-# #-}`.

== Inlining

$
  italic("decl") &-> mono("{-# INLINE ") italic("qvars") mono("#-}") \
  italic("decl") &-> mono("{-# NOINLINE ") italic("qvars") mono("#-}")
$


The `INLINE` pragma instructs the compiler to inline the specified variables at their use sites.
Compilers will often automatically inline simple expressions.  This may be prevented by the `NOINLINE` pragma.

== Specialization

$
  italic("decl") &-> mono("{-# SPECIALIZE ") italic("spec")_1, dots, italic("spec")_k mono("#-}") (k >= 1)\
  italic("spec") &-> italic("vars") mono("::") italic("type")
$

Specialization is used to avoid inefficiencies involved in dispatching
overloaded functions.  For example, in
```haskell
factorial :: Num a => a -> a
factorial 0 = 0
factorial n = n * factorial (n-1)
{-# SPECIALIZE factorial :: Int -> Int,
               factorial :: Integer -> Integer #-}
```
calls to `factorial` in which the compiler can detect that the
parameter is either `Int` or `Integer` will
use specialized versions of `factorial` which do not involve
overloaded numeric operations.

== Language extensions

The `LANGUAGE` pragma is a file-header pragma. A file-header pragma must
precede the module keyword in a source file. There can be as many
file-header pragmas as you please, and they can be preceded or
followed by comments. An individual language pragma begins with the
keyword `LANGUAGE` and is followed by a comma-separated list of named language features.

For example, to enable scoped type variables and preprocessing with
CPP, if your Haskell implementation supports these extensions:
```haskell
{-# LANGUAGE ScopedTypeVariables, CPP #-}
```
If a Haskell implementation does not recognize or support a particular
language feature that a source file requests (or cannot support the
combination of language features requested), any attempt to compile
or otherwise use that file with that Haskell implementation must fail
with an error.

In the interests of portability, multiple attempts to enable the same,
supported language features (e.g. via command-line arguments,
implementation-specific features dependencies or non-standard
pragmas) are specifically permitted.

=== Required extensions

Haskell 2010 implementations that support the `LANGUAGE` pragma are required to support
```haskell
{-# LANGUAGE Haskell2010 #-}
```

=== Legacy extensions

Some pre-Haskell 2010 implementations supported the following language extensions that have been integrated into this report:
- ```haskell {-# LANGUAGE PatternGuards #-}```
- ```haskell {-# LANGUAGE NoNPlusKPatterns #-}```
- ```haskell {-# LANGUAGE RelaxedPolyRec #-}```
- ```haskell {-# LANGUAGE EmptyDataDecls #-}```
- ```haskell {-# LANGUAGE ForeignFunctionInterface #-}```

A Haskell implementation may choose to support these language extensions.
If an implementation chooses to support these language extensions, then they must not change the behaviour of the implementation when it is configured to run in its Haskell 2010 compliant mode.
