// TODO somehow make this a global config
// TODO also fix it in HTML which doesn't seem to work with font: at all
#let main_font_name = "Libertinus Serif"
#let mono_font_name = "DejaVu Sans Mono"

/// Typesetting terminal symbols in the grammar
#let terminal(x) = {
  text(fill: eastern, font: mono_font_name)[#x]
}

/// Typesetting nonterminal symbols in the gramma
#let nonterminal(x) = {
  link(label(x))[#text(fill: maroon, style: "italic", font: main_font_name)[#x]]
}

#let varname(x) = {
  text(style: "italic", font: main_font_name)[#x]
}

#let nontermname(x) = varname(x)

#let nonterminaldef(x) = {
  [#text(style: "italic", font: main_font_name)[#x]#raw("")#label(x)]
}

/// A box used in defining the meaning of syntactic entities by translation.
#let translation-box(x) = context{
  if target() == "paged" {
    // Code for PDF output
    box(
      stroke: black,
      width: 1fr,
      inset: 10pt,
      [*Translation:* #x]
    )
  } else {
    // Code for HTML output
    html.elem("div", attrs: (class: "translation-box"))[
      *Translation:* #x
    ]
  }
}

#let monomorphism-box(x) = context {
  if target() == "paged" {
    // Code for PDF output
    box(
      stroke: black,
      width: 1fr,
      inset: 10pt,
      [*The monomorphism restriction*\ #x]
    )
  } else {
    // Code for HTML output
    html.elem("div", attrs: (class: "monomorphism-box"))[
      *The monomorphism restriction*\ #x
    ]
  }
}

#let center-box(body) = context {
  if target() == "paged" {
     // Code for PDF output
     align(center)[#body]
  } else {
    // Code for HTML output
     html.elem("div", attrs: (style: "text-align: center;", class: "center-box"))[#body]
  }
}

// See https://github.com/typst/typst/issues/8509
#let safeoverline(body) = context {
  if target() == "paged" {
    // Code for PDF output
    math.overline(body)
  } else {
    // Code for HTML output
    html.elem("mover", attrs: (accent: "true"))[
      #body
      #html.elem("mo", "_")
    ]
  }
}
