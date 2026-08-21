PDFREPORT=haskell-2010-revised.typ
HTMLREPORT=haskell-2010-revised-html.typ

#
# Targets for generating the PDF report
#

.PHONY: pdf
pdf:
	typst compile $(PDFREPORT)

.PHONY: watch-pdf
watch-pdf:
	typst watch $(PDFREPORT)

#
# Targets for generating the HTML report
#

.PHONY: html
html:
	typst compile --format bundle --features bundle --features html $(HTMLREPORT)

.PHONY: watch-html
watch-html:
	typst watch --format bundle --features bundle --features html $(HTMLREPORT)