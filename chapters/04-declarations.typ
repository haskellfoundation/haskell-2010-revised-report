#import "../macros.typ" : *
In this chapter, we describe the syntax and informal semantics of Haskell _declarations_.

#table(
  columns: 4,
  stroke: none,
  align: (left, center, left, left),
  // module
  $italic("module")$, $->$, $terminal("module") nonterminal("modid") [ nonterminal("exports")] terminal("where") nonterminal("body")$,$$,
  $$, $|$, $nonterminal("body")$, $$,
  // body
  $italic("body")$, $->$, $terminal("{") nonterminal("impdecls") terminal(";") nonterminal("topdecls") terminal("}")$, $$,
  $$, $|$, $terminal("{") nonterminal("impdecls") terminal("}")$, $$,
  $$, $|$, $terminal("{") nonterminal("topdecls") terminal("}")$, $$,
  // topdecls
  $italic("topdecls")$, $->$, $nonterminal("topdecl")_1 terminal(";") dots terminal(";") nonterminal("topdecl")_n$, $(n >= 1)$,
  // topdecl
  $italic("topdecl")$, $->$, $terminal("type") nonterminal("simpletype") terminal("=") nonterminal("type")$, $$,
  $$, $|$, $terminal("data") [nonterminal("context") terminal("=>")] nonterminal("simpletype") [terminal("=") nonterminal("constrs")] [nonterminal("deriving")]$, $$,
  $$, $|$, $terminal("newtype") [nonterminal("context") terminal("=>")] nonterminal("simpletype") terminal("=") nonterminal("newconstr") [nonterminal("deriving")]$, $$,
  $$, $|$, $terminal("class") [nonterminal("scontext") terminal("=>")] nonterminal("tycls") nonterminal("tyvar") [terminal("where") nonterminal("cdecls")]$, $$,
  $$, $|$, $terminal("instance") [nonterminal("scontext") terminal("=>")] nonterminal("qtycls") nonterminal("inst") [terminal("where") nonterminal("idecls")]$, $$,
  $$, $|$, $terminal("default") terminal("(") nonterminal("type")_1 terminal(",") dots terminal(",") nonterminal("type")_n terminal(")")$, $(n >= 0)$,
  $$, $|$, $terminal("foreign") nonterminal("fdecl")$, $$,
  $$, $|$, $nonterminal("decl")$, $$,
  // decls
  $italic("decls")$, $->$, $terminal("{") nonterminal("decl")_1 terminal(";") dots terminal(";") nonterminal("decl")_n terminal("}")$, $(n >= 0)$,
  // decl
  $italic("decl")$, $->$, $nonterminal("gendecl")$, $$,
  $$,$|$, $(nonterminal("funlhs") | nonterminal("pat")) nonterminal("rhs")$,$$,
  // cdecls
  $italic("cdecls")$, $->$, $terminal("{") nonterminal("cdecl")_1 terminal(";") dots terminal(";") nonterminal("cdecl")_n terminal("}")$, $(n >= 0)$,
  // cdecl
  $italic("cdecl")$, $->$, $nonterminal("gendecl")$, $$,
  $$,$|$, $(nonterminal("funlhs") | nonterminal("var")) nonterminal("rhs")$,$$,
  // idecls
  $italic("idecls")$, $->$, $terminal("{") nonterminal("idecl")_1 terminal(";") dots terminal(";") nonterminal("idecl")_n terminal("}")$, $(n >= 0)$,
  // idecl
  $italic("idecl")$, $->$, $(nonterminal("funlhs") | nonterminal("var")) nonterminal("rhs")$, $$,
  $$, $|$, $$, [(empty)],
  // gendecl
  $italic("gendecl")$, $->$, $nonterminal("vars") terminal("::") [nonterminal("context") terminal("=>")] nonterminal("type")$, [(type signature)],
  $$, $|$, $nonterminal("fixity") [nonterminal("integer")] nonterminal("ops")$, [(fixity declaration)],
  $$, $|$, $$, [(empty declaration)],
  // ops
  $italic("ops")$, $->$, $nonterminal("op")_1 terminal(",") dots terminal(",") nonterminal("op")_n$, $(n >= 1)$,
  // vars
  $italic("vars")$, $->$, $nonterminal("var")_1 terminal(",") dots terminal(",") nonterminal("var")_n$, $(n >= 1)$,
  // fixity
  $italic("fixity")$, $->$, $terminal("infixl") | terminal("infixr") | terminal("infix")$, $$,

)

The declarations in the syntactic category $nonterminal("topdecls")$ are only allowed
at the top level of a Haskell module (see @chapter:modules), whereas $nonterminal("decls")$ may be used either at the top level or
in nested scopes (i.e. those within a `let` or `where` construct).

For exposition, we divide the declarations into
three groups: user-defined datatypes, consisting of `type`, `newtype`,
and `data` declarations (@sec:user-defined-datatypes); type classes and
overloading, consisting of `class`, `instance`, and `default` declarations (@sec:type-classes); and nested declarations,
consisting of value bindings, type signatures, and fixity declarations
(@sec:nested).

Haskell has several primitive datatypes that are "hard-wired"
(such as integers and floating-point numbers), but most "built-in"
datatypes are defined with normal Haskell code, using normal `type`
and `data` declarations.
These "built-in" datatypes are described in detail in @sec:standard-haskell-types.

== Overview of Types and Classes

Haskell uses a traditional
Hindley-Milner
polymorphic type system to provide a static type semantics
@hindley69 @damas-milner82, but the type system has been extended with
_type classes_ (or just _classes_) that provide 
a structured way to introduce _overloaded_ functions.

A `class` declaration (@sec:class-decl) introduces a new
_type class_ and the overloaded operations that must be
supported by any type that is an instance of that class.  An
`instance` declaration (@sec:instance-decl) declares that a
type is an _instance_ of a class and includes
the definitions of the overloaded operations---called _class methods_---instantiated on the named type.


For example, suppose we wish to overload the operations `(+)` and
`negate` on types `Int` and `Float`.  We introduce a new
type class called `Num`:
```haskell
  class Num a  where          -- simplified class declaration for Num
    (+)    :: a -> a -> a     -- (Num is defined in the Prelude)
    negate :: a -> a
```
This declaration may be read "a type `a` is an instance of the class
`Num` if there are class methods `(+)` and `negate`, of the
given types, defined on it.""

We may then declare `Int` and `Float` to be instances of this class:
```haskell
  instance Num Int  where     -- simplified instance of Num Int
    x + y       =  addInt x y
    negate x    =  negateInt x
  
  instance Num Float  where   -- simplified instance of Num Float
    x + y       =  addFloat x y
    negate x    =  negateFloat x
```
where `addInt`, `negateInt`, `addFloat`, and `negateFloat` are assumed
in this case to be primitive functions, but in general could be any
user-defined function.  The first declaration above may be read
"`Int` is an instance of the class `Num` as witnessed by these
definitions (i.e.~class methods) for `(+)` and `negate`."

More examples of type classes can be found in
the papers by Jones @jones:cclasses or Wadler and Blott
@wadler:classes. 
The term "type class" was used to describe the original Haskell 1.0
type system; "constructor class" was used to describe an extension to
the original type classes.  There is no longer any reason to use two
different terms: in this report, "type class" includes both the
original Haskell type classes and the constructor classes
introduced by Jones.

=== Kinds

To ensure that they are valid, type expressions are classified
into different _kinds_, which take one of two possible
forms:

- The symbol $ast$ represents the kind of all nullary type constructors.
- If $kappa_1$ and $kappa_2$ are kinds, then $kappa_1 -> kappa_2$
  is the kind of types that take a type of kind $kappa_1$ and return
  a type of kind $kappa_2$.

Kind inference checks the validity of type expressions 
in a similar way that type inference checks the validity of value expressions.  
However, unlike types, kinds are entirely
implicit and are not a visible part of the language.
Kind inference is discussed in @sec:kind-inference.

=== Syntax of Types <sec:type-syntax>

#table(
  columns: 4,
  stroke: none,
  align: (left, center, left, left),
  // type
  $italic("type")$, $->$, $nonterminal("btype") [terminal("->") nonterminal("type")]$, [(function type)],
  // btype
  $italic("btype")$, $->$, $[nonterminal("btype")] nonterminal("atype")$, [(type application)],
  // atype
  $italic("atype")$, $->$, $nonterminal("gtycon")$, $$,
  $$,$|$, $nonterminal("tyvar")$, $$,
  $$,$|$, $terminal("(") nonterminal("type")_1 terminal(",") dots terminal(",") nonterminal("type")_k terminal(")")$, [(tuple type, $k >= 2$)],
  $$,$|$, $terminal("[") nonterminal("type") terminal("]")$, [(list type)],
  $$,$|$, $terminal("(") nonterminal("type") terminal(")")$, [(parenthesized constructor)],
  // gtycon
  $italic("gtycon")$, $->$, $nonterminal("qtycon")$, $$,
  $$,$|$,$terminal("()")$, [(unit type)],
  $$,$|$,$terminal("[]")$, [(list constructor)],
  $$,$|$,$terminal("(->)")$, [(function constructor)],
  $$,$|$,$terminal("(,") {terminal(",")} terminal(")")$, [(tupling constructors)],
)

