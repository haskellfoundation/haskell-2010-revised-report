The Haskell language report is published together with the Haskell library report, which specifies the standard libraries and the `Prelude` module that every implementation has to provide.
This chapter describes the relationship between the language report and the library report.

== Interface Specifications <section:interface-spec>

The standard library is primarily specified in terms of the _public interface_ that each of its modules exposes.
The public interface of a module consists of all entities exposed in export lists, as well as declared fixities and class instances.
The library report does not provide a reference implementation of the standard libraries, but instead provides behavioural specifications (@section:behavioural-spec) of a subset of the public interface.

== Behavioural Specifications <section:behavioural-spec>

A subset of the standard libraries is described using _behavioural specifications_.
These behavioural specifications are given in the form of documentation comments which provide a reference implementation.
Many of these reference implementations are written with clarity rather than efficiency in mind,
and it is not required that the specification be implemented as shown.

The default method definitions, given with `class` declarations, constitute
a specification _only_ of the default method.  They do not constitute a
specification of the meaning of the method in all instances.  To take
one particular example, the default method for `enumFrom` in class `Enum`
will not work properly for types whose range exceeds that of `Int` (because
`fromEnum` cannot map all values in the type to distinct `Int` values).

== Prelude <section:prelude>

The library report includes the specification of a module `Prelude`.
That module is not treated specially in the library report, but it is handled differently in import lists.
The special semantics of the Prelude is described in @section:prelude-import.
