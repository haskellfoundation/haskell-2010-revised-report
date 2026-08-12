#import "../macros.typ" : *

In this chapter, we describe the syntax and informal semantics of
Haskell _expressions_, including their translations into the
Haskell kernel, where appropriate.  Except in the case of `let`
expressions, these translations preserve both the static and dynamic
semantics.  Free variables and constructors used in these translations
always refer to entities defined by the `Prelude`.  For example,
"`concatMap`" used in the translation of list comprehensions
(@sec:list-comprehensions[Section]) means the `concatMap` defined by
the `Prelude`, regardless of whether or not the identifier "`concatMap`" is in
scope where the list comprehension is used, and (if it is in scope)
what it is bound to.

#table(
  columns: 4,
  stroke: none,
  align: (left, center, left, left),
  // exp
  $italic("exp")$, $->$, $nonterminal("infixexp") terminal("::") [nonterminal("context") terminal("=>")] nonterminal("type")$, [(expression type signature)],
  [],$|$, $nonterminal("infixexp")$,[],
  // infixexp
  $italic("infixexp")$, $->$, $nonterminal("lexp") nonterminal("qop") nonterminal("infixexp")$, [],
  [], $|$, $terminal("-") nonterminal("infixexp")$, [(prefix negation)],
  [], $|$, $nonterminal("lexp")$, [],
  // lexp
  $italic("lexp")$, $->$, $terminal("\\") nonterminal("apat")_1 dots nonterminal("apat")_n terminal("->") nonterminal("exp")$, [(lambda abstraction, $n >= 1$)],
  [], $|$, $terminal("let") nonterminal("decls") terminal("in") nonterminal("exp")$, [(let expression)],
  [], $|$, $terminal("if") nonterminal("exp") [terminal(";")] terminal("then") nonterminal("exp") [terminal(";")] terminal("else") nonterminal("exp")$, [(conditional)],
  [], $|$, $terminal("case") nonterminal("exp") terminal("of") terminal("{") nonterminal("alts") terminal("}")$, [(case expression)],
  [], $|$, $terminal("do") terminal("{") nonterminal("stmts") terminal("}")$, [(do expression)],
  [], $|$, $nonterminal("fexp")$, [],
  // fexp
  $italic("fexp")$, $->$, $[nonterminal("fexp")] nonterminal("aexp")$, [(function application)],
  // aexp
  $italic("aexp")$, $->$, $nonterminal("qvar")$, [(variable)],
  [], $|$, $nonterminal("gcon")$, [(general constructor)],
  [], $|$, $nonterminal("literal")$, [],
  [], $|$, $terminal("(") nonterminal("exp") terminal(")")$, [(parenthesized expression)],
  [], $|$, $terminal("(") nonterminal("exp")_1 terminal(",") dots terminal(",") nonterminal("exp")_k terminal(")")$, [(tuple, $k>=2$)],
  [], $|$, $terminal("[") nonterminal("exp")_1 terminal(",") dots terminal(",") nonterminal("exp")_k terminal("]")$, [(list, $k>=1$)],
  [], $|$, $terminal("[") nonterminal("exp")_1 [terminal(",") nonterminal("exp")_2] terminal("..") [nonterminal("exp")_3] terminal("]")$, [(arithmetic sequence)],
  [], $|$, $terminal("[") nonterminal("exp") terminal("|") nonterminal("qual")_1 terminal(",") dots terminal(",") nonterminal("qual")_n terminal("]")$, [(list comprehension, $n>=1$)],
  [], $|$, $terminal("(") nonterminal("infixexp") nonterminal("qop") terminal(")")$, [(left section)],
  [], $|$, $terminal("(") nonterminal("qop")_(chevron.l terminal("-") chevron.r) nonterminal("infixexp") terminal(")")$, [(right section)],
  [], $|$, $nonterminal("qcon") terminal("{") nonterminal("fbind")_1 terminal(",") dots terminal(",") nonterminal("fbind")_n terminal("}")$, [(labeled construction, $n>=0$)],
  [], $|$, $nonterminal("aexp")_(chevron.l nonterminal("qcon") chevron.r) terminal("{") nonterminal("fbind")_1 terminal(",") dots terminal(",") nonterminal("fbind")_n terminal("}")$, [(labeled update, $n>=1$)],
)


Expressions involving infix operators are disambiguated by the operator's fixity (see @sec:fixity-declarations).  Consecutive unparenthesized operators with the same precedence must both be either
left or right associative to avoid a syntax error.
Given an unparenthesized expression "$x med italic("qop")^((a,i)) med y med italic("qop")^((b,j)) med z$"
(where $italic("qop")^((a,i))$ means an operator with associativity $a$ and
precedence $i$), parentheses must be added around either $x med italic("qop")^((a,i)) med y$ or $y med italic("qop")^((b,j)) med z$ when $i = j$ unless $a = b = text("l")$ or $a = b = text("r")$.

An example algorithm for resolving expressions involving infix operators is given in @sec:fixity-resolution.

Negation is the only prefix operator in
Haskell; it has the same precedence as the infix `-` operator defined in the Prelude (see @sec:fixity-declarations, @fig:prelude-fixities[Figure]).

The grammar is ambiguous regarding the extent of lambda abstractions, let expressions, and conditionals.
The ambiguity is resolved by the meta-rule that each of these constructs extends as far to the right as possible.


Sample parses are shown below.

#table(
  columns: 2,
  align: (left, left),
  stroke: none,
  table.vline(x: 0),
  table.vline(x: 1),
  table.vline(x: 2),
  table.hline(),
  table.header([This], [Parses as]),
  table.hline(),
  [`f x + g y`],[`(f x) + (g y)`],
  [`- f x + y`],[`(- (f x)) + y`],
  [`let {...} in x + y`],[`let {...} in (x + y)`],
  [`z + let {...} in x + y`],[`z + (let {...} in (x + y))`],
  [`f x y :: Int`],[`(f x y) :: Int`],
  [`\ x -> a+b :: Int`],[`\x -> ((a+b) :: Int)`],
  table.hline(),
)

For the sake of clarity, the rest of this section will assume that expressions involving infix operators have been resolved according to the fixities of the operators.

== Errors <sec:expressions:errors>

Errors during expression evaluation, denoted by $bot$ ("bottom"),
are indistinguishable by a Haskell program from non-termination.  Since Haskell is a
non-strict language, all Haskell types include $bot$.  That is, a value
of any type may be bound to a computation that, when demanded, results
in an error.  When evaluated, errors cause immediate program
termination and cannot be caught by the user.  The Prelude provides
two functions to directly
cause such errors:

```haskell
error     :: String -> a
undefined :: a
```
A call to `error` terminates execution of
the program and returns an appropriate error indication to the
operating system.  It should also display the string in some
system-dependent manner.  When `undefined` is used, the error message
is created by the compiler.

Translations of Haskell expressions use `error` and `undefined` to
explicitly indicate where execution time errors may occur.  The actual
program behavior when an error occurs is up to the implementation.
The messages passed to the `error` function in these translations are
only suggestions; implementations may choose to display more or less
information when an error occurs.

== Variables, Constructors, Operators, and Literals <sec:vars-and-lits>