The syntax for Haskell type expressions is given above.  Just as data values are built using data constructors, type values are built from _type constructors_.
As with data constructors, the names of type constructors start with uppercase letters.
Unlike data constructors, infix type constructors are not allowed (other than `(->)`).

The main forms of type expression are as follows:

1. Type variables, written as identifiers beginning with
   a lowercase letter.  The kind of a variable is determined implicitly
   by the context in which it appears.

2. Type constructors.  Most type constructors are written as an identifier
   beginning with an uppercase letter.  For example:
   - `Char`, `Int`, `Integer`, `Float`, `Double` and `Bool` are
     type constants with kind $ast$.
   - `Maybe` and `IO` are unary type
     constructors, and treated as types with kind $ast -> ast$.
   - The declarations `data T ...` or `newtype T ...` add the type
     constructor `T` to the type vocabulary.  The kind of `T` is determined by
     kind inference.
   Special syntax is provided for certain built-in type constructors:
   - The _trivial type_ is written as `()` and
     has kind $ast$.
     It denotes the "nullary tuple" type, and has exactly one value,
     also written `()` (see @sec:unit-expression and @subsec:basic-trivial).
   - The _function type_ is written as `(->)` and has
     kind $ast -> ast -> ast$.
   - The _list type_  is written as `[]` and has kind $ast -> ast$.
   - The _tuple types_ are written as `(,)`,
     `(,,)`, and so on.
     Their kinds are $ast -> ast -> ast$,$ast -> ast -> ast -> ast$,  and
     so on.
   Use of the `(->)` and `[]` constants is described in more detail below.

3. Type application.  If $t_1$ is a type of kind
   $kappa_1 -> kappa_2$ and $t_2$ is a type of kind $kappa_1$,
   then $t_1 space t_2$ is a type expression of kind $kappa_2$.

4. A _parenthesized type_, having form $(t)$, is identical
      to the type $t$.

For example, the type expression `IO a` can be understood as the application
of a constant, `IO`, to the variable `a`.  Since the `IO` type
constructor has kind 
$ast -> ast$, it follows that both the variable `a` and the whole
expression, `IO a`, must have kind $ast$.
In general, a process of _kind inference_
(see @sec:kind-inference) is needed to determine appropriate kinds for user-defined datatypes, type
synonyms, and classes.

Special syntax is provided to allow certain type expressions to be written
in a more traditional style:

1. A _function type_ has the form $t_1 -> t_2$, which is equivalent to the type
$(->) t_1 t_2$.  Function arrows associate to the right.
For example, `Int -> Int -> Float` means `Int -> (Int -> Float)`.
2. A _tuple type_ has the form $(t_1, dots, t_k)$, where $k >= 2$, which is equivalent to
   the type $(,dots,) t_1 dots t_k$ where there are
   $k-1$ commas between the parenthesis.  It denotes the
   type of $k$-tuples with the first component of type $t_1$, the second
   component of type $t_2$, and so on (see @sec:tuple-expression
   and @subsec:basic-tuples).
3. A _list type_ has the form $[t]$, which is equivalent to the type $[] t$.
   It denotes the type of lists with elements of type $t$ (see @sec:lists and @subsec:basic-lists).


These special syntactic forms always denote the built-in type constructors
for functions, tuples, and lists, regardless of what is in scope.
In a similar way, the prefix type constructors `(->)`, `[]`, `()`, `(,)`, 
and so on, always denote the built-in type constructors; they 
cannot be qualified, nor mentioned in import or export lists (@chapter:modules).
(Hence the special production, "gtycon", above.)

Although the list and tuple types have special syntax, their semantics 
is the same as the equivalent user-defined algebraic data types.

Notice that expressions and types have a consistent syntax.
If $t_i$ is the type of
expression or pattern $e_i$, then the expressions `(\ e1 -> e2)`, `[e1]`, and  `(t1 -> t2)`, `[t1]`, and `(t1, t2)`, respectively.

With one exception (that of the distinguished type variable
in a class declaration (@sec:class-decl)), the
type variables in a Haskell type expression
are all assumed to be universally quantified; there is no explicit
syntax for universal quantification @damas-milner82.
For example, the type expression
`a -> a` denotes the type $forall a. a -> a$.
For clarity, however, we often write quantification explicitly
when discussing the types of Haskell programs.  When we write an
explicitly quantified type, the scope of the $forall$ extends as far
to the right as possible; for example, $forall a. a -> a$ means
$forall a. (a -> a)$.

=== Syntax of Class Assertions and Contexts <sec:classes-contexts>

#table(
  columns: 4,
  stroke: none,
  align: (left, center, left, left),
  // context
  $italic("context")$, $->$, $nonterminal("class")$, $$,
  $$,$|$,$terminal("(") nonterminal("class")_1 terminal(",") dots terminal(",") nonterminal("class")_n terminal(")")$,$(n >= 0)$,
  // class
  $italic("class")$, $->$, $nonterminal("qtycls") nonterminal("tyvar")$, $$,
  $$,$|$,$nonterminal("qtycls") terminal("(") nonterminal("tyvar") nonterminal("atype")_1 dots nonterminal("atype")_n terminal(")")$,$(n >= 1)$,
  // qtycls
  $italic("qtycls")$, $->$, $[nonterminal("modid") terminal(".")] nonterminal("tycls")$,$$,
  // tycls
  $italic("tycls")$, $->$, $nonterminal("conid")$,$$,
  // tyvar
  $italic("tyvar")$, $->$, $nonterminal("varid")$,$$,

)

A _class assertion_ has form $italic("qtycls") italic("tyvar")$, and
indicates the membership of the type $italic("tyvar")$ in the class
$italic("qtycls")$.
A class identifier begins with an uppercase letter.
A _context_ consists of zero or more class assertions,
and has the general form
$
  (C_1 u_1, dots, C_n u_n)
$
where $C_1, dots, C_n$ are class identifiers, and each of the $u_1, dots, u_n$ is
either a type variable, or the application of type variable to one or more types.
The outer parentheses may be omitted when $n=1$.
In general, we use $italic("cx")$ to denote a context and we write $italic("cx") mono("=>") t$ to
indicate the type $t$ restricted by the context $italic("cx")$.
The context $italic("cx")$ must only contain type variables referenced in $t$.
For convenience,
we write $italic("cx") mono("=>") t$ even if the context $italic("cx")$ is empty, although in this
case the concrete syntax contains no `=>`.

=== Semantics of Types and Classes <sec:type-semantics>

In this section, we provide informal details of the type system.
(Wadler and Blott @wadler:classes and Jones
@jones:cclasses discuss type
and constructor classes, respectively, in more detail.)

The Haskell type system attributes a _type_ to each
expression in the program.  In general, a type is of the form
$forall safeoverline(u). italic("cx") => t$,
where $safeoverline(u)$ is a set of type variables $u_1, dots, u_n$.
In any such type, any of the universally-quantified type variables $u_i$
that are free in $italic("cx")$ must also be free in $t$.
Furthermore, the context $italic("cx")$ must be of the form given above in
@sec:classes-contexts.  For example, here are some
valid types:
```haskell
  Eq a => a -> a
  (Eq a, Show a, Eq b) => [a] -> [b] -> String
  (Eq (f a), Functor f) => (a -> b) -> f a -> f b -> Bool
```
In the third type, the constraint `Eq (f a)` cannot be made
simpler because `f` is universally quantified.

The type of an expression $e$ depends 
on a _type environment_ that gives types 
for the free variables in $e$, and a
_class environment_ that 
declares which types are instances of which classes (a type becomes
an instance of a class only via the presence of an
`instance` declaration or a `deriving` clause).

Types are related by a generalization preorder
(specified below);
the most general type, up to the equivalence induced by the generalization preorder,
that can be assigned to a particular
expression (in a given environment) is called its _
principal type_.
Haskell's extended Hindley-Milner type system can infer the principal
type of all expressions, including the proper use of overloaded
class methods (although certain ambiguous overloadings could arise, as
described in @sec:default-decls).  Therefore, explicit typings (called
_type signatures_)
are usually optional (see @sec:expression-type-sigs and @sec:type-signatures).

The type $forall safeoverline(u).italic("cx")_1 => t_1$ _more general than_ the 
type $forall safeoverline(w). italic("cx")_2 => t_2$ if and only if there is 
a substitution $S$ whose domain is $safeoverline(u)$ such that:

- $t_2$ is identical to $S(t_1)$.
- Whenever $italic("cx")_2$ holds in the class environment, $S(italic("cx")_1)$ also holds.

