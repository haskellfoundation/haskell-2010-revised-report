#set document(
  title: [Haskell 2010 \ Revised Language Report]
)

#set text(
  font: "Source Sans 3"
)
#show raw: set text(font: "Ubuntu Mono")


#set heading(numbering: (..nums) => {
 if nums.pos().len() == 1 {
    numbering("1", ..nums)
  } else if nums.pos().len() == 2 {
    numbering("1.1", ..nums)
  } else {
    numbering("1.1", ..nums)
  }
})


// Chapter Headings
#show heading.where(level: 1): set text(24pt)
#show heading.where(level: 1): set heading(supplement: [Chapter])
#show heading.where(level: 1): it => {
  if it.body == [Preface] or it.body == [Preface to the Revised Report] or it.body == [Contents] or it.body == [Bibliography] {pagebreak(weak: true) + it + v(1cm)}
  else {
    pagebreak(weak: true) + [Chapter #counter(heading).display("1") #v(1cm) #it.body #v(1cm)]
  }
}

// Section Headings
#show heading.where(level: 2): set text(18pt)
#show heading.where(level: 2): it => {
  v(0.6cm) + it + v(0.8cm)
}


#set par(
  justify: true,
)

#show figure: set align(left)

#show title: set align(center)


//
// CONTENT
//

#include "other/titlepage.typ"

#outline()

#pagebreak()

#counter(page).update(1)
#set page(numbering: "1")

#heading(level: 1, numbering: none)[Preface]

#include "other/preface.typ"

#heading(level: 1, numbering: none)[Preface to the Revised Report]

#include "other/preface_revised.typ"


= Introduction <chapter:intro>


#include "chapters/01-intro.typ"

= Lexical Structure <chapter:lexical-structure>

#include "chapters/02-lexical-structure.typ"

= Expressions <chapter:expressions>

#include "chapters/03-expressions.typ"

= Declarations and Bindings <chapter:declarations>

#include "chapters/04-declarations.typ"

= Modules <chapter:modules>

#include "chapters/05-modules.typ"

= Predefined Types and Classes <chapter:predefined-types>

#include "chapters/06-predefined-types.typ"

= Basic Input/Output <chapter:basic-input-output>

#include "chapters/07-basic-input-output.typ"

= Foreign Function Interface <chapter:ffi>

#include "chapters/08-ffi.typ"

= Standard Prelude <chapter:standard-prelude>

#include "chapters/09-standard-prelude.typ"

= Syntax Reference <chapter:syntax-reference>

#include "chapters/10-syntax-reference.typ"

= Specification of Derived Instances <chapter:derived-instances>

#include "chapters/11-derived-instances.typ"

= Compiler Pragmas <chapter:compiler-pragmas>

#include "chapters/12-compiler-pragmas.typ"


#pagebreak()

#bibliography("bibliography.bib")