#table(
  columns: 4,
  align: (left, center, left, left),
  stroke: none,
  // aexp
  $italic("aexp")$, $->$, $nonterminal("qvar")$, [(variable)],
  $$,$|$,$nonterminal("gcon")$,[(general constructor)],
  $$,$|$,$nonterminal("literal")$,[],
  // gcon
  $italic("gcon")$, $->$, $terminal("()")$, [],
  $$,$|$,$terminal("[]")$,[],
  $$,$|$,$terminal("(,") {terminal(",")} terminal(")")$,[],
  $$,$|$,$nonterminal("qcon")$,[],
  // var
  $italic("var")$, $->$, $nonterminal("varid") | terminal("(") nonterminal("varsym") terminal(")")$, [(variable)],
  // qvar
  $italic("qvar")$, $->$, $nonterminal("qvarid") | terminal("(") nonterminal("qvarsym") terminal(")")$, [(qualified variable)],
  // con
  $italic("con")$, $->$, $nonterminal("conid") | terminal("(") nonterminal("consym") terminal(")")$, [(constructor)],
  // qcon
  $italic("qcon")$, $->$, $nonterminal("qconid") | terminal("(") nonterminal("gconsym") terminal(")")$, [(qualified constructor)],
  // varop
  $italic("varop")$, $->$, $nonterminal("varsym") | terminal("`") nonterminal("varid") terminal("`")$, [(variable operator)],
  // qvarop
  $italic("qvarop")$, $->$, $nonterminal("qvarsym") | terminal("`") nonterminal("qvarid") terminal("`")$, [(qualified variable operator)],
  // conop
  $italic("conop")$, $->$, $nonterminal("consym") | terminal("`") nonterminal("conid") terminal("`")$, [(constructor operator)],
  // qconop
  $italic("qconop")$, $->$, $nonterminal("gconsym") | terminal("`") nonterminal("qconid") terminal("`")$, [(qualified constructor operator)],
  // op
  $italic("op")$, $->$, $nonterminal("varop") | nonterminal("conop")$, [(operator)],
  // qop
  $italic("qop")$, $->$, $nonterminal("qvarop") | nonterminal("qconop")$, [(qualified operator)],
  // gconsym
  $italic("gconsym")$, $->$, $terminal(":") | nonterminal("qconsym")$, [],
)

Haskell provides special syntax to support infix notation.
An _operator_ is a function that can be applied using infix
syntax (@sec:operator-applications), or partially applied using a
_section_ (@sec:sections).

An _operator_ is either an _operator symbol_, such as `+` or `$$`,
or is an ordinary identifier enclosed in grave accents (backquotes), such
as #raw("`op`").  For example, instead of writing the prefix application
`op x y`, one can write the infix application #raw("x `op` y").
If no fixity declaration is given for `op` then it defaults
to highest precedence and left associativity
(see @sec:fixity-declarations).

Dually, an operator symbol can be converted to an ordinary identifier
by enclosing it in parentheses.  For example, `(+) x y` is equivalent
to `x + y`, and `foldr (*) 1 xs` is equivalent to `foldr (\x y -> x*y) xs`.

Special syntax is used to name some constructors for some of the
built-in types, as found
in the production for $italic("gcon")$ and $italic("literal")$.  These are described
in @sec:standard-haskell-types.

An integer literal represents the
application of the function `fromInteger` to the
appropriate value of type `Integer`.
Similarly, a floating point literal stands for an application of `fromRational` to a value of type `Rational` (that is, `Ratio Integer`).

#translation-box([
  The integer literal $i$ is equivalent to $mono("fromInteger") i$,
  where `fromInteger` is a method in class `Num` (see @sec:numeric-literals).

  The floating point literal $f$ is equivalent to $mono("fromRational") (n mono("Ratio.%") d)$, where `fromRational` is a method in class `Fractional` and `Ratio.%` constructs a rational from two integers, as defined in
the `Ratio` library.
The integers $n$ and $d$ are chosen so that $n \/ d = f$.
])


== Curried Applications and Lambda Abstractions

#table(
  columns: 4,
  align: (left, center, left, left),
  stroke: none,
  $italic("fexp")$, $->$, $[nonterminal("fexp")] nonterminal("aexp")$, [(function application)],
  $italic("lexp")$, $->$, $terminal("\\") nonterminal("apat")_1 med dots med nonterminal("apat")_n terminal("->") nonterminal("exp")$, [(lambda abstraction $n>=1$)]
)

_Function application_ is written $e_1 med e_2$.
Application associates to the left, so the
parentheses may be omitted in `(f x) y`.
Because $e_1$ could be a data constructor, partial applications of data constructors are allowed.

_Lambda abstractions_ are written
$mono("\\") p_1 dots p_n mono("->") e$, where the $p_i$ are _patterns_.
An expression such as `\x:xs->x` is syntactically incorrect;
it may legally be written as `\(x:xs)->x`.

The set of patterns must be _linear_---no variable may appear more than once in the set.

#translation-box(
  [The following identity holds:
    $
      mono("\\") p_1 med dots med p_n mono("->") e = mono("\\") x_1 med dots med x_n mono("->") mono("case") (x_1, dots, x_n) mono("of") (p_1, dots, p_n) mono("->") e
    $
    where the $x_i$ are new identifiers.]
)

Given this translation combined with the semantics of case
expressions and pattern matching described in @subsec:formal-semantics-pattern-matching, if the
pattern fails to match, then the result is $bot$.

== Operator Applications <sec:operator-applications>

#table(
  columns: 4,
  align: (left, center, left, left),
  stroke: none,
  $italic("infixexp")$, $->$, $nonterminal("lexp") med nonterminal("qop") med nonterminal("infixexp")$, [],
  [], $|$, $terminal("-") nonterminal("infixexp")$, [(prefix negation)],
  [], $|$, nonterminal("lexp"), [],
  $italic("qop")$, $->$, $nonterminal("qvarop") | nonterminal("qconop")$, [(qualified operator)],
)

The form $e_1 italic("qop") e_2$ is the infix application of binary operator $italic("qop")$ to expressions $e_1$ and $e_2$.

The special
form $-e$ denotes prefix negation, the only
prefix operator in Haskell, and is
syntax for $mono("negate") (e)$.
The binary `-` operator does not necessarily refer
to the definition of `-` in the Prelude; it may be rebound by the module system.
However, unary `-` will always refer to the
`negate` function defined in the Prelude.  There is no link between the local meaning of the `-` operator and unary negation.

Prefix negation has the same precedence as the infix operator `-` defined in the Prelude (see
@fig:prelude-fixities).
Because `e1-e2` parses as an
infix application of the binary operator `-`, one must write `e1(-e2)` for the alternative parsing.
Similarly, `(-)` is syntax for `\x y -> x-y`, as with any infix operator, and does not denote
`\x -> -x`---one must use `negate` for that.

#translation-box([
  The following identities hold:
  $
    e_1 italic("op") e_2 &= (italic("op")) med e_1 med e_2 \
    -e &= mono("negate") (e)
  $
  ]
)

== Sections <sec:sections>

#table(
  columns: 4,
  align: (left, center, left, left),
  stroke: none,
  $italic("aexp")$, $->$, $terminal("(") nonterminal("infixexp") med nonterminal("qop") terminal(")")$, [(left section)],
  [], $|$, $terminal("(") nonterminal("qop")_(chevron.l terminal("-") chevron.r) nonterminal("infixexp") terminal(")")$, [(right section)]
)


_Sections_ are written as $(italic("op") e)$ or $(e italic("op"))$, where
$italic("op")$ is a binary operator and $e$ is an expression.
Sections are a convenient syntax for partial application of binary operators.