A value of type $forall safeoverline(u).italic("cx") => t$,
may be instantiated at types $safeoverline(s)$ if and only if
the context $italic("cx")[safeoverline(s)/safeoverline(u)]$ holds.
For example, consider the function `double`:
```haskell
double x = x + x
```
The most general type of `double` is $forall a. mono("Num") a => a -> a$.
`double` may be applied to values of type `Int` (instantiating $a$ to
`Int`), since `Num Int` holds, because `Int` is an instance of the class `Num`.
However, `double` may not normally be applied to values
of type `Char`, because `Char` is not normally an instance of class `Num`.
The user may choose to declare such an instance, in which case `double` may indeed be applied to a `Char`.

== User-Defined Datatypes <sec:user-defined-datatypes>

In this section, we describe algebraic datatypes (`data`
declarations), renamed datatypes (`newtype` declarations), and type
synonyms (`type` declarations).  These declarations may only appear at
the top level of a module.

=== Algebraic Datatype Declarations <sec:datatype-decls>

#table(
  columns: 4,
  align: (left, center, left, left),
  stroke: none,
  // topdecl
  $italic("topdecl")$, $->$, $terminal("data") [nonterminal("context") terminal("=>")] nonterminal("simpletype") [terminal("=") nonterminal("constrs")] [nonterminal("deriving")]$, $$,
  // simpletype
  $italic("simpletype")$, $->$, $nonterminal("tycon") nonterminal("tyvar")_1 dots nonterminal("tyvar")_k$, $(k >= 0)$,
  // constrs
  $italic("constrs")$, $->$, $nonterminal("constr")_1 terminal("|") dots terminal("|") nonterminal("constr")_n$, $(n >= 1)$,
  // constr
  $italic("constr")$, $->$, $nonterminal("con") [terminal("!")] nonterminal("atype")_1 dots [terminal("!")] nonterminal("atype")_k$, [(arity $italic("con") = k$, $k >= 0$)],
  $$,$|$,$(nonterminal("btype") | terminal("!") nonterminal("atype")) nonterminal("conop") (nonterminal("btype") | terminal("!") nonterminal("atype"))$,[(infix $italic("conop")$)],
  $$,$|$,$nonterminal("con") terminal("{") nonterminal("fielddecl")_1 terminal(",") dots terminal(",") nonterminal("fielddecl")_n terminal("}")$,$(n >= 0)$,
  // fielddecl
  $italic("fielddecl")$, $->$, $nonterminal("vars") terminal("::") (nonterminal("type") | terminal("!") nonterminal("atype"))$, $$,
  // deriving
  $italic("deriving")$, $->$, $terminal("deriving") ( nonterminal("dclass") | terminal("(") nonterminal("dclass")_1 terminal(",") dots terminal(",") nonterminal("dclass")_n terminal(")"))$, $(n >= 0)$,
  // dclass
  $italic("dclass")$, $->$, $nonterminal("qtycls")$, $$,
)

The precedence for $italic("constr")$ is the same as that for
expressions---normal constructor application has higher precedence
than infix constructor application (thus `a : Foo a` parses as `a : (Foo a)`).

An algebraic datatype declaration has the form:
$
  mono("data") italic("cx") mono("=>") T u_1 dots u_k = K_1 t_(11) dots t_(1k_1) | dots | K_n t_(n 1) dots t_(n k_n)
$
where $italic("cx")$ is a context.
This declaration
introduces a new _type constructor_ $T$ with zero or more constituent _data constructors_ $K_1, dots K_n$.
In this Report, the unqualified term "constructor" always means "data constructor".

The types of the data constructors are given by:
$
  K_i mono("::") forall u_1 dots u_k. italic("cx")_i => t_(i 1) -> dots -> t_(i k_i) -> (T space u_1 dots u_k)
$
where $italic("cx")_i$ is the largest subset of $italic("cx")$ that constrains only those type variables free in the types $t_(i 1) dots t_(i k_i)$.
The type variables $u_1$ through $u_k$ must be distinct and may appear
in $italic("cx")$ and the $t_(i j)$; it is a static error
for any other type variable to appear in $italic("cx")$ or on the right-hand-side.
The new type constant $T$ has a kind of the form
$kappa_1 -> dots -> kappa_k -> ast$
where the kinds $kappa_i$ of the argument variables $u_i$ are
determined by kind inference
as described in @sec:kind-inference.
This means that $T$ may be used in type expressions with anywhere
between $0$ and $k$ arguments.

For example, the declaration
```haskell
data Eq a => Set a = NilSet | ConsSet a (Set a)
```
introduces a type constructor `Set` of kind $ast -> ast$, and constructors `NilSet` and `ConsSet` with types
#table(
    columns: 3,
    align: (left, center, left),
    stroke: none,
    [`NilSet`], [`::`], $forall a. mono("Set") a$,
    [`ConsSet`], [`::`], $forall a. mono("Eq") a => a -> mono("Set") a -> mono("Set") a$,
)

In the example given, the overloaded
type for `ConsSet` ensures that `ConsSet` can only be applied to values whose
type is an instance of the class `Eq`.
Pattern matching against `ConsSet` also gives rise to an `Eq a` constraint. 
For example: 
```haskell
  f (ConsSet a s) = a
```
the function `f` has inferred type `Eq a => Set a -> a`.
The context in the  `data` declaration has no other effect whatsoever.

The visibility of a datatype's constructors (i.e.~the "abstractness"
of the datatype) outside of the module in which the datatype is
defined is controlled by the form of the datatype's name in the export
list as described in @sec:abstract-types.

The optional `deriving` part of a `data` declaration has to do
with _derived instances_, and is described in @sec:derived-decls.


*Labelled Fields*
A data constructor of arity $k$ creates an object with $k$ components.
These components are normally accessed positionally as arguments to the
constructor in expressions or patterns.  For large datatypes it is
useful to assign _field labels_ to the components of a data object.
This allows a specific field to be referenced independently of its
location within the constructor.

A constructor definition in a `data` declaration may assign labels to the
fields of the constructor, using the record syntax ($C space { space dots space }$).
Constructors using field labels may be freely mixed with constructors
without them. 
A constructor with associated field labels may still be used as an
ordinary constructor; features using labels are
simply a shorthand for operations using an underlying positional
constructor.  The arguments to the positional constructor occur in the
same order as the labeled fields.  For example, the declaration
```haskell
  data C = F { f1,f2 :: Int, f3 :: Bool }
```
defines a type and constructor identical to the one produced by
```haskell
  data C = F Int Int Bool
```
Operations using field labels are described in @sec:field-ops.
A `data` declaration may use the same field label in multiple
constructors as long as the typing of the field is the same in all
cases after type synonym expansion.  A label cannot be shared by
more than one type in scope.  Field names share the top level namespace
with ordinary variables and class methods and must not conflict with
other top level names in scope.

The pattern `F { }` matches any value built with constructor `F`, 
_whether or not `F` was declared with record syntax_.

*Strictness Flags*
Whenever a data constructor is applied, each argument to the
constructor is evaluated if and only if the corresponding type in the
algebraic datatype declaration has a strictness flag, denoted by
an exclamation point, "`!`".
Lexically, "`!`" is an ordinary varsym not a $nonterminal("reservedop")$; 
it has special significance only in the context of the argument types of 
a data declaration.

#translation-box[
  A declaration of the form
  $
    mono("data") italic("cx") => T u_1 dots u_k = dots  | K s_1 dots s_n | dots
  $
  where each $s_i$ is either of the form $! t_i$ or $t_i$, replaces
  every occurrence of $K$ in an expression by
  $
    (mono("\\") x_1 dots x_n mono("->") (((K italic("op")_1 x_1) italic("op")_2 x_2) dots) italic("op")_n x_n)
  $
  where $italic("op")_i$ is the non-strict apply function `$` if $s_i$ is of the form $t_i$,
  and $italic("op")_i$ is the strict apply function `$!` (see
  @sec:strict-eval) if $s_i$ is of the form $! t_i$.
  Pattern matching on $K$ is not affected by strictness flags.
]

=== Type Synonym Declarations <sec:type-synonyms>

#table(
  columns: 4,
  align: (left, center, left, left),
  stroke: none,
  // topdecl
  $italic("topdecl")$, $->$, $terminal("type") nonterminal("simpletype") terminal("=") nonterminal("type")$, $$,
  // simpletype
  $italic("simpletype")$, $->$, $nonterminal("tycon") nonterminal("tyvar")_1 dots nonterminal("tyvar")_k$, $(k >= 0)$,
)

A type synonym declaration introduces a new type that
is equivalent to an old type.  It has the form
$
  mono("type") T u_1 dots u_k = t
