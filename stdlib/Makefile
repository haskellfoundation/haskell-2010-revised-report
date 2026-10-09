TITLE="Haskell 2010 Revised Library Report"
OUTDIR=latex

.PHONY: latex
latex:
	haddock --latex --prologue=prologue.txt --title=$(TITLE) -o $(OUTDIR) --optghc=-XNoImplicitPrelude --optghc=-XHaskell2010 $$(find src/ -name '*.hs')

pdf: latex
	cd latex/ && pdflatex main.tex

.PHONY: clean
clean:
	rm -rf $(OUTDIR)

view: pdf
	open $(OUTDIR)/main.pdf