Syntactic precedence rules apply to sections as follows.
$(italic("op") e)$ is legal if and only if $(x italic("op") e)$ parses in the same way as $(x italic("op") (e))$;
and similarly for $(e italic("op")$.
For example, `(*a+b)` is syntactically invalid, but `(+a*b)` and `(*(a+b))` are valid.
Because `(+)` is left associative, `(a+b+)` is syntactically correct,
but `(+a+b)` is not; the latter may legally be written as `(+(a+b))`.
As another example, the expression
```haskell
  (let n = 10 in n +)
```
is invalid because, by the let/lambda meta-rule (@chapter:expressions[Section]),
the expression
```haskell
  (let n = 10 in n + x)
```
parses as
```haskell
  (let n = 10 in (n + x))
```
rather than
```haskell
  ((let n = 10 in n) + x)
```

Because `-` is treated specially in the grammar,
$(- italic("exp"))$ is not a section, but an application of prefix negation, as described in the preceding section.
However, there is a `subtract` function defined in the Prelude such that $(mono("subtract") italic("exp"))$
is equivalent to the disallowed section.
The expression $(+ (- italic("exp")))$ can serve the same purpose.

#translation-box([
  The following identities hold:
  $
    (italic("op") e) &= mono("\\") x mono("->") x italic("op") e\
    (e italic("op")) &= mono("\\") x mono("->") e italic("op") x
  $
  where $italic("op")$ is a binary operator, $e$ is an expression, and $x$ is a variable that does not occur free in $e$.
])

== Conditionals

#table(
  columns: 3,
  align: (left, center, left),
  stroke: none,
  $italic("lexp")$, $->$, $terminal("if") nonterminal("exp") [terminal(";")] terminal("then") nonterminal("exp") [terminal(";")] terminal("else") nonterminal("exp")$

)

A _conditional expression_ has the form $mono("if") e_1 mono("then") e_2 mono("else") e_3$ and returns the value of $e_2$ if the
value of $e_1$ is `True`, $e_3$ if $e_1$ is `False`, and $bot$ otherwise.

#translation-box([
  The following identity holds:
  $
    mono("if") e_1 mono("then") e_2 mono("else") e_3 = mono("case") e_1 mono("of") { mono("True") mono("->") e_2 mono(";") mono("False") mono("->") e_3}
  $
  where `True` and `False` are the two nullary constructors from the type `Bool`, as defined in the Prelude.
  The type of $e_1$ must be `Bool`;
  $e_2$ and $e_3$ must have the same type, which is also the type of the entire conditional expression.
])


== Lists <sec:lists>

#table(
  columns: 4,
  align: (left, center, left, left),
  stroke: none,
  // infixexp
  $italic("infixexp")$, $->$, $nonterminal("exp")_1 nonterminal("qop") nonterminal("exp")_2$, [],
  // aexp
  $italic("aexp")$, $->$, $terminal("[") nonterminal("exp")_1 terminal(",") dots terminal(",") nonterminal("exp")_k terminal("]")$, $(k >= 1)$,
  $$, $|$, $nonterminal("gcon")$, [],
  // gcon
  $italic("gcon")$, $->$, $terminal("[]")$, [],
  [], $|$, $nonterminal("qcon")$, [],
  // qcon
  $italic("qcon")$, $->$, $terminal("(") nonterminal("gconsym") terminal(")")$, [],
  // qop
  $italic("qop")$, $->$, $nonterminal("qconop")$, [],
  // qconop
  $italic("qconop")$, $->$, $nonterminal("gconsym")$,[],
  // gconsym
  $italic("gconsym")$, $->$, $terminal(":")$, [],
)

_Lists_ are written $[e_1, dots, e_k]$, where $k >= 1$.
The list constructor is `:`, and the empty list is denoted `[]`.
Standard operations on lists are given in the Prelude (see @subsec:basic-lists, and
@chapter:standard-prelude notably @sec:preludelist).

#translation-box([
  The following identity holds:
  $
    [e_1, dots, e_k] = e_1 : (e_2 : ( dots ( e_k : [ thin ])))
  $
  where `:` and `[]` are constructors for lists, as defined in the Prelude (see @subsec:basic-lists).
  The types of $e_1$ through $e_k$ must all be the same (call it $t$), and the
  type of the overall expression is `[t]` (see @sec:type-syntax).
])

The constructor "`:`" is reserved solely for list construction; like `[]`, it is considered part of the language syntax, and cannot be hidden or redefined.
It is a right-associative operator, with precedence level 5 (@sec:fixity-declarations).

== Tuples <sec:tuple-expression>

#table(
  columns: 4,
  align: (left, center, left, left),
  stroke: none,
  $italic("aexp")$, $->$, $terminal("(") nonterminal("exp")_1 terminal(",") dots terminal(",") nonterminal("exp")_k terminal(")")$, $(k >= 2)$,
  [], $|$, $nonterminal("qcon")$, [],
  $italic("qcon")$, $->$, $terminal("(") terminal(","){ terminal(",")}terminal(")")$, []
)

_Tuples_ are written $(e_1, dots, e_k)$, and may be
of arbitrary length $k >= 2$.
The constructor for an $n$-tuple is denoted by $(, dots ,)$, where there are $n-1$ commas.
Thus `(a,b,c)` and `(,,) a b c` denote the same value.
Standard operations on tuples are given
in the Prelude (see @subsec:basic-tuples and @chapter:standard-prelude).

#translation-box([
  $(e_1, dots, e_k)$ for $k >= 2$ is an instance of a $k$-tuple as defined in the Prelude, and requires no translation.
  If $t_1$ through $t_k$ are the types of $e_1$ through $e_k$, respectively, then the type of the resulting tuple is $(t_1, dots, t_k)$ (see @sec:type-syntax).
])



== Unit Expressions and Parenthesized Expressions <sec:unit-expression>

#table(
  columns: 3,
  align: (left, center, left),
  stroke: none,
  $italic("aexp")$, $->$, $nonterminal("gcon")$,
  [], $|$, $terminal("(") nonterminal("exp") terminal(")")$,
  $italic("gcon")$, $->$, $terminal("()")$
)

The form $(e$) is simply a _parenthesized expression_, and is equivalent to $e$.
The _unit expression_ `()` has type `()` (see @sec:type-syntax).
It is the only member of that type apart from $bot$, and can be thought of as the "nullary tuple" (see @subsec:basic-trivial).

#translation-box([
  $(e)$ is equivalent to $e$.
])

== Arithmetic Sequences <sec:arithmetic-sequences>

#table(
  columns: 3,
  align: (left, center, left),
  stroke: none,
  $italic("aexp")$, $->$, $terminal("[") nonterminal("exp")_1 [terminal(",") nonterminal("exp")_2] terminal("..") [nonterminal("exp")_3] terminal("]")$,
)

The _arithmetic sequence_ $[e_1, e_2 .. e_3]$ denotes a list of values of type $t$, where each of the $e_i$ has type $t$, and $t$ is an instance of class `Enum`.

#translation-box([
  Arithmetic sequences satisfy these identities:
  #table(
    columns: 3,
    align: (left, center, left),
    stroke: none,
    [`[` $e_1$ `..]`], $=$, [`enumFrom` $e_1$],
    [`[` $e_1$, $e_2$ `..]`], $=$, [`enumFromThen` $e_1$ $e_2$],
    [`[` $e_1$ `..` $e_2$ `]`], $=$, [`enumFromTo` $e_1$ $e_2$],
    [`[` $e_1$, $e_2$ `..` $e_3$ `]`], $=$, [`enumFromThenTo` $e_1$ $e_2$ $e_3$],
  )

  where `enumFrom`, `enumFromThen`, `enumFromTo`, and `enumFromThenTo` are class methods in the class `Enum` as defined in the Prelude (see @subsec:enum-class).
])

The semantics of arithmetic sequences therefore depends entirely on the instance declaration for the type `t`.
See @subsec:enum-class for more details of which `Prelude` types are in `Enum` and their semantics.

== List Comprehensions <sec:list-comprehensions>

#table(
  columns: 4,
  align: (left, center, left, left),
  stroke: none,
  $italic("aexp")$, $->$, $terminal("[") nonterminal("exp") terminal("|") nonterminal("qual")_1 terminal(",") dots terminal(",") nonterminal("qual")_n terminal("]")$, [(list comprehension, $n >= 1$)],
  $italic("qual")$, $->$, $nonterminal("pat") terminal("<-") nonterminal("exp")$, [(generator)],
  $$, $|$, $terminal("let") nonterminal("decls")$, [(local declaration)],
  $$, $|$, $nonterminal("exp")$, [(boolean guard)],
)