$
which introduces a new type constructor, $T$.  The type $(T u_1 dots u_k)$ is equivalent to the type $t [t_1 mono("/") u_1, dots , t_k mono("/") u_k]$.  The type
variables $u_1$ through $u_k$ must be distinct and are scoped only
over $t$; it is a static error for any other type variable to appear
in $t$.  The kind of the new type constructor $T$ is of the form
$kappa_1 -> dots -> kappa_k -> kappa$ where
the kinds $kappa_i$ of the arguments $u_i$ and $kappa$ of the right hand
side $t$ are determined by kind inference as described in
@sec:kind-inference.
For example, the following definition can be used to provide an alternative
way of writing the list type constructor: 
```haskell
type List = []
```
Type constructor symbols $T$ introduced by type synonym declarations cannot
be partially applied; it is a static error to use $T$ without the full number
of arguments.

Although recursive and mutually recursive datatypes are allowed,
this is not so for type synonyms, _unless an algebraic datatype
intervenes_.  For example,
```haskell
  type Rec a   =  [Circ a]
  data Circ a  =  Tag [Rec a]
```
is allowed, whereas
```haskell
  type Rec a   =  [Circ a]        -- invalid
  type Circ a  =  [Rec a]         -- invalid
```
is not. Similarly, `type Rec a = [Rec a]` is not allowed.

Type synonyms are a convenient, but strictly syntactic, mechanism to make type
signatures more readable.  A synonym and its definition are completely
interchangeable, except in the instance type of an `instance` declaration (@sec:instance-decl).

=== Datatype Renamings <sec:datatype-renamings>

#table(
  columns: 4,
  align: (left, center, left, left),
  stroke: none,
  // topdecl
  $italic("topdecl")$, $->$, $terminal("newtype") [nonterminal("context") terminal("=>")] nonterminal("simpletype") terminal("=") nonterminal("newconstr") [nonterminal("deriving")]$, $$,
  // newconstr
  $italic("newconstr")$, $->$, $nonterminal("con") nonterminal("atype")$, $$,
  $$,$|$,$nonterminal("con") terminal("{") nonterminal("var") terminal("::") nonterminal("type") terminal("}")$,$$,
  // simpletype
  $italic("simpletype")$, $->$, $nonterminal("tycon") nonterminal("tyvar")_1 dots nonterminal("tyvar")_k$, $(k >= 0)$,
)

A declaration of the form
$
  mono("newtype") italic("cx") mono("=>") T u_1 dots u_k = N space t
$
introduces a new type whose
representation is the same as an existing type.  The type $(T u_1 dots u_k)$ renames the datatype $t$.
It differs from a type synonym in
that it creates a distinct type that must be explicitly coerced to or
from the original type.  Also, unlike type synonyms, `newtype` may be
used to define recursive types.
The constructor $N$ in an expression 
coerces a value from type `t` to type $(T u_1 dots u_k)$.
Using $N$ in a pattern coerces a value from type $(T u_1 dots u_k)$
to type $t$.  These coercions may be implemented without
execution time overhead; `newtype` does not change the underlying
representation of an object.

New instances (see @sec:instance-decl) can be defined for a
type defined by `newtype` but may not be defined for a type synonym.  A type
created by `newtype` differs from an algebraic datatype in that the
representation of an
algebraic datatype has an extra level of indirection.  This difference
may make access to the representation less efficient.  The difference is
reflected in different rules for pattern matching (see @sec:pattern-matching).  Unlike algebraic datatypes, the
newtype constructor $N$ is _unlifted_, so that $N space bot$
is the same as $bot$.

The following examples clarify the differences between `data` (algebraic
datatypes), `type` (type synonyms), and `newtype` (renaming types.)
Given the declarations 
```haskell
  data D1 = D1 Int
  data D2 = D2 !Int
  type S = Int
  newtype N = N Int
  d1 (D1 i) = 42
  d2 (D2 i) = 42
  s i = 42
  n (N i) = 42
```
the expressions $(mono("d1") space bot)$, $(mono("d2") space bot)$ and 
$(mono("d2") (mono("D2") space bot))$ are all
equivalent to $bot$, whereas $(mono("n") bot)$, $(mono("n") (mono("N") bot))$,
$(mono("d1") (mono("D1") space bot))$ and $(mono("s") bot)$ are all equivalent to `42`.  In particular, $(mono("N") bot)$ is equivalent to
$bot$ while $(mono("D1") space bot)$ is not equivalent to $bot$.

The optional deriving part of a `deriving` declaration is treated in
the same way as the deriving component of a `data` declaration; see
@sec:derived-decls.

A `newtype` declaration may use field-naming syntax, though of course
there may only be one field.  Thus:
```haskell
  newtype Age = Age { unAge :: Int }
```
brings into scope both a constructor and a de-constructor:
```haskell
  Age   :: Int -> Age
  unAge :: Age -> Int
```

== Type Classes and Overloading <sec:type-classes>

=== Class Declarations <sec:class-decl>

#table(
  columns: 4,
  align: (left, center, left, left),
  stroke: none,
  // topdecl
  $italic("topdecl")$, $->$, $terminal("class") [nonterminal("scontext") terminal("=>")] nonterminal("tycls") nonterminal("tyvar") [terminal("where") nonterminal("cdecls")]$, $$,
  // scontext
  $italic("scontext")$, $->$, $nonterminal("simpleclass")$, $$,
  $$,$|$,$terminal("(") nonterminal("simpleclass")_1 terminal(",") dots terminal(",") nonterminal("simpleclass")_n terminal(")")$,$(n >= 0)$,
  // simpleclass
  $italic("simpleclass")$, $->$, $nonterminal("qtycls") nonterminal("tyvar")$, $$,
  // cdecls
  $italic("cdecls")$, $->$, $terminal("{") nonterminal("cdecl")_1 terminal(";") dots terminal(";") nonterminal("cdecl")_n terminal("}")$, $(n >= 0)$,
  // cdecl
  $italic("cdecl")$, $->$, $nonterminal("gendecl")$, $$,
  $$,$|$, $(nonterminal("funlhs") | nonterminal("var")) nonterminal("rhs")$,$$,
)

A _class declaration_ introduces a new class and the operations
(_class methods_) on it.
A class declaration has the general form:
$
  mono("class") italic("cx") mono("=>") C u mono("where") italic("cdecls")
$
This introduces a new class name $C$; the type variable $u$ is
scoped only over the class method signatures in the class body.
The context $italic("cx")$ specifies the superclasses of $C$, as
described below; the only type variable that may be referred to in $italic("cx")$
is $u$.

The superclass relation must not be cyclic; i.e.~it must form a
directed acyclic graph.

The $italic("cdecls")$ part of a `class` declaration contains three kinds
of declarations:

- The class declaration introduces new _class methods_
  $v_i$, whose scope extends outside the `class` declaration.
  The class methods of a class declaration are precisely the \mbox{$\it v_i$} for
  which there is an explicit type signature
  $
    v_i mono("::") italic("cx")_i mono("=>") t_i
  $
  in $italic("cdecls")$.
  Class methods share the top level namespace with variable
  bindings and field names; they must not conflict with other top level
  bindings in scope. 
  That is, a class method can 
  not have the same name as a top level definition, a field name, or
  another class method.

  The type of the top-level class method $v_i$ is:
  $
    v_i mono("::") forall u, safeoverline(w). (C u, italic("cx")_i) mono("=>") t_i
  $
  The $t_i$ must mention $u$; it may mention type variables
  $safeoverline(w)$ other than $u$, in which case the type of $v_i$ is
  polymorphic in both $u$ and $safeoverline(w)$.
  The $italic("cx")_i$ may constrain only $safeoverline(w)$; in particular,
  the $italic("cx")_i$ may not constrain $u$.
  For example:
  ```haskell
  class Foo a where
    op :: Num b => a -> b -> a
  ```
  Here the type of `op` is
  $forall a, b. (mono("Foo") a, mono("Num") b) => a -> b -> a$.
- The $italic("cdecls")$ may also contain a _fixity declaration_ for any of the class methods 
  (but for no other values).
  However, since class methods declare top-level values, the fixity declaration for a class
  method may alternatively appear at top level, outside the class declaration.
- Lastly, the $italic("cdecls")$ may contain a
  _default class method_
  for any of the $v_i$.  The default class method for $v_i$ is used if no binding for it
  is given in a particular `instance` declaration (see
  @sec:instance-decl).
  The default method declaration is a normal value definition, except that the
  left hand side may only be a variable or function definition.  For example:
  ```haskell
  class Foo a where
    op1, op2 :: a -> a
    (op1, op2) = ...
  ```
  is not permitted, because the left hand side of the default declaration is a
  pattern.

Other than these cases, no other declarations are permitted in $italic("cdecls")$.

A `class` declaration with no `where` part
may be useful for combining a
collection of classes into a larger one that inherits all of the
class methods in the original ones.  For example:
```haskell
  class  (Read a, Show a) => Textual a
```
In such a case, if a type is an instance of all
superclasses, it is 
not _automatically_ an instance of the subclass, even though the
subclass has no immediate class methods.  The `instance` declaration must be
given explicitly with no `where` part.

=== Instance Declarations <sec:instance-decl>

