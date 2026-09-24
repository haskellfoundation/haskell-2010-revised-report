
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
 images/standard-classes.svg\
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

haskell-2010-revised.pdf: haskell-2010-revised.typ $(DEPENDENCY)
	typst compile haskell-2010-revised.typ

haskell-2010-revised-html/index.html: haskell-2010-revised-html.typ $(DEPENDENCY) $(HTML_DEPENDENCY)
	typst compile --format bundle --features bundle --features html haskell-2010-revised-html.typ

images/standard-classes-template.svg: images/standard-classes.dot
	dot -Tsvg images/standard-classes.dot -o images/standard-classes-template.svg

images/standard-classes.svg: images/standard-classes-template.svg images/bold.py
	python images/bold.py images/standard-classes-template.svg images/standard-classes.svg