A _list comprehension_ has the form $[e | q_1, dots, q_n]$, $n >= 1$,
where the $q_i$ qualifiers are either

- _generators_ of the form $p mono("<-") e$, where $p$ is a
  pattern (see @sec:pattern-matching) of type $t$ and $e$ is an
  expression of type $[t]$
- _local bindings_ that provide new definitions for use in
  the generated expression $e$ or subsequent boolean guards and generators
- _boolean guards_, which are arbitrary expressions of
  type `Bool`.


Such a list comprehension returns the list of elements
produced by evaluating $e$ in the successive environments
created by the nested, depth-first evaluation of the generators in the
qualifier list.  Binding of variables occurs according to the normal
pattern matching rules (see @sec:pattern-matching), and if a
match fails then that element of the list is simply skipped over.  Thus:
```haskell
[ x |  xs   <- [ [(1,2),(3,4)], [(5,4),(3,2)] ],
      (3,x) <- xs ]
```
yields the list `[4,2]`.  If a qualifier is a boolean guard, it must evaluate
to `True` for the previous pattern match to succeed.
As usual, bindings in list comprehensions can shadow those in outer scopes; for example:
$
  [x | x mono("<-") x, x mono("<-") x] = [z | y mono("<-") x, z mono("<-") y]
$
#translation-box([
  List comprehensions satisfy these identities, which may be used as a translation into the kernel:
  #table(
    columns: 3,
    align: (left, center, left),
    stroke: none,
    $[e | mono("True")]$,$=$, $[e]$,
    $[e | q]$,$=$,$[e | q, mono("True")]$,
    $[e | b, Q]$, $=$, $mono("if") b mono("then") [e, Q] mono("else") []$,
    $[e | p mono("<-") l, Q]$, $=$, $mono("let ok") = [e | Q]$,
    $$, $$, $mono("      ok") \_ = []$,
    $$, $$, $mono("in concatMap ok") l$,
    $[e | mono("let") italic("decls"), Q]$, $=$, $mono("let") italic("decls") mono("in") [e | Q]$
  )

  where $e$ ranges over expressions, $p$ over
  patterns, $l$ over list-valued expressions, $b$ over
  boolean expressions, $italic("decls")$ over declaration lists, $q$ over qualifiers, and $Q$ over sequences of qualifiers.  `ok` is a fresh variable.
  The function `concatMap`, and boolean value `True`, are defined in the Prelude.
])

As indicated by the translation of list comprehensions, variables
bound by `let` have fully polymorphic types while those defined by
`<-` are lambda bound and are thus monomorphic (see @sec:monomorphism).

== Let Expressions <sec:let-expressions>

#table(
  columns: 3,
  align: (left, center, left),
  stroke: none,
  $italic("lexp")$, $->$, $terminal("let") nonterminal("decls") terminal("in") nonterminal("exp")$
)


_Let expressions_ have the general form $mono("let") { d_1; dots ; d_n} mono("in") e$,
and introduce a
nested, lexically-scoped,
mutually-recursive list of declarations (`let` is often called `letrec`).  The scope of the declarations is the expression $e$ and the right hand side of the declarations.  Declarations are
described in @chapter:declarations.  Pattern bindings are matched
lazily; an implicit `~` makes these patterns
irrefutable.
For example,
$
  mono("let") (x,y) = mono("undefined in") e
$

does not cause an execution-time error until `x` or `y` is evaluated.

#translation-box([
  The dynamic semantics of the expression
  $mono("let") { d_1; dots ; d_n} mono("in") e_0$
  are captured by this translation: After removing all type signatures, each declaration $d_i$ is translated into an equation of the form $p_i = e_i$, where $p_i$ and $e_i$ are patterns and expressions
  respectively, using the translation in
  @subsec:function-and-pattern-bindings.  Once done, these identities
  hold, which may be used as a translation into the kernel:
  #table(
    columns: 3,
    align: (left, center, left),
    stroke: none,
    $mono("let") { p_1 = e_1 ; dots ; p_n = e_n} mono("in") e_0$, $=$, $mono("let")(~p_1, dots,~p_n) = (e_1, dots, e_n) mono("in") e_0$,
    $mono("let") p = e_1 mono("in") e_0$, $=$, $mono("case") e_1 mono("of") ~p mono("->") e_0$,
    $$, $$, [where no variable in $p$ appears free in $e_1$],
    $mono("let") p = e_1 mono("in") e_0$, $=$, $mono("let") p = mono("fix") (\\ ~p mono("->") e_1) mono("in") e_0$
  )

  where `fix` is the least fixpoint operator.  Note the use of the irrefutable patterns `~p`.
  This translation
  does not preserve the static semantics because the use of `case` precludes a fully polymorphic typing of the bound variables.
  The static semantics of the bindings in a `let` expression are described in
  @subsec:function-and-pattern-bindings.
])

== Case Expressions <sec:case>

#table(
  columns: 4,
  align: (left, center, left, left),
  stroke: none,
  $italic("lexp")$, $->$, $terminal("case") nonterminal("exp") terminal("of {") nonterminal("alts") terminal("}")$,$$,
  $italic("alts")$, $->$, $nonterminal("alt")_1 terminal(";") dots terminal(";") nonterminal("alt")_n$, $(n >= 1)$,
  $italic("alt")$, $->$,$nonterminal("pat") terminal("->") nonterminal("exp") [terminal("where") nonterminal("decls")]$,$$,
  $$,$|$,$nonterminal("pat") nonterminal("gdpat") [terminal("where") nonterminal("decls")]$,[],
  $$,$|$,$$,[(empty alternative)],
  $italic("gdpat")$, $->$,$nonterminal("guards") terminal("->") nonterminal("exp") [ nonterminal("gdpat")]$,$$,
  $italic("guards")$, $->$,$terminal("|") nonterminal("guard")_1 terminal(",") dots terminal(",") nonterminal("guard")_n$,$(n >= 1)$,
  $italic("guard")$, $->$,$nonterminal("pat") terminal("<-") nonterminal("infixexp")$,[(pattern guard)],
  $$,$|$,$terminal("let") nonterminal("decls")$,[(local declaration)],
  $$,$|$,$nonterminal("infixexp")$, [(boolean guard)]
)

A _case expression_ has the general form
$
  mono("case") e mono("of") { p_1 italic("match")_1 ; dots ; p_n italic("match")_n}
$
where each $italic("match")_i$ is of the general form
$
  &| italic("gs")_(i 1) mono("->") e_(i 1) \
  & dots \
  &| italic("gs")_(i m_i) mono("->") e_(i m_i) \
  &mono("where") italic("decls")_i
$
(Notice that in the syntax rule for $italic("guards")$, the "`|`" is a terminal symbol, not the syntactic metasymbol for alternation.)
Each alternative $p_i italic("match")_i$ consists of a
pattern $p_i$ and its matches, $italic("match")_i$.
Each match in turn
consists of a sequence of pairs of guards $italic("gs")_(italic("ij"))$ and bodies $e_(italic("ij"))$ (expressions), followed by
optional bindings ($italic("decls")_i$) that scope over all of the guards and expressions of the alternative.

A _guard_ has one of the following forms:

- _pattern guards_ are of the form $p mono("<-") e$, where
  $p$ is a
  pattern (see @sec:pattern-matching) of type $t$ and $e$ is an
  expression type $t$#footnote[Note that the syntax of a pattern guard is the same as that of a generator in a list comprehension.
  The contextual difference is that, in a list comprehension, a pattern of type $t$ goes with an expression of type $[t]$.].
  They succeed if the expression $e$ matches the pattern $p$, and introduce the bindings of the pattern to the environment.