#table(
  columns: 4,
  align: (left, center, left, left),
  stroke: none,
  // topdecl
  $italic("topdecl")$, $->$, $terminal("instance") [nonterminal("scontext") terminal("=>")] nonterminal("qtycls") nonterminal("inst") [terminal("where") nonterminal("idecls")]$, $$,
  // inst
  $italic("inst")$, $->$, $nonterminal("gtycon")$, $$,
  $$,$|$,$terminal("(")nonterminal("gtycon") nonterminal("tyvar")_1 dots nonterminal("tyvar")_k terminal(")")$,[($k >= 0$, $italic("tyvars")$ distinct)],
  $$,$|$,$terminal("(") nonterminal("tyvar")_1 terminal(",") dots terminal(",") nonterminal("tyvar")_k terminal(")")$,[($k >= 2$, $italic("tyvars")$ distinct)],
  $$,$|$,$terminal("[") nonterminal("tyvar") terminal("]")$,$$,
  $$,$|$,$terminal("(") nonterminal("tyvar")_1 terminal("->") nonterminal("tyvar")_2 terminal(")")$,[($italic("tyvar")_1$ and $italic("tyvar")_2$ distinct)],
  // idecls
  $italic("idecls")$, $->$, $terminal("{") nonterminal("idecl")_1 terminal(";") dots terminal(";") nonterminal("idecl")_n terminal("}")$, $(n >= 0)$,
  // idecl
  $italic("idecl")$, $->$, $(nonterminal("funlhs") | nonterminal("var")) nonterminal("rhs")$, $$,
  $$, $|$, $$, [(empty)],
)

An _instance declaration_ introduces an instance of a class.  Let
$
  mono("class") italic("cx") mono("=>") C space u mono("where") { italic("cbody") }
$
be a `class` declaration.  The general form of the corresponding
instance declaration is:
$
  mono("instance") italic("cx")' mono("=>") C space (T space u_1 dots u_k) mono("where") { d }
$
where $k >= 0$.
The type $(T u_1 dots u_k)$ must take the form of
a type constructor $T$ applied to simple type variables $u_1, dots, u_k$;
furthermore, $T$ must not be a type synonym, 
and the $u_i$ must all be distinct.

This prohibits instance declarations
such as:
```haskell
  instance C (a,a) where ...
  instance C (Int,a) where ...
  instance C [[a]] where ...
```
The declarations $d$ may contain bindings only for the class
methods of $C$.  It is illegal to give a 
binding for a class method that is not in scope, but the name under
which it is in scope is immaterial; in particular, it may be a qualified
name.  (This rule is identical to that used for subordinate names in
export lists --- @sec:export.)
For example, this is legal, even though `range` is in scope only
with the qualified name `Data.Ix.range`.
```haskell
  module A where
    import qualified Data.Ix

    instance Data.Ix.Ix T where
      range = ...
```
The declarations may not contain any type
signatures or fixity declarations,
since these have already been given in the `class`
declaration.  As in the case of default class methods
(@sec:class-decl), the method declarations must take the form of
a variable or function definition.

If no binding is given for some class method then the
corresponding default class method
in the `class` declaration is used (if
present); if such a default does
not exist then the class method of this instance
is bound to `undefined` and no compile-time error results.

An `instance` declaration that makes the type $T$ to be an instance
of class $C$ is called a _C-T instance declaration_ and is
subject to these static restrictions:

- A type may not be declared as an instance of a
  particular class more than once in the program.

- The class and type must have the same kind; 
  this can be determined using kind inference as described
  in @sec:kind-inference.
- Assume that the type variables in the instance type $(T u_1 dots u_k)$
  satisfy the constraints in the instance context $italic("cx")'$.
  Under this assumption, the following two conditions must also be satisfied:
  1. The constraints expressed by the superclass context $italic("cx")[(T u_1 dots u_k) mono("/")u]$ of $C$ must be satisfied.
     In other words, $T$ must be an instance
     of each of $C$'s superclasses and the contexts of all
     superclass instances must be implied by $italic("cx")'$.
  2. Any constraints on the type variables in the instance type
     that are required for the class method declarations in $d$ to be
     well-typed must also be satisfied.
  In fact, except in pathological cases 
  it is possible to infer from the instance declaration the
  most general instance context $italic("cx")'$ satisfying the above two constraints, 
  but it is nevertheless mandatory
  to write an explicit instance context.

The following example illustrates the restrictions imposed by superclass instances:
```haskell
  class Foo a => Bar a where ...
  
  instance (Eq a, Show a) => Foo [a] where ...
  
  instance Num a => Bar [a] where ...
```
This example is valid Haskell.  Since `Foo` is a superclass of `Bar`,
the second instance declaration is only valid if `[a]` is an
instance of `Foo` under the assumption `Num a`.  
The first instance declaration does indeed say that `[a]` is an instance
of `Foo` under this assumption, because `Eq` and `Show` are superclasses
of `Num`.

If the two instance declarations instead read like this:
```haskell
  instance Num a => Foo [a] where ...
  
  instance (Eq a, Show a) => Bar [a] where ...
```
then the program would be invalid.  The second instance declaration is
valid only if `[a]` is an instance of `Foo` under the assumptions
`(Eq a, Show a)`.  But this does not hold, since `[a]` is only an
instance of `Foo` under the stronger assumption `Num a`.

Further examples of `instance` declarations may be found in @chapter:standard-prelude.

=== Derived Instances <sec:derived-decls>

As mentioned in @sec:datatype-decls, `data` and `newtype`
declarations 
contain an optional `deriving` form.  If the form is included, then
_derived instance declarations_ are automatically generated for
the datatype in each of the named classes.
These instances are subject to the same restrictions as user-defined
instances.  When deriving a class $C$ for a type $T$, instances for
all superclasses of $C$ must exist for $T$, either via an explicit
`instance` declaration or by including the superclass in the
`deriving` clause.

Derived instances provide convenient commonly-used operations for
user-defined datatypes.  For example, derived instances for datatypes
in the class `Eq` define the operations `==` and `/=`, freeing the
programmer from the need to define them.

The only classes in the Prelude for
which derived instances are allowed are
`Eq`, `Ord`, `Enum`, `Bounded`, `Show`,
and `Read`, all mentioned in @fig:standard-classes.
The precise details of how the derived instances are generated for each of
these classes are provided in @chapter:derived-instances, including
a specification of when such derived instances are possible. 
Classes defined by the standard libraries may also be derivable.

A static error results if it is not possible to derive an `instance`
declaration over a class named in a `deriving` form.  For example,
not all datatypes can properly support class methods in
`Enum`. It is 
also a static error to give an explicit `instance` declaration for
a class that is also derived.

If the `deriving` form is omitted from a `data` or `newtype`
declaration, then _no_ instance declarations
are derived for that datatype; that is, omitting a `deriving` form is equivalent to including an empty deriving form: `deriving ()`.

=== Ambiguous Types, and Defaults for Overloaded Numeric Operations <sec:default-decls>

#table(
  columns: 4,
  align: (left, center, left, left),
  stroke: none,
  $italic("topdecl")$, $->$, $terminal("default") terminal("(") nonterminal("type")_1 terminal(",") dots terminal(",") nonterminal("type")_n terminal(")")$, $(n >= 0)$,
)

A problem inherent with Haskell-style overloading is the
possibility of an _ambiguous type_.
For example, using the
`read` and `show` functions defined in @chapter:derived-instances,
and supposing that just `Int` and `Bool` are members of `Read` and
`Show`, then the expression
```haskell
  let x = read "..." in show x  -- invalid
```
is ambiguous, because the types for `show` and `read`,
$
  &mono("show :: ") forall a. mono("Show") a => a -> mono("String")\
  &mono("read :: ") forall a. mono("Read") a => mono("String") -> a
$
could be satisfied by instantiating `a` as either `Int`
in both cases, or `Bool`.  Such expressions
are considered ill-typed, a static error.

We say that an expression `e` has an _ambiguous type_
if, in its type $forall safeoverline(u).italic("cx") => t$, 
there is a type variable $u$ in $safeoverline(u)$ that occurs in $italic("cx")$ 
but not in $t$.  Such types are invalid.

For example, the earlier expression involving `show` and `read` has
an ambiguous type since its type is 
$forall a. mono("Show") a, mono("Read") a => mono("String")$.

Ambiguous types can only be circumvented by
input from the user.  One way is through the use of _expression
type-signatures_ as described in @sec:expression-type-sigs.
For example, for the ambiguous expression given earlier, one could
write:
```haskell
  let x = read "..." in show (x::Bool)
```
which disambiguates the type.

Occasionally, an otherwise ambiguous expression needs to be made
the same type as some variable, rather than being given a fixed
type with an expression type-signature.  This is the purpose
of the function `asTypeOf` (@chapter:standard-prelude):
#raw("x `asTypeOf` y") has the value of $x$, but $x$ and $y$ are
forced to have the same type.  For example,
```haskell
  approxSqrt x = encodeFloat 1 (exponent x `div` 2) `asTypeOf` x
```
(See @sec:coercions for a description of `encodeFloat` and `exponent`.)

