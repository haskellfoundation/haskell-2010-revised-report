.PHONY: latex
latex:
	haddock --latex -o latex --optghc=-XNoImplicitPrelude --optghc=-XHaskell2010 $$(find src/ -name '*.hs')
	cd latex/ && pdflatex main.tex