- _local bindings_ are of the form $mono("let") italic("decls")$.
  They always succeed, and they introduce the names defined in $italic("decls")$ to the environment.
- _boolean guards_ are arbitrary expressions of
  type `Bool`.  They succeed if the expression evaluates to `True`, and they do not introduce new names to the environment.  A boolean guard, $g$, is semantically equivalent to the pattern guard $mono("True <-") g$.

An alternative of the form
$
  italic("pat") mono("->") italic("exp") mono("where") italic("decls")
$
is treated as shorthand for:
$
  &italic("pat") | mono("True ->") italic("exp") \
  &mono("where") italic("decls")
$

A case expression must have at least one alternative and each alternative must
have at least one body.  Each body must have the same type, and the
type of the whole expression is that type.

A case expression is evaluated by pattern matching the expression $e$
against the individual alternatives.  The alternatives are tried
sequentially, from top to bottom.  If $e$ matches the pattern of an
alternative, then the guarded expressions for that alternative are
tried sequentially from top to bottom in the environment of the case
expression extended first by the bindings created during the matching
of the pattern, and then by the $italic("decls")_i$ in the `where` clause associated with that alternative.

For each guarded expression, the comma-separated guards are tried
sequentially from left to right.  If all of them succeed, then the
corresponding expression is evaluated in the environment extended with
the bindings introduced by the guards.  That is, the bindings that are
introduced by a guard (either by using a let clause or a pattern
guard) are in scope in the following guards and the corresponding
expression.  If any of the guards fail, then this guarded expression
fails and the next guarded expression is tried.

If none of the guarded expressions for a given alternative succeed,
then matching continues with the next alternative.  If no alternative
succeeds, then the result is $bot$.  Pattern matching is described in
@sec:pattern-matching, with the formal semantics of case
expressions in @subsec:formal-semantics-pattern-matching.

_A note about parsing._
The expression
```haskell
  case x of { (a,_) | let b = not a in b :: Bool -> a }
```
is tricky to parse correctly.  It has a single unambiguous parse, namely
```haskell
  case x of { (a,_) | (let b = not a in b :: Bool) -> a }
```
However, the phrase `Bool -> a` is syntactically valid as a type, and parsers with limited lookahead may incorrectly commit to this choice, and hence reject the program.
Programmers are advised, therefore, to avoid guards that
end with a type signature --- indeed that is why a $italic("guard")$ contains an $italic("infixexp")$ not an $italic("exp")$.

== Do Expressions <sec:do-expressions>

#table(
  columns: 4,
  align: (left, center, left, left),
  stroke: none,
  $italic("lexp")$, $->$, $terminal("do {") nonterminal("stmts") terminal("}")$, [(do expression)],
  $italic("stmts")$, $->$, $nonterminal("stmt")_1 dots nonterminal("stmt")_n nonterminal("exp") [terminal(";")]$, $(n >= 0)$,
  $italic("stmt")$, $->$, $nonterminal("exp") terminal(";")$, [],
  $$,$|$,$nonterminal("pat") terminal("<-") nonterminal("exp") terminal(";")$,[],
  $$,$|$,$terminal("let") nonterminal("decls") terminal(";")$,[],
  $$,$|$,$terminal(";")$,[(empty statement)],
)

A _do expression_ provides a more conventional syntax for monadic programming.
It allows an expression such as
```haskell
  putStr "x: "    >>
  getLine         >>= \l ->
  return (words l)
```
to be written in a more traditional way as:
```haskell
  do putStr "x: "
     l <- getLine
     return (words l)
```

#translation-box([
  Do expressions satisfy these identities, which may be
  used as a translation into the kernel, after eliminating empty $italic("stmts")$:
  #table(
    columns: 3,
    align: (left, center, left),
    stroke: none,
    $mono("do") {e}$, $=$, $e$,
    $mono("do") {e ; italic("stmts")}$, $=$, $e mono(">>") mono("do") {italic("stmts")}$,
    $mono("do") {p mono("<-") e; italic("stmts")}$, $=$,$mono("let ok") p = mono("do") { italic("stmts")}$,
    $$,$$,$mono("      ok") \_ = mono("fail \"...\"")$,
    $$,$$,$mono("in") e mono(">>=") mono("ok")$,
    $mono("do") {mono("let") italic("decls"); italic("stmts")}$, $=$,$mono("let") italic("decls") mono("in do") { italic("stmts")}$
  )

  The ellipsis "`...`" stands for a compiler-generated error message,
  passed to `fail`, preferably giving some indication of the location
  of the pattern-match failure;
  the functions `>>`, `>>=`, and `fail` are operations in the class `Monad`,
  as defined in the Prelude; and `ok` is a fresh identifier.
])

As indicated by the translation of `do`, variables bound by `let` have fully polymorphic types while those defined by `<-` are lambda bound and are thus monomorphic.

== Datatypes with Field Labels <sec:field-ops>

A datatype declaration may optionally define field labels
(see @sec:datatype-decls).
These field labels can be used to
construct, select from, and update fields in a manner
that is independent of the overall structure of the datatype.

Different datatypes cannot share common field labels in the same scope.
A field label can be used at most once in a constructor.
Within a datatype, however, a field label can be used in more
than one constructor provided the field has the same typing in all
constructors. To illustrate the last point, consider:
```haskell
  data S = S1 { x :: Int } | S2 { x :: Int }   -- OK
  data T = T1 { y :: Int } | T2 { y :: Bool }  -- BAD
```
Here `S` is legal but `T` is not, because `y` is given
inconsistent typings in the latter.

=== Field Selection

#table(
  columns: 3,
  align: (left, center, left),
  stroke: none,
  $italic("aexp")$, $->$, $nonterminal("qvar")$
)

Field labels are used as selector functions.
When used as a variable, a field label serves as a function that extracts the field from an object.
Selectors are top level bindings and so they
may be shadowed by local variables but cannot conflict with
other top level bindings of the same name.  This shadowing only
affects selector functions; in record construction (@sec:record-construction)
and update (@sec:record-update), field labels
cannot be confused with ordinary variables.

#translation-box([
  A field label $f$ introduces a selector function defined as:
  $
    f x = mono("case") x mono("of") { C_1 p_(11) dots p_(1k) mono("->") e_1 ; dots ; C_n p_(n 1) dots p_(n k) mono("->") e_n}
  $
  where $C_1 dots C_n$ are all the constructors of the datatype containing a
  field labeled with $f$, $p_(i j)$ is $y$ when $f$ labels the $j$th
  component of $C_i$ or $\_$ otherwise, and $e_i$ is $y$ when some field in $C_i$ has a label of $f$ or `undefined` otherwise.
])

=== Construction Using Field Labels <sec:record-construction>

#table(
  columns: 4,
  align: (left, center, left, left),
  stroke: none,
  $italic("aexp")$, $->$, $nonterminal("qcon") terminal("{") nonterminal("fbind")_1 terminal(",") dots terminal(",") nonterminal("fbind")_n terminal("}")$, [(labeled construction, $n >= 0$)],
  $italic("fbind")$, $->$, $nonterminal("qvar") terminal("=") nonterminal("exp")$,[],
)

A constructor with labeled fields may be used to construct a value
in which the components are specified by name rather than by position.
Unlike the braces used in declaration lists, these are not subject to
layout; the `{` and `}` characters must be explicit.
(This is also true of field updates and field patterns.)
Construction using field labels is subject to the following constraints:

- Only field labels declared with the specified constructor may be mentioned.
- A field label may not be mentioned more than once.
- Fields not mentioned are initialized to $bot$.
- A compile-time error occurs when any strict fields (fields
  whose declared types are prefixed by `!`) are omitted during
  construction.  Strict fields are discused in @sec:datatype-decls.