Ambiguities in the class `Num` are most common, so Haskell
provides another way to resolve them---with a _default declaration_:
$
  mono("default") (t_1 , dots , t_n)
$
where $n >= 0$, and each
$t_i$ must be a type for which $mono("Num") t_i$ holds.
In situations where an ambiguous type is discovered, an ambiguous type variable, $v$, is defaultable if:

- $v$ appears only in constraints of the form $C space v$, where $C$ is a class, and
- at least one of these classes is a numeric class,
  (that is, `Num` or a subclass of `Num`), and 
- all of these classes are defined in the Prelude or a standard library
  (@fig:basic-numeric-1 -- @fig:basic-numeric-2
  show the numeric classes, and
  @fig:standard-classes shows the classes defined in the Prelude.)

Each defaultable variable is replaced by the first type in the
default list that is an instance of all the ambiguous variable's classes.
It is a static error if no such type is found.

Only one default declaration is permitted per module, and its effect
is limited to that module.  If no default declaration is given in a
module then it assumed to be:
```haskell
  default (Integer, Double)
```
The empty default declaration, `default ()`, turns off all defaults in a module.

== Nested Declarations <sec:nested>

The following declarations may be used in any declaration list,
including the top level of a module.

=== Type Signatures <sec:type-signatures>

#table(
  columns: 4,
  align: (left, center, left, left),
  stroke: none,
  // gendecl
  $italic("gendecl")$, $->$, $nonterminal("vars") terminal("::") [nonterminal("context") terminal("=>")] nonterminal("type")$,[],
  // vars
  $italic("vars")$, $->$, $nonterminal("var")_1 terminal(",") dots terminal(",") nonterminal("var")_n$, $(n >= 1)$,
)

A type signature specifies types for variables, possibly with respect
to a context.  A type signature has the form:
$
  v_1, dots, v_n mono("::") italic("cx") mono("=>") t
$
which is equivalent to asserting
$v_i mono("::") italic("cx") mono("=>") t$
for each $i$ from $1$ to $n$.  Each $v_i$ must have a value binding in
the same declaration list that contains the type signature; i.e. it is
invalid to give a type signature for a variable bound in an
outer scope.
Moreover, it is invalid to give more than one type signature for one
variable, even if the signatures are identical.

As mentioned in @sec:type-syntax,
every type variable appearing in a signature
is universally quantified over that signature, and hence
the scope of a type variable is limited to the type
signature that contains it.  For example, in the following
declarations
```haskell
f :: a -> a
f x = x :: a                  -- invalid
```
the `a`'s in the two type signatures are quite distinct.
Indeed, these declarations contain a static error, since `x` does not have
type $forall a.a$.  (The type of `x` is dependent on the type of
`f`; there is currently no way in Haskell to specify a signature
for a variable with a dependent type; this is explained in @sec:monomorphism.)

If a given program includes a signature
for a variable $f$, then each use of $f$ is treated as having the
declared type.  It is a static error if the same type cannot also be
inferred for the defining occurrence of $f$.

If a variable $f$ is defined without providing a corresponding type
signature declaration, then each use of $f$ outside its own declaration
group (see @sec:dependencyanalysis) is treated as having the
corresponding inferred, or _principal_ type.
However, to ensure that type inference is still possible, the defining
occurrence, and all uses of $f$ within its declaration group must have
the same monomorphic type (from which the principal type is obtained
by generalization, as described in @sec:generalization).

For example, if we define
```haskell
sqr x  =  x*x
```
then the principal type is 
$mono("sqr") mono("::") forall a. mono("Num") a => a -> a$, 
which allows
applications such as `sqr 5` or `sqr 0.1`.  It is also valid to declare
a more specific type, such as
```haskell
sqr :: Int -> Int
```
but now applications such as `sqr 0.1` are invalid.  Type signatures such as
```haskell
sqr :: (Num a, Num b) => a -> b     -- invalid
sqr :: a -> a                       -- invalid
```
are invalid, as they are more general than the principal type of `sqr`.

Type signatures can also be used to support
_polymorphic recursion_.
The following definition is pathological, but illustrates how a type
signature can be used to specify a type more general than the one that
would be inferred:
```
data T a  =  K (T Int) (T a)
f         :: T a -> a
f (K x y) =  if f x == 1 then f y else undefined
```
If we remove the signature declaration, the type of `f` will be
inferred as `T Int -> Int` due to the first recursive call for which
the argument to `f` is `T Int`.  Polymorphic recursion allows the user
to supply the more general type signature, `T a -> a`.

=== Fixity Declarations <sec:fixity-declarations>

#table(
  columns: 4,
  align: (left, center, left, left),
  stroke: none,
  // gendecl
  $italic("gendecl")$, $->$, $nonterminal("fixity") [nonterminal("integer")] nonterminal("ops")$, [],
  // fixity
  $italic("fixity")$, $->$, $terminal("infixl") | terminal("infixr") | terminal("infix")$, $$,
  // ops
  $italic("ops")$, $->$, $nonterminal("op")_1 terminal(",") dots terminal(",") nonterminal("op")_n$, $(n >= 1)$,
  // op
  $italic("op")$,$->$,$nonterminal("varop") | nonterminal("conop")$,[],
  
)

A fixity declaration gives the fixity and binding
precedence of one or more operators.  The $italic("integer")$ in a fixity declaration
must be in the range $0$ to $9$.
A fixity declaration may appear anywhere that 
a type signature appears and, like a type signature, declares a property of
a particular operator.  Also like a type signature,
a fixity declaration can only occur in the same sequence of declarations as
the declaration of the operator itself, and at most one fixity declaration
may be given for any operator.  (Class methods are a minor exception;
their fixity declarations can occur either in the class declaration itself
or at top level.)

There are three kinds of fixity, non-, left- and right-associativity
(`infix`, `infixl`, and `infixr`, respectively), and ten precedence
levels, 0 to 9 inclusive (level 0 binds least tightly, and level 9
binds most tightly).  If the $italic("digit")$ is omitted, level 9 is assumed.
Any operator lacking a fixity declaration
is assumed to be `infixl 9` (See @chapter:expressions for more on
the use of fixities).
@fig:prelude-fixities lists the fixities and precedences of
the operators defined in the Prelude.

#figure(
  caption: "Precedences and fixities of prelude operators",
)[
  #table(
    columns: 4,
    align: (right, left, left, left),
    table.header([Precedence],[Left associative operators],[Non-associative operators],[Right associative operators]),
    [9],[`!!`],[],[`.`],
    [8],[],[],[`^`,`^^`,`**`],
    [7],[`*`, `/`, `div`, `mod`, `rem`, `quot`],[],[],
    [6],[`+`,`-`],[],[],
    [5],[],[],[`:`,`++`],
    [4],[],[`==`, `/=`, `<`,`<=`, `>`, `>=`, `elem`, `notElem`],[],
    [3],[],[],[`&&`],
    [2],[],[],[`||`],
    [1],[`>>`, `>>=`],[],[],
    [0],[],[],[`$`, `$!`, `seq`],
  )
]<fig:prelude-fixities>

Fixity is a property of a particular entity (constructor or variable), just like
its type; fixity is not a property of that entity's _name_.
For example: 
```haskell
  module Bar( op ) where
    infixr 7 `op`
    op = ...
  
  module Foo where
    import qualified Bar
    infix 3 `op`
  
    a `op` b = (a `Bar.op` b) + 1
  
    f x = let
             p `op` q = (p `Foo.op` q) * 2
          in ...
```
Here, #raw("`Bar.op`") is `infixr 7`, #raw("`Foo.op`") is `infix 3`, and
the nested definition of `op` in `f`'s right-hand side has the
default fixity of `infixl 9`.  (It would also be possible
to give a fixity to the nested definition of #raw("`op`") with a nested
fixity declaration.)

=== Function and Pattern Bindings <subsec:function-and-pattern-bindings>

#table(
  columns: 4,
  align: (left, center, left, left),
  stroke: none,
  // decl
  $italic("decl")$, $->$, $(nonterminal("funlhs") | nonterminal("pat")) nonterminal("rhs")$,$$,
  // funlhs
  $italic("funlhs")$, $->$, $nonterminal("var") nonterminal("apat") { nonterminal("apat") }$, $$,
  $$,$|$,$nonterminal("pat") nonterminal("varop") nonterminal("pat")$,$$,
  $$,$|$,$terminal("(") nonterminal("funlhs") terminal(")") nonterminal("apat") { nonterminal("apat")}$,$$,
  // rhs
  $italic("rhs")$, $->$, $terminal("=") nonterminal("exp") [terminal("where") nonterminal("decls")]$, $$,
  $$,$|$,$nonterminal("gdrhs") [terminal("where") nonterminal("decls")]$,$$,
  // gdrhs
  $italic("gdrhs")$, $->$, $nonterminal("guards") terminal("=") nonterminal("exp") [nonterminal("gdrhs")]$, $$,
  // guards
  $italic("guards")$, $->$, $terminal("|") nonterminal("guard")_1 terminal(",") dots terminal(",") nonterminal("guard")_n$, $(n >= 1)$,
  // guard
  $italic("guard")$, $->$, $nonterminal("pat") terminal("<-") nonterminal("infixexp")$, [(pattern guard)],
  $$,$|$,$terminal("let") nonterminal("decls")$,[(local declaration)],
  $$,$|$,$nonterminal("infixexp")$,[(boolean guard)],
)

