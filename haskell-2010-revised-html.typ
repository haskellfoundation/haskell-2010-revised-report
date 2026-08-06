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

// Section Headings
#show heading.where(level: 2): set text(18pt)

#set par(
  justify: true,
)

#show figure: set align(left)

#show title: set align(center)

// The PDF report is marked as a draft on its titlepage.
// But the HTML version has no draft mark.
// So, add draft mark at the top of each page instead.
#let draft-banner = html.elem(
  "div",
  attrs: (
    style: "margin-bottom: 2em; padding: 0.5em 1em; border: 2px solid #a00; "
      + "color: #a00; text-align: center;",
  ),
)[
  #html.elem(
    "div",
    attrs: (style: "font-size: 1.5em; font-weight: bold; letter-spacing: 0.2em;"),
  )[DRAFT]
  #html.elem("div", attrs: (style: "font-size: 0.9em;"))[
    This is a work in progress, not an official release of the Haskell 2010
    Revised Language Report.
  ]
]

#let report-page(path, title: none, body) = document(path, title: title)[
  #draft-banner
  #body
]


//
// CONTENT
//


#report-page("index.html", title: [Home])[
  #outline()
]

#report-page("preface.html", title: [Preface])[
  #heading(level: 1, numbering: none)[Preface]
  #include "other/preface.typ"
]

#report-page("preface-revised.html", title: [Preface to the Revised Report])[
  #heading(level: 1, numbering: none)[Preface to the Revised Report]
  #include "other/preface_revised.typ"
]

#report-page("introduction.html", title: [Introduction])[
  = Introduction <chapter:intro>
  #include "chapters/01-intro.typ"
]

#report-page("lexical-structure.html", title: [Lexical Structure])[
  = Lexical Structure <chapter:lexical-structure>
  #include "chapters/02-lexical-structure.typ"
]

#report-page("expressions.html", title: [Expressions])[
  = Expressions <chapter:expressions>
  #include "chapters/03-expressions.typ"
]

#report-page("declarations.html", title: [Declarations])[
  = Declarations and Bindings <chapter:declarations>
  #include "chapters/04-declarations.typ"
]

#report-page("modules.html", title: [Modules])[
  = Modules <chapter:modules>
  #include "chapters/05-modules.typ"
]

#report-page("predefined-types.html", title: [Predefined Types])[
  = Predefined Types and Classes <chapter:predefined-types>
  #include "chapters/06-predefined-types.typ"
]

#report-page("basic-io.html", title: [Basic Input/Output])[
  = Basic Input/Output <chapter:basic-input-output>
  #include "chapters/07-basic-input-output.typ"
]

#report-page("ffi.html", title: [Foreign Function Interface])[
  = Foreign Function Interface <chapter:ffi>
  #include "chapters/08-ffi.typ"
]

#report-page("prelude.html", title: [Standard Prelude])[
  = Standard Prelude <chapter:standard-prelude>
  #include "chapters/09-standard-prelude.typ"
]

#report-page("syntax-reference.html", title: [Syntax Reference])[
  = Syntax Reference <chapter:syntax-reference>
  #include "chapters/10-syntax-reference.typ"
]

#report-page("derived-instances.html", title: [Derived Instances])[
  = Specification of Derived Instances <chapter:derived-instances>
  #include "chapters/11-derived-instances.typ"
]
#report-page("pragmas.html", title: [Compiler Pragmas])[
  = Compiler Pragmas <chapter:compiler-pragmas>
  #include "chapters/12-compiler-pragmas.typ"
]

#report-page("bibliography.html", title: [Bibliography])[
  #bibliography("bibliography.bib")
]