The expression `F {}`, where `F` is a data constructor, is legal
_whether or not `F` was declared with record syntax_ (provided `F` has no strict fields --- see the fourth bullet above);
it denotes $F bot_1 dots bot_n$, where $n$ is the arity of `F`.

#translation-box([
  In the binding $f = v$, the field $f$ labels $v$.
  #table(
    columns: 3,
    align: (left, center, left),
    stroke: none,
    $C { italic("bs") }$, $=$, $C (italic("pick")^C_1 italic("bs") mono("undefined")) dots (italic("pick")^C_k italic("bs") mono("undefined"))$,
  )
  where $k$ is the arity of $C$.

  The auxiliary function $italic("pick")^C_i italic("bs") d$ is defined as follows:
  #quote(block: true)[
    If the $i$th component of a constructor $C$ has the
    field label $f$, and if $f = v$ appears in the binding list $italic("bs")$
    , then $italic("pick")^C_i italic("bs") d$ is $v$.  Otherwise, $italic("pick")^C_i italic("bs") d$ is
    the default value $d$.
  ]
])
=== Updates Using Field Labels <sec:record-update>

#table(
  columns: 4,
  align: (left, center, left, left),
  stroke: none,
  $italic("aexp")$, $->$, $nonterminal("aexp")_(chevron.l nonterminal("qcon") chevron.r) terminal("{") nonterminal("fbind")_1 terminal(",") dots terminal(",") nonterminal("fbind")_n terminal("}")$, [(labeled update, $n >= 1$)]
)

Values belonging to a datatype with field labels may be
non-destructively updated.  This creates a new value in which the
specified field values replace those in the existing value.
Updates are restricted in the following ways:

- All labels must be taken from the same datatype.
- At least one constructor must define all of the labels
  mentioned in the update.
- No label may be mentioned more than once.
- An execution error occurs when the value being updated does
  not contain all of the specified labels.

#translation-box([
  Using the prior definition of $italic("pick")$,
  #table(
    columns: 3,
    align: (left, center, left),
    stroke: none,
    $e {italic("bs")}$, $=$, $mono("case") e mono("of")$,
    $$, $$,$quad C_1 v_1 dots v_(k_1) mono("->") C_1 (italic("pick")^(C_1)_1 italic("bs") v_1) dots (italic("pick")^(C_1)_(k_1) italic("bs") v_(k_1))$,
    $$, $$, $quad quad dots$,
    $$, $$,$quad C_j v_1 dots v_(k_j) mono("->") C_j (italic("pick")^(C_j)_1 italic("bs") v_1) dots (italic("pick")^(C_j)_(k_j) italic("bs") v_(k_j))$,
    $$, $$,$quad mono("_ -> error \"Update error\"")$
  )
  where ${ C_1, dots, C_j}$ is the set of constructors containing all labels in $italic("bs")$, and $k_i$ is the arity of $C_i$.

])

Here are some examples using labeled fields:
```haskell
data T    = C1 {f1,f2 :: Int}
          | C2 {f1 :: Int,
                f3,f4 :: Char}
```

#table(
  columns: 2,
  align: (left, left),
  stroke: none,
  table.vline(x: 0),
  table.vline(x: 1),
  table.vline(x: 2),
  table.hline(),
  table.header([Expression], [Translation]),
  table.hline(),
  [`C1 {f1 = 3}`],[`C1 3 undefined`],
  [`C2 {f1 = 1, f4 = 'A', f3 = 'B'}`],[`C2 1 'B' 'A'`],
  [`x {f1 = 1}`],[`case x of C1 _ f2    -> C1 1 f2`],
  [],[`          C2 _ f3 f4 -> C2 1 f3 f4`],
  table.hline(),
)

The field `f1` is common to both constructors in T.  This
example translates expressions using constructors in field-label
notation into equivalent expressions using the same constructors
without field labels.
A compile-time error will result if no single constructor
defines the set of field labels used in an update, such as `x {f2 = 1, f3 = 'x'}`.

== Expression Type-Signatures <sec:expression-type-sigs>


_Expression type-signatures_ have the form $e mono("::") t$, where $e$ is an expression and $t$ is a type (@sec:type-syntax); they
are used to type an expression explicitly
and may be used to resolve ambiguous typings due to overloading (see @sec:default-decls).
The value of the expression is just that of
$italic("exp")$.  As with normal type signatures (see
@sec:type-signatures), the declared type may be more specific than
the principal type derivable from $italic("exp")$, but it is an error to give a type that is more general than, or not comparable to, the principal type.

#translation-box[
  #table(
    columns: 3,
    align: (left, center, left),
    stroke: none,
    $e mono("::") t$, $=$, $mono("let") { v mono("::") t; v = e} mono("in") v$
  )
]

== Pattern Matching <sec:pattern-matching>

_Patterns_ appear in lambda abstractions, function definitions, pattern
bindings, list comprehensions, do expressions, and case expressions.
However, the
first five of these ultimately translate into case expressions, so
defining the semantics of pattern matching for case expressions is sufficient.

=== Patterns

Patterns have this syntax:
#table(
  columns: 4,
  align: (left, center, left, left),
  stroke: none,
  // pat
  $italic("pat")$,$->$,$nonterminal("lpat") nonterminal("qconop") nonterminal("pat")$,[(infix constructor)],
  $$,$|$,$nonterminal("lpat")$,$$,
  // lpat
  $italic("lpat")$,$->$,$nonterminal("apat")$,$$,
  $$,$|$,$terminal("-") (nonterminal("integer") | nonterminal("float"))$,[(negative literal)],
  $$,$|$,$nonterminal("gcon") nonterminal("apat")_1 dots nonterminal("apat")_k $,[(arity $italic("gcon") = k$, $k >= 1$)],
  // apat
  $italic("apat")$,$->$,$nonterminal("var") [terminal("@") nonterminal("apat")]$,[(as pattern)],
  $$,$|$,$nonterminal("gcon")$,[(arity $italic("gcon") = 0$)],
  $$,$|$,$nonterminal("qcon") terminal("{") nonterminal("fpat")_1 terminal(",") dots terminal(",") nonterminal("fpat")_k terminal("}")$,[(labeled pattern, $k >= 0$)],
  $$,$|$,$nonterminal("literal")$,[],
  $$,$|$,$terminal("_")$,[(wildcard)],
  $$,$|$,$terminal("(") nonterminal("pat") terminal(")")$,[(parenthesized pattern)],
  $$,$|$,$terminal("(") nonterminal("pat")_1 terminal(",") dots terminal(",") nonterminal("pat") terminal(")")$, [(tuple pattern, $k >= 2$)],
  $$,$|$,$terminal("[") nonterminal("pat")_1 terminal(",") dots terminal(",") nonterminal("pat") terminal("]")$, [(list pattern, $k >= 1$)],
  $$,$|$,$terminal("~") nonterminal("apat")$,[(irrefutable pattern)],
  // fpat
  $italic("fpat")$,$->$,$nonterminal("qvar") terminal("=") nonterminal("pat")$,$$,
)

All patterns must be _linear_---no variable may appear more than once.
For example, this definition is illegal:
```haskell
f (x,x) = x     -- ILLEGAL; x used twice in pattern
```
Patterns of the form $italic("var")mono("@")italic("pat")$ are called _as-patterns_,
and allow one to use $italic("var")$
as a name for the value being matched by $italic("pat")$.  For example,
```haskell
case e of { xs@(x:rest) -> if x==0 then rest else xs }
```
is equivalent to:
```haskell
let { xs = e } in
  case xs of { (x:rest) -> if x==0 then rest else xs }
```

Patterns of the form `_` are _wildcards_ and are useful when some part of a pattern
is not referenced on the right-hand-side.  It is as if an
identifier not used elsewhere were put in its place.  For example,
```haskell
case e of { [x,_,_]  ->  if x==0 then True else False }
```
is equivalent to:
```haskell
case e of { [x,y,z]  ->  if x==0 then True else False }
```