We distinguish two cases within this syntax: a _pattern binding_
occurs when the left hand side is a $nonterminal("pat")$; 
otherwise, the binding is called a _function
binding_.  Either binding may appear at the top-level of a module or
within a `where` or `let` construct.  

==== Function bindings

A function binding binds a variable to a function value.  The general
form of a function binding for variable $x$ is:
#table(
  columns: 3,
  align: (left, left, left),
  stroke: none,
  $x$, $p_(11) space dots space p_(1 k)$, $italic("match")_1$,
  $dots$,$$,$$,
  $x$, $p_(n 1) space dots space p_(n k)$, $italic("match")_n$
)

where each $p_(i j)$ is a pattern, and where each $italic("match")_i$ is of the general form:
$
  = e_i mono("where") { space italic("decls")_i space }
$
or

#table(
  columns: 2,
  align: (left, left),
  stroke: none,
  $| italic("gs")_(i 1)$, $= e_(i 1)$,
  $dots$, $$,
  $| italic("gs")_(i m_i)$, $= e_(i m_i)$,
  $$, $mono("where") { space italic("decls")_i space }$
)

and where $n >= 1$, $1 <= i <= n$, $m_i >= 1$.  The former is treated
as shorthand for a particular case of the latter, namely:
$
  | mono("True") = e_i mono("where") { space italic("decls")_i space }
$

Note that all clauses defining a function must be contiguous, and the
number of patterns in each clause must be the same.  The set of
patterns corresponding to each match must be _linear_---no variable is
allowed to appear more than once in the entire set.

Alternative syntax is provided for binding functional values to infix
operators.  For example, these three function
definitions are all equivalent:
```haskell
plus x y z = x+y+z
x `plus` y = \ z -> x+y+z
(x `plus` y) z = x+y+z
```

Note that fixity resolution applies to the infix variants of the
function binding in the same way as for expressions
(@sec:fixity-resolution).  Applying fixity resolution to the
left side of the equals in a function binding must leave the $italic("varop")$ being defined at the top level.  For example, if we are defining a new
operator `##` with precedence 6, then this definition would be
illegal:
```haskell
  a ## b : xs = exp
```
because `:` has precedence 5, so the left hand side resolves to `(a ## x) : xs`, and this cannot be a pattern binding because `(a ## x)`
is not a valid pattern.

#translation-box[
  The general binding form for functions is semantically
  equivalent to the equation (i.e. simple pattern binding):
  #table(
    columns: 2,
    align: (right, left),
    stroke: none,
    $x = mono("\\") x_1 dots x_k mono("-> case") (x_1, dots, x_k) mono("of")$, $(p_(11), dots, p_(1 k)) space italic("match")_1$,
    $$, $dots$,
    $$, $(p_(n 1), dots, p_(n k)) space italic("match")_n$,
  )

  where the $x_i$ are new identifiers.
]

==== Pattern bindings <sec:pattern-bindings>

A pattern binding binds variables to values.  A _simple_ pattern
binding has form $p = e$.
The pattern $p$ is
matched "lazily" as an irrefutable pattern, as if there were an implicit `~` in front 
of it.  See the translation in
Section @sec:let-expressions.

The _general_ form of a pattern binding is $p italic("match")$, where a
$italic("match")$ is the same structure as for function bindings above; in other
words, a pattern binding is:

#table(
  columns: 2,
  stroke: none,
  align: (right, left),
  $p$, $| italic("gs")_1 = e_1$,
  $$, $| italic("gs")_2 = e_2$,
  $$, $dots$,
  $$, $| italic("gs")_m = e_m$,
  $$, $mono("where") { space italic("decls") space }$
)


#translation-box[
  The pattern binding above is semantically equivalent to this simple pattern binding:
  #table(
    columns: 2,
    align: (right, left),
    stroke: none,
    $p space =$, $mono("let") italic("decls") mono("in")$,
    $$, $mono("case") () mono("of")$,
    $$, $quad () | italic("gs")_1 -> e_1$,
    $$, $quad quad | italic("gs")_2 -> e_2 $,
    $$, $quad quad quad dots$,
    $$, $quad quad | italic("gs")_m -> e_m$,
    $$, $mono("_") -> mono("error \"Unmatched pattern\"")$
  )
]


== Static Semantics of Function and Pattern Bindings

The static semantics of the function and pattern bindings of a `let` expression or `where` clause are discussed in this section.

=== Dependency Analysis <sec:dependencyanalysis>

In general the static semantics are given by applying the
normal Hindley-Milner inference
rules.  In order to increase polymorphism, these rules are applied to
groups of bindings identified by a _dependency analysis_.


A binding $b 1$ _depends_ on a binding $b 2$ in the same list of declarations if either

1. $b 1$ contains a free identifier that has no type signature and is bound by $b 2$, or
2. $b 1$ depends on a binding that depends on $b 2$.


A _declaration group_ is a minimal set of mutually dependent bindings.
Hindley-Milner type inference is applied to each declaration group in dependency order.
The order of declarations in `where`/`let`
constructs is irrelevant.

=== Generalization <sec:generalization>

The Hindley-Milner type system assigns types to a let-expression in two stages:


1. The declaration groups are considered in dependency order. For
   each group, a type with no universal quantification is inferred for
   each variable bound in the group. Then, all type variables that occur
   in these types are universally quantified unless they are associated
   with bound variables in the type environment; this is called
   generalization.
2. Finally, the body of the let-expression is typed.

For example, consider the declaration
```haskell
  f x = let g y = (y,y)
        in ...
```
The type of `g`'s definition is $a -> (a,a)$.
The generalization step
attributes to `g` the polymorphic type 
$forall a. a -> (a,a)$,
after which the typing of the "`...`" part can proceed.

When typing overloaded definitions, all the overloading 
constraints from a single declaration group are collected together, 
to form the context for the type of each variable declared in the group.
For example, in the definition:
```haskell
  f x = let g1 x y = if x>y then show x else g2 y x
            g2 p q = g1 q p
        in ...
```
The types of the definitions of `g1` and `g2` are both
$a -> a -> mono("String")$, and the accumulated constraints are
$mono("Ord") a$ (arising from the use of `>`), and $mono("Show") a$ (arising from the
use of `show`).
The type variables appearing in this collection of constraints are
called the _constrained type variables_.

The generalization step attributes to both `g1` and `g2` the type
$
  forall a. (mono("Ord") a, mono("Show") a) => a -> a -> mono("String")
$
Notice that `g2` is overloaded in the same way as `g1` even though the
occurrences of `>` and `show` are in the definition of `g1`.

If the programmer supplies explicit type signatures for more than one variable
in a declaration group, the contexts of these signatures must be 
identical up to renaming of the type variables.


=== Context Reduction Errors

As mentioned in @sec:type-semantics, the context of a type
may constrain only a type variable, or the application of a type variable
to one or more types.  Hence, types produced by
generalization must be expressed in a form in which all context
constraints have be reduced to this "head normal form".
Consider, for example, the
definition:
```haskell
  f xs y  =  xs == [y]
```
Its type is given by
```haskell
  f :: Eq a => [a] -> a -> Bool
```
and not
```haskell
  f :: Eq [a] => [a] -> a -> Bool
```
Even though the equality is taken at the list type, the context must
be simplified, using the instance declaration for `Eq` on lists, before generalization.  If no such instance is in scope, a static error occurs.

Here is an example that shows the need for a
constraint of the form $C (m space t)$ where m is one of the type
variables being generalized; that is, where the class $C$ applies to a type
expression that is not a type variable or a type constructor.
Consider:
```haskell
  f :: (Monad m, Eq (m a)) => a -> m a -> Bool
  f x y = return x == y
```
The type of `return` is  `Monad m => a -> m a`; the type of `(==)` is `Eq a => a -> a -> Bool`.
The type of `f` should be
therefore `(Monad m, Eq (m a)) => a -> m a -> Bool`, and the context
cannot be simplified further.

The instance declaration derived from a data type `deriving` clause
(see @sec:derived-decls)
must, like any instance declaration, have a _simple_ context; that is,
all the constraints must be of the form $C space a$, where $a$ is a type variable.
For example, in the type
```haskell
  data Apply a b = App (a b)  deriving Show
```
the derived Show instance will produce a context `Show (a b)`, which
cannot be reduced and is not simple; thus a static error results.


=== Monomorphism <sec:monomorphism>

