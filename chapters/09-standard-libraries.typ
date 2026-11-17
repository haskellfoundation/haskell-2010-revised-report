In this chapter the entire Haskell Prelude is given.
It constitutes a _specification_ for the Prelude.  Many of the definitions are
written with clarity rather than efficiency in mind,
and it is not required that the specification be implemented as shown here.

The default method definitions, given with `class` declarations, constitute
a specification _only_ of the default method.  They do not constitute a
specification of the meaning of the method in all instances.  To take
one particular example, the default method for `enumFrom` in class `Enum`
will not work properly for types whose range exceeds that of `Int` (because
`fromEnum` cannot map all values in the type to distinct `Int` values).

Some of these modules import Library modules, such as `Data.Char`, `Control.Monad`, `System.IO`,
and `Numeric`.  These modules are described fully in the library report.
These imports are not, of course, part of the specification
of the `Prelude`.  That is, an implementation is free to import more, or less,
of the Library modules, as it pleases.

To reduce the occurrence of unexpected ambiguity errors, and to
improve efficiency, a number of commonly-used functions over lists use
the `Int` type rather than using a more general numeric type, such as
`Integral a` or `Num a`.  These functions are: `take`, `drop`,
`!!`, `length`, `splitAt`, and `replicate`.  The more general
versions are given in the `Data.List` library, with the prefix
"`generic`"; for example `genericLength`.

== Prelude <section:prelude>