=== Informal Semantics of Pattern Matching

Patterns are matched against values.  Attempting to match a pattern
can have one of three results: it may _fail_; it may _succeed_, returning a binding for each variable in the pattern; or it
may _diverge_ (i.e.~return $bot$).  Pattern matching proceeds from left to right, and outside to inside, according to the following rules:

1. Matching the pattern $italic("var")$ against a value $v$ always succeeds and binds $italic("var")$ to $v$.
2. Matching the pattern $~ italic("apat")$ against a value $v$ always succeeds.
   The free variables in $italic("apat")$ are bound to the appropriate values if matching
   $italic("apat")$ against $v$ would otherwise succeed, and to $bot$ if matching
   $italic("apat")$ against $v$ fails or diverges.  (Binding does _not_ imply evaluation.)

   Operationally, this means that no matching is done on a
   $~italic("apat")$ pattern until one of the variables in $italic("apat")$ is used.
   At that point the entire pattern is matched against the value, and if
   the match fails or diverges, so does the overall computation.
3. Matching the wildcard pattern `_` against any value always succeeds, and no binding is done.
4. Matching the pattern $italic("con") italic("pat")$ against a value, where $italic("con")$ is a
   constructor defined by `newtype`, depends on the value:
   - If the value is of the form $italic("con") v$, then $italic("pat")$ is matched against $v$.
   - If the value is $bot$, then $italic("pat")$ is matched against $bot$.
   That is, constructors associated with
   `newtype` serve only to change the type of a value.
5. Matching the pattern $italic("con") italic("pat")_1 dots italic("pat")_n$ against a value, where $italic("con")$ is a
   constructor defined by `data`, depends on the value:
   - If the value is of the form $italic("con") v_1 dots v_n$,
     sub-patterns are matched left-to-right against the components of the data value;
     if all matches succeed, the overall match
     succeeds; the first to fail or diverge causes the overall match to
     fail or diverge, respectively.
   - If the value is of the form $italic("con")' v_1 dots v_m$, where $italic("con")$ is a different
     constructor to $italic("con")'$, the match fails.
   - If the value is $bot$, the match diverges.
6. Matching against a constructor using labeled fields is the same as
   matching ordinary constructor patterns except that the fields are
   matched in the order they are named in the field list.  All fields
   listed must be declared by the constructor; fields may not be named
   more than once.  Fields not named by the pattern are ignored (matched
   against `_`).
7. Matching a numeric, character, or string literal pattern $k$ against a value $v$
   succeeds if $v mono("==") k$, where `==`
   is overloaded based on the type of the pattern.  The match diverges if this test diverges.

   The interpretation of numeric literals is exactly as described in @sec:vars-and-lits;
   that is, the overloaded function `fromInteger` or `fromRational` is
   applied to an `Integer` or `Rational` literal (resp)
   to convert it to the appropriate type.
8. Matching an as-pattern $italic("var")mono("@")italic("apat")$ against a value $v$ is
   the result of matching $italic("apat")$ against $v$, augmented with the binding of
   $italic("var")$ to $v$.  If the match of $italic("apat")$ against $v$ fails or diverges,
   then so does the overall match.

Aside from the obvious static type constraints (for
example, it is a static error to match a character against a
boolean), the following static class constraints hold:

- An integer literal pattern can only be matched against a value in the class `Num`.
- A floating literal pattern can only be matched against a value
  in the class `Fractional`.


It is sometimes helpful to distinguish two kinds of
patterns.  Matching an _irrefutable pattern_
is non-strict: the pattern matches even if the value to be matched is $bot$.
Matching a _refutable_ pattern is strict: if the value to be matched
is $bot$ the match diverges.
The irrefutable patterns are as follows:
a variable, a wildcard, $N italic("apat")$ where $N$ is a constructor
defined by `newtype` and $italic("apat")$ is irrefutable (see @sec:datatype-renamings),
$italic("var")mono("@")italic("apat")$ where $italic("apat")$ is irrefutable,
or of the form $~italic("apat")$ (whether or not $italic("apat")$ is irrefutable).
All other patterns are _refutable_.

Here are some examples:

1. If the pattern `['a','b']` is matched against $['x',bot]$, then `'a'` _fails_ to match against `'x'`, and the result is a failed match.  But
   if `['a','b']` is matched against $[bot,'x']$, then attempting to match `'a'` against $bot$ causes the match to _diverge_.
2. These examples demonstrate refutable vs.~irrefutable
   matching:

   #table(
    columns: 3,
    align: (left, center, left),
    stroke: none,
    [`(\ ~(x,y) -> 0)` $bot$], $=>$, $0$,
    [`(\  (x,y) -> 0)` $bot$], $=>$, $bot$,
    [`(\ ~[x] -> 0) []`], $=>$, $0$,
    [`(\ ~[x] -> x) []`], $=>$, $bot$,
    [`(\ ~[x, ~(a,b)] -> x` $[(0,1), bot]$], $=>$, $(0,1)$,
    [`(\ ~[x,  (a,b)] -> x` $[(0,1), bot]$], $=>$, $bot$,
    [`(\ (x:xs) -> x:x:xs)` $bot$], $=>$, $bot$,
    [`(\ ~(x:xs) -> x:x:xs)` $bot$], $=>$, $bot : bot : bot$,
   )


3. Consider the following declarations:
   ```haskell
   newtype N = N Bool
   data    D = D !Bool
   ```
   These examples illustrate the difference in pattern matching
   between types defined by `data` and `newtype`:
   #table(
    columns: 3,
    align: (left, center, left),
    stroke: none,
    [`(\ (N True) -> True)` $bot$], $=>$, $bot$,
    [`(\ (D True) -> True)` $bot$], $=>$, $bot$,
    [`(\ ~(D True) -> True)` $bot$], $=>$, [`True`],
   )

   Additional examples may be found in @sec:datatype-renamings.

Top level patterns in case expressions and the set of top level
patterns in function or pattern bindings may have zero or more
associated _guards_.
See @sec:case for the syntax and semantics of guards.

The guard semantics have an influence on the
strictness characteristics of a function or case expression.  In
particular, an otherwise irrefutable pattern
may be evaluated because of a guard.  For example, in
```haskell
f :: (Int,Int,Int) -> [Int] -> Int
f ~(x,y,z) [a] | (a == y) = 1
```
both `a` and `y` will be evaluated by `==` in the guard.

=== Formal Semantics of Pattern Matching <subsec:formal-semantics-pattern-matching>

The semantics of all pattern matching constructs other than `case`
expressions are defined by giving identities that relate those
constructs to `case` expressions.
The semantics of `case` expressions themselves are in turn given as a series of identities, in @fig:simple-case-expr-1 -- @fig:simple-case-expr-3.
Any implementation should behave so that these identities hold; it is
not expected that it will use them directly, since that
would generate rather inefficient code.

In @fig:simple-case-expr-1 -- @fig:simple-case-expr-3:
$e$, $e'$ and $e_i$ are expressions;
$g_i$ and $italic("gs")_i$ are guards and sequences of guards respectively;
$p$ and $p_i$ are patterns;
$v$, $x$, and $x_i$ are variables;
$K$ and $K'$ are algebraic datatype (`data`) constructors (including
tuple constructors);  and $N$ is a `newtype` constructor.

Rule~(b) matches a general source-language
`case` expression, regardless of whether it actually includes
guards---if no guards are written, then `True` is substituted for the guards $italic("gs")_(i,j)$
in the $italic("match")_i$ forms.
Subsequent identities manipulate the resulting `case` expression into simpler and simpler forms.

Rule~(h) in @fig:simple-case-expr-2 involves the
overloaded operator `==`; it is this rule that defines the
meaning of pattern matching against overloaded constants.

