#let main_font_name = "Libertinus Serif"
#let mono_font_name = "DejaVu Sans Mono"

// In HTML output these symbols end up inside MathML, which only renders text
// that sits in a token element, so emit an <mtext> with a class for styling.
#let grammar-symbol(class, x) = html.elem("mtext", attrs: (class: class), x)

/// Typesetting terminal symbols in the grammar
#let terminal(x) = context {
  if target() == "paged" {
    text(fill: eastern, font: mono_font_name)[#x]
  } else {
    grammar-symbol("terminal", x)
  }
}

/// Typesetting tokens in the grammar
#let token(x) = {
  box(stroke: black, inset: 4pt, radius: 3pt)[$mono(#x)$]
}

/// Typesetting nonterminal symbols in the grammar
#let nonterminal(x) = context {
  if target() == "paged" {
    link(label(x))[#text(fill: maroon, style: "italic", font: main_font_name)[#x]]
  } else {
    link(label(x), grammar-symbol("nonterminal", x))
  }
}

#let varname(x) = context {
  if target() == "paged" {
    text(style: "italic", font: main_font_name)[#x]
  } else {
    grammar-symbol("varname", x)
  }
}

#let nontermname(x) = varname(x)

#let nonterminaldef(x) = context {
  if target() == "paged" {
    [#text(style: "italic", font: main_font_name)[#x]#raw("")#label(x)]
  } else {
    [#grammar-symbol("nonterminal", x)#raw("")#label(x)]
  }
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
