.PHONY: pdf
pdf:
	typst compile haskell-2010-revised.typ

.PHONY: html
html:
	typst compile --format bundle --features bundle --features html haskell-2010-revised-html.typ