These identities all preserve the static semantics.  Rules~(d), (e), (j), and~(q)
use a lambda rather than a `let`; this indicates that variables bound
by `case` are monomorphically typed (@sec:type-semantics).

#let caseof(x, y) = { $mono("case") #x mono("of") { space #y space }$ }

#figure(
  caption: "Semantics of Case Expressions, Part 1"
)[
  / (a): $caseof(e, italic("alts")) = (mono("\\")v mono("->") caseof(v, italic("alts"))) space e$\
    where $v$ is a new variable
  / (b): $mono("case") v mono("of") {space p_1 space italic("match")_1 mono(";") dots mono(";") p_n space italic("match")_n space }$ \
    $= mono("case") v mono("of") { space p_1 space italic("match")_1 ;$ \
    $#h(2.4cm)mono("_ ->") dots mono("case") v mono("of") {$ \
    $#h(4.4cm)p_n space italic("match")_n;$ \
    $#h(4.4cm)mono("_ -> error \"No match\"" } dots })$ \
    where each $italic("match")_i$ has the form
    $
      | italic("gs")_(i,1) mono("->") e_(i,1) mono(";") dots mono(";") italic("gs")_(i,m_i) mono("->") e_(i, m_i) mono("where") { italic("decls") }
    $
  / (c): $mono("case") v mono("of") { space p | italic("gs")_1 mono("->") e_1 mono(";") dots$ \
    $#h(2.325cm) | italic("gs")_n mono("->") e_n mono("where") { italic("decls") }$ \
    $#h(2cm) mono("_ ->") e' space}$ \
    $= mono("case") e' mono("of") { space y mono("->")$ \
    $#h(1cm) mono("case") v mono("of") {$ \
    $#h(2cm) p mono("->") mono("let") { italic("decls")} mono("in")$ \
    $#h(3cm) mono("case") () mono("of") {$ \
    $#h(3.5cm) () | italic("gs")_1 mono("->") e_1 mono(";")$\
    $#h(3.5cm) mono("_ -> ") dots mono("case") () mono("of") {$ \
    $#h(5cm) () | italic("gs")_n mono("->") e_n mono(";")$ \
    $#h(5cm) mono("_ ->") y space } space dots space }$ \
    $#h(2cm) mono("_ ->") y space }}$ \
    where $y$ is a new variable
  / (d): $mono("case") v mono("of") {mono("~") p mono("->") e mono("; _ -> ") e' }$ \
    $= (mono("\\")x_1 dots x_n mono("->") e) (mono("case") v mono("of"){p mono("->") x_1}) dots (mono("case") v mono("of") { p mono("->") x_n})$ \
    where $x_1, dots, x_n$ are all the variables in $p$
  / (e): $mono("case") v mono("of") { space x@p mono("->") e space ; space  mono("_ ->") e'}$ \
    $= mono("case") v mono("of") { p mono("->") (mono("\\")x mono("->") e) space v space ; space mono("_ ->") e' }$
  / (f): $mono("case") v mono("of") { space mono("_ ->") e space ; space mono("_ ->") e' space} = e$
]<fig:simple-case-expr-1>

#figure(
  caption: "Semantics of Case Expressions, Part 2"
)[
  / (g): $caseof(v, K p_1 dots p_n mono("->") e mono("_ ->") e')$ \
    $= mono("case") v mono("of") {$ \
    $#h(1cm)K space x_1 dots x_n mono("->") mono("case") x_1 mono("of") {$ \
    $#h(3.5cm) p_1 mono("->") dots mono("case") x_n mono("of") { p_n mono("->") e mono("; _ ->") e' } dots$ \
    $#h(3.5cm) mono("_ ->") e' }$ \
    $#h(1cm) mono("_ ->") e' }$ \
    at least one of $p_1,dots,p_n$ is not a variable; $x_1,dots,x_n$ are new variables
  / (h): $caseof(v, k mono("->") e mono("; _ ->") e') = mono("if") (v mono("==") k) mono("then") e mono("else") e'$ \
    where $k$ is a numeric, character, or string literal
  / (i): $caseof(v, x mono("->") e mono("; _ ->") e') = caseof(v, x mono("->") e)$
  / (j): $caseof(v, x mono("->") e) = (mono("\\") x mono("->") e) space v$
  / (k): $caseof(N v, N p mono("->") e mono("; _ ->") e')$ \
    $= caseof(v, p mono("->") e mono("; _ ->") e')$ \
    where $N$ is a `newtype` constructor
  / (l): $caseof(bot, N space p mono("->") e mono("; _ ->") e') = caseof(bot, p mono("-> ") e)$ \
    where $N$ is a newtype constructor
  / (m): $caseof(v, K { f_1 = p_1, f_2 = p_2, dots} mono("->") e mono("; _ ->") e')$ \
    $= mono("case") e' mono("of") {$ \
    $#h(1cm) y mono("->")$ \
    $#h(1.5cm)mono("case") v mono("of") {$ \
    $#h(2cm) K { f_1 = p_1 } mono("->")$ \
    $#h(2.5cm)mono("case") v mono("of") { K {f_2 = p_2, dots } mono("->") e mono("; _ ->") y} mono(";")$ \
    $#h(2.5cm)mono("_ ->") y }}$ \
    where $f_1,f_2,dots$ are fields of constructor $K$; $y$ is a new variable
  / (n): $caseof(v, K { f = p } mono("->") e mono("; _ ->") e')$ \
    $= mono("case") v mono("of") {$ \
    $#h(1cm) K p_1 dots p_n mono("->") e mono("; _ ->") e' }$ \
    where $p_i$ is $p$ if $f$ labels the $i$th component of $K$, `_` otherwise
  / (o): $caseof(v, K space { space } mono("->") e mono("; _ ->") e')$ \
    $= mono("case") v mono("of") {$ \
    $#h(1cm) K mono("_") dots mono("_") mono("->") e mono("; _ ->") e' }$
  / (p): $caseof((K' space e_1 dots e_m), K space x_1 dots x_n mono("->") e mono("; _ ->") e') = e'$ \
    where $K$ and $K'$ are distinct `data` constructors of arity $n$ and $m$, respectively
  / (q): $caseof((K e_1 dots e_n), K x_1 dots x_n mono("->") e mono("; _ ->") e')$ \
    $= (mono("\\")x_1 dots x_n mono("->") e) e_1 dots e_n$ \
    where $K$ is a `data` constructor of arity $n$
  / (r): $caseof(bot, K x_1 dots x_n mono("->") e mono("; _ ->") e') = bot$ \
    where $K$ is a `data` constructor of arity $n$
]<fig:simple-case-expr-2>

#figure(
  caption: "Semantics of Case Expressions, Part 3"
)[
  / (s): $caseof((), () | g_1mono(",") dots mono(",")g_n mono("->") e mono("; _ ->") e')$ \
    $= mono("case") () mono("of") {$ \
    $#h(2cm) () | g_1 mono("->") dots mono("case") () mono("of") {$ \
    $#h(4.5cm) () | g_n mono("->") e;$ \
    $#h(4.5cm) mono("_ ->") e' space } space dots$ \
    $#h(2cm) mono("_ ->") e' space }$ \
    where $y$ is a new variable
  / (t): $caseof((), () | p mono("<-") e_0 mono("->") e mono("; _ ->") e')$ \
    $=caseof(e_0, p mono("->") e mono("; _ ->") e')$
  / (u): $caseof((), () | mono("let") italic("decls") mono("->") e mono("; _ ->") e')$ \
    $= mono("let") italic("decls") mono("in") e$
  / (v): $caseof((),() | e_0 mono("->") e mono("; _ ->") e')$ \
    $= mono("if") e_0 mono("then") e mono("else") e'$
]<fig:simple-case-expr-3>