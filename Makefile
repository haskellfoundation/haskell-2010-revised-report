
#
# Target for generating the PDF report
#
pdf:

#
# Target for generating the HTML report
#
html:

#
# Targets for development
#
watch-pdf:
watch-html:

#
# Makefile implementation
#

GRAPHS=images/numeric-classes.svg images/functor-monad-classes.svg

DEPENDENCY=bibliography.bib\
 chapters/01-intro.typ\
 chapters/02-lexical-structure.typ\
 chapters/03-expressions.typ\
 chapters/04-declarations.typ\
 chapters/05-modules.typ\
 chapters/06-predefined-types.typ\
 chapters/07-basic-input-output.typ\
 chapters/08-ffi.typ\
 chapters/09-standard-prelude.typ\
 chapters/10-syntax-reference.typ\
 chapters/11-derived-instances.typ\
 chapters/12-compiler-pragmas.typ\
 $(GRAPHS)\
 macros.typ\
 other/preface.typ\
 other/preface_revised.typ\
 other/titlepage.typ

HTML_DEPENDENCY=fonts/raleway-v28-latin-700.woff2\
 fonts/raleway-v28-latin-900.woff2\
 fonts/source-sans-3-v9-latin-regular.woff2\
 fonts/ubuntu-mono-v15-latin-regular.woff2\
 styles.css

.PHONY: pdf
pdf: haskell-2010-revised.pdf

.PHONY: watch-pdf
watch-pdf:
	typst watch haskell-2010-revised.typ

.PHONY: html
html: haskell-2010-revised-html/index.html

.PHONY: watch-html
watch-html:
	typst watch --format bundle --features bundle --features html haskell-2010-revised-html.typ

.PHONY: depend-pdf
haskell-2010-revised.pdf depend-pdf: haskell-2010-revised.typ $(DEPENDENCY)

haskell-2010-revised.pdf: 
	typst compile haskell-2010-revised.typ

.PHONY: depend-html
haskell-2010-revised-html/index.html depend-html: haskell-2010-revised-html.typ $(DEPENDENCY) $(HTML_DEPENDENCY)

haskell-2010-revised-html/index.html: 
	typst compile --format bundle --features bundle --features html haskell-2010-revised-html.typ

$(GRAPHS:%.svg=%-template.svg): images/%-template.svg: images/%.dot
	dot -Tsvg $< -o $@

$(GRAPHS): images/%.svg: images/%-template.svg images/bold.py
	python images/bold.py $< $@