Sometimes it is not possible to generalize over all the type variables
used in the type of the definition.
For example, consider the declaration
```haskell
  f x = let g y z = ([x,y], z)
        in ...
```
In an environment where `x` has type $a$,
the type of `g`'s definition is $a -> b -> ([a],b)$.
The generalization step attributes to \mbox{\tt g} the type $forall b. a -> b -> ([a], b)$;
only $b$ can be universally quantified because $a$ occurs in the
type environment.
We say that the type of `g` is _monomorphic in the type variable $a$_.

The effect of such monomorphism is that the first argument of all 
applications of `g` must be of a single type.  
For example, it would be valid for
the "`...`" to be
```haskell
  (g True, g False)
```
(which would, incidentally, force `x` to have type `Bool`) but invalid
for it to be 
```haskell
  (g True, g 'c')
```
In general, a type $forall safeoverline(u).italic("cx") => t$
is said to be _monomorphic_
in the type variable $a$ if $a$ is free in
$forall safeoverline(u).italic("cx") => t$.

It is worth noting that the explicit type signatures provided by Haskell
are not powerful enough to express types that include monomorphic type
variables.  For example, we cannot write
```haskell
  f x = let 
          g :: a -> b -> ([a],b)
          g y z = ([x,y], z)
        in ...
```
because that would claim that `g` was polymorphic in both `a` and `b`
(@sec:type-signatures).  In this program, `g` can only be given
a type signature if its first argument is restricted to a type not involving
type variables; for example
```haskell
  g :: Int -> b -> ([Int],b)
```
This signature would also cause `x` to have type `Int`.

=== The Monomorphism Restriction <sec:monomorphism-restriction>

Haskell places certain extra restrictions on the generalization
step, beyond the standard Hindley-Milner restriction described above,
which further reduces polymorphism in particular cases.

The monomorphism restriction depends on the binding syntax of a
variable.  Recall that a variable is bound by either a _function
binding_ or a _pattern binding_, and that a _simple_ pattern
binding is a pattern binding in which the pattern consists of only a
single variable (@subsec:function-and-pattern-bindings).

The following two rules define the monomorphism restriction:

#monomorphism-box([
  / Rule 1.: We say that a given declaration group
    is _unrestricted_ if and only if:
    / (a): every variable in the group is bound by a function binding or a simple
      pattern binding (@sec:pattern-bindings), _and_
    / (b):
      an explicit type signature is given for every variable in the group
      that is bound by simple pattern binding.
    The usual Hindley-Milner restriction on polymorphism is that
    only type variables that do not occur free in the environment may be generalized.
    In addition, _the constrained type variables of
    a restricted declaration group may not be generalized_
    in the generalization step for that group.
    (Recall that a type variable is constrained if it must belong
    to some type class; see @sec:generalization.)
  / Rule 2.: Any monomorphic type variables that remain when type inference for
    an entire module is complete, are considered _ambiguous_,
    and are resolved to particular types using the defaulting 
    rules (@sec:default-decls).
])

*Motivation* Rule 1 is required for two reasons, both of which are fairly subtle.

- _Rule 1 prevents computations from being unexpectedly repeated._
  For example, `genericLength` is a standard function (in library `Data.List`) whose type is given by
  ```haskell
  genericLength :: Num a => [b] -> a
  ```
  Now consider the following expression:
  ```haskell
  let { len = genericLength xs } in (len, len)
  ```
  It looks as if `len` should be computed only once, but without Rule 1 it might
  be computed twice, once at each of two different overloadings.  If the 
  programmer does actually wish the computation to be repeated, an explicit
  type signature may be added:
  ```haskell
  let { len :: Num a => a; len = genericLength xs } in (len, len)
  ```
- _Rule 1 prevents ambiguity._
  For example, consider the declaration group
  ```haskell
  [(n,s)] = reads t
  ```
  Recall that `reads` is a standard function whose type is given by the signature
  ```haskell
  reads :: (Read a) => String -> [(a,String)]
  ```
  Without Rule~1, `n` would be assigned the 
  type $forall a. mono("Read") a => a -> a$ 
  and `s` the type $forall a. mono("Read") a => mono("String")$.
  The latter is an invalid type, because it is inherently ambiguous.
  It is not possible to determine at what overloading to use `s`, nor
  can this be solved by adding a type signature for `s`.
  Hence, when _non-simple_ pattern bindings
  are used (@sec:pattern-bindings), the types inferred are 
  always monomorphic in their constrained type variables, irrespective of whether
  a type signature is provided.
  In this case, both `n` and `s` are monomorphic in $a$.

  The same constraint applies to pattern-bound functions.  For example, in
  ```haskell
  (f,g) = ((+),(-))
  ```
  both `f` and `g` are monomorphic regardless of any type
  signatures supplied for `f` or `g`.

Rule~2 is required because there is no way to enforce monomorphic use
of an _exported_ binding, except by performing type inference on modules
outside the current module.  Rule~2 states that the exact types of all
the variables bound in a module must be determined by that module alone, and not
by any modules that import it.
```haskell
  module M1(len1) where
    default( Int, Double )
    len1 = genericLength "Hello"

  module M2 where
    import M1(len1)
    len2 = (2*len1) :: Rational
```
When type inference on module `M1` is complete, `len1` has the 
monomorphic type `Num a => a` (by Rule 1).  Rule 2 now states that
the monomorphic type variable `a` is ambiguous, and must be resolved using
the defaulting rules of @sec:default-decls.
Hence, `len1` gets type `Int`, and its use in `len2` is type-incorrect.
(If the above code is actually what is wanted, a type signature on
`len1` would solve the problem.)

This issue does not arise for nested bindings, because their entire scope is visible to the compiler.

*Consequences* The monomorphism rule has a number of consequences for the programmer.
Anything defined with function syntax usually
generalizes as a function is expected to.  Thus in
```haskell
  f x y = x+y
```
the function `f` may be used at any overloading in class `Num`.
There is no danger of recomputation here.  However, the same function
defined with pattern syntax:
```haskell
  f = \x -> \y -> x+y
```
requires a type signature if `f` is to be fully overloaded.
Many functions are most naturally defined using simple pattern
bindings; the user must be careful to affix these with type signatures
to retain full overloading.  The standard prelude contains many
examples of this:
```haskell
  sum  :: (Num a) => [a] -> a
  sum  =  foldl (+) 0  
```

Rule~1 applies to both top-level and nested definitions.  Consider
```haskell
  module M where
    len1 = genericLength "Hello"
    len2 = (2*len1) :: Rational
```
Here, type inference finds that `len1` has the monomorphic type (`Num a => a`);
and the type variable `a` is resolved to `Rational` when performing type
inference on `len2`.

== Kind Inference <sec:kind-inference>

This section describes the rules that are used to perform _kind
inference_, i.e. to calculate a suitable kind for each type
constructor and class appearing in a given
program.

The first step in the kind inference process is to arrange the set of
datatype, synonym, and class definitions into dependency groups.  This can
be achieved in much the same way as the dependency analysis for value
declarations that was described in @sec:dependencyanalysis.
For example, the following program fragment includes the definition
of a datatype constructor `D`, a synonym `S` and a class `C`, all of
which would be included in the same dependency group:
```haskell

  data C a => D a = Foo (S a)
  type S a = [D a]
  class C a where
      bar :: a -> D a -> Bool
```
The kinds of variables, constructors, and classes within each group
are determined using standard techniques of type inference and
kind-preserving unification \cite{jones:cclasses}.  For example, in the
definitions above, the parameter `a` appears as an argument of the
function constructor `(->)` in the type of `bar` and hence must
have kind $ast$.  It follows that both `D` and `S` must have
kind $ast -> ast$ and that every instance of class `C` must
have kind $ast$.

It is possible that some parts of an inferred kind may not be fully
determined by the corresponding definitions; in such cases, a default
of $ast$ is assumed.  For example, we could assume an arbitrary kind
$kappa$ for the `a` parameter in each of the following examples:
```haskell
  data App f a = A (f a)
  data Tree a  = Leaf | Fork (Tree a) (Tree a)
```
This would give kinds
$(kappa -> ast) -> kappa -> ast$ and
$kappa -> ast$ for `App` and `Tree`, respectively, for any
kind $kappa$, and would require an extension to allow polymorphic
kinds.  Instead, using the default binding $kappa=ast$, the
actual kinds for these two constructors are
$(ast -> ast) -> ast -> ast$ and
$ast -> ast$, respectively.

Defaults are applied to each dependency group without consideration of
the ways in which particular type constructor constants or classes are
used in later dependency groups or elsewhere in the program.  For example,
adding the following definition to those above does not influence the
kind inferred for `Tree` (by changing it to
$(ast -> ast) -> ast$, for instance), and instead
generates a static error because the kind of `[]`, $ast -> ast$,
does not match the kind $ast$ that is expected for an argument of `Tree`:
```haskell
  type FunnyTree = Tree []     -- invalid
```
This is important because it ensures that each constructor and class are
used consistently with the same kind whenever they are in scope.


