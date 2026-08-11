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

#let report-page(path: none, title: none, toc: false, prev: none, next: none, body) = document(path, title: title)[
  #html.html[
    #html.head[
      #html.meta(charset: "utf-8")
      #html.meta(name: "viewport", content: "width=device-width,  initial-scale=1")
      #html.link(rel: "stylesheet", href: "styles.css")
    ]
    #html.body[
      #draft-banner
      #if not toc {
         [#if prev != none {link(prev)[prev] } #link(<page:toc>)[Contents] #if next != none {link(next)[next]}]
      }
      #html.elem("div", attrs: (class: "main"))[
        #body
      ]
    ]
  ]
]

#show footnote: none

//
// CONTENT
//

#report-page(path: "index.html",
             toc: true,
             title: [Home])[
  #outline()
]<page:toc>

#report-page(path: "preface.html",
             next: label("page:preface-revised"),
             title: [Preface])[
  #heading(level: 1, numbering: none)[Preface]
  #include "other/preface.typ"
]<page:preface>

#report-page(path: "preface-revised.html",
             prev: label("page:preface"),
             next: label("page:introduction"),
             title: [Preface to the Revised Report])[
  #heading(level: 1, numbering: none)[Preface to the Revised Report]
  #include "other/preface_revised.typ"
]<page:preface-revised>

#report-page(path: "introduction.html",
             prev: label("page:preface-revised"),
             next: label("page:lexical-structure"),
             title: [Introduction])[
  = Introduction <chapter:intro>
  #include "chapters/01-intro.typ"
]<page:introduction>

#report-page(path: "lexical-structure.html",
             prev: label("page:introduction"),
             next: label("page:expressions"),
             title: [Lexical Structure])[
  = Lexical Structure <chapter:lexical-structure>
  #include "chapters/02-lexical-structure.typ"
]<page:lexical-structure>

#report-page(path: "expressions.html",
             prev: label("page:lexical-structure"),
             next: label("page:declarations"),
             title: [Expressions])[
  = Expressions <chapter:expressions>
  #include "chapters/03-expressions.typ"
]<page:expressions>

#report-page(path: "declarations.html",
             prev: label("page:expressions"),
             next: label("page:modules"),
             title: [Declarations])[
  = Declarations and Bindings <chapter:declarations>
  #include "chapters/04-declarations.typ"
]<page:declarations>

#report-page(path: "modules.html",
             prev: label("page:declarations"),
             next: label("page:predefined-types"),
             title: [Modules])[
  = Modules <chapter:modules>
  #include "chapters/05-modules.typ"
]<page:modules>

#report-page(path: "predefined-types.html",
             prev: label("page:modules"),
             next: label("page:basic-input-output"),
             title: [Predefined Types])[
  = Predefined Types and Classes <chapter:predefined-types>
  #include "chapters/06-predefined-types.typ"
]<page:predefined-types>

#report-page(path: "basic-io.html",
             prev: label("page:predefined-types"),
             next: label("page:ffi"),
             title: [Basic Input/Output])[
  = Basic Input/Output <chapter:basic-input-output>
  #include "chapters/07-basic-input-output.typ"
]<page:basic-input-output>

#report-page(path: "ffi.html",
             prev: label("page:basic-input-output"),
             next: label("page:standard-prelude"),
             title: [Foreign Function Interface])[
  = Foreign Function Interface <chapter:ffi>
  #include "chapters/08-ffi.typ"
]<page:ffi>

#report-page(path: "prelude.html",
             prev: label("page:ffi"),
             next: label("page:syntax-reference"),
             title: [Standard Prelude])[
  = Standard Prelude <chapter:standard-prelude>
  #include "chapters/09-standard-prelude.typ"
]<page:standard-prelude>

#report-page(path: "syntax-reference.html",
             prev: label("page:standard-prelude"),
             next: label("page:derived-instances"),
             title: [Syntax Reference])[
  = Syntax Reference <chapter:syntax-reference>
  #include "chapters/10-syntax-reference.typ"
]<page:syntax-reference>

#report-page(path: "derived-instances.html",
             prev: label("page:syntax-reference"),
             next: label("page:compiler-pragmas"),
             title: [Derived Instances])[
  = Specification of Derived Instances <chapter:derived-instances>
  #include "chapters/11-derived-instances.typ"
]<page:derived-instances>

#report-page(path: "pragmas.html",
             prev: label("page:derived-instances"),
             next: label("page:bibliography"),
             title: [Compiler Pragmas])[
  = Compiler Pragmas <chapter:compiler-pragmas>
  #include "chapters/12-compiler-pragmas.typ"
]<page:compiler-pragmas>

#report-page(path: "bibliography.html",
             prev: label("page:compiler-pragmas"),
             title: [Bibliography])[
  #bibliography("bibliography.bib")
]<page:bibliography>

// Copy the file `styles.css` into the bundle.
#asset("styles.css", read("styles.css"))