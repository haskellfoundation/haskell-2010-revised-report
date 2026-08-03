//
// This is the toplevel document for the HTML report
//
#set document(
  title: [Haskell 2010 \ Revised Language Report]
)


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
  if it.body == [Preface] or it.body == [Preface to the Revised Report] or it.body == [Contents] or it.body == [Bibliography] {it}
  else {
    [Chapter #counter(heading).display("1") #it.body]
  }
}

// Section Headings
#show heading.where(level: 2): set text(18pt)

#set par(
  justify: true,
)

#show figure: set align(left)

#show title: set align(center)


//
// CONTENT
//


#document("index.html", title: [Home])[
  #outline()
]

#document("preface.html", title: [Preface])[
  #heading(level: 1, numbering: none)[Preface]
  #include "other/preface.typ"
]

#document("preface-revised.html", title: [Preface to the Revised Report])[
  #heading(level: 1, numbering: none)[Preface to the Revised Report]
  #include "other/preface_revised.typ"
]

#document("introduction.html", title: [Introduction])[
  = Introduction <chapter:intro>
  #include "chapters/01-intro.typ"
]

#document("lexical-structure.html", title: [Lexical Structure])[
  = Lexical Structure <chapter:lexical-structure>
  #include "chapters/02-lexical-structure.typ"
]

#document("expressions.html", title: [Expressions])[
  = Expressions <chapter:expressions>
  #include "chapters/03-expressions.typ"
]

#document("declarations.html", title: [Declarations])[
  = Declarations and Bindings <chapter:declarations>
  #include "chapters/04-declarations.typ"
]

#document("modules.html", title: [Modules])[
  = Modules <chapter:modules>
  #include "chapters/05-modules.typ"
]

#document("predefined-types.html", title: [Predefined Types])[
  = Predefined Types and Classes <chapter:predefined-types>
  #include "chapters/06-predefined-types.typ"
]

#document("basic-io.html", title: [Basic Input/Output])[
  = Basic Input/Output <chapter:basic-input-output>
  #include "chapters/07-basic-input-output.typ"
]

#document("ffi.html", title: [Foreign Function Interface])[
  = Foreign Function Interface <chapter:ffi>
  #include "chapters/08-ffi.typ"
]

#document("prelude.html", title: [Standard Prelude])[
  = Standard Prelude <chapter:standard-prelude>
  #include "chapters/09-standard-prelude.typ"
]

#document("syntax-reference.html", title: [Syntax Reference])[
  = Syntax Reference <chapter:syntax-reference>
  #include "chapters/10-syntax-reference.typ"
]

#document("derived-instances.html", title: [Derived Instances])[
  = Specification of Derived Instances <chapter:derived-instances>
  #include "chapters/11-derived-instances.typ"
]
#document("pragmas.html", title: [Compiler Pragmas])[
  = Compiler Pragmas <chapter:compiler-pragmas>
  #include "chapters/12-compiler-pragmas.typ"
]

#document("bibliography.html", title: [Bibliography])[
  #bibliography("bibliography.bib")
]

