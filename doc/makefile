.PHONY: all clean

all: dui.pdf

dui.pdf: ../assets/architecture-level-0.pdf

%.pdf: %.svg
	rsvg-convert -f pdf -o $@ $<

%.pdf: %.tex base.tex %.md.tex
	latexmk $< -shell-escape -halt-on-error -lualatex -f -g

%.md.tex: %.md
	pandoc -t latex -o $@ $<

clean:
	$(RM) dui.aux dui.bbl dui.bcf dui.blg dui.fdb_latexmk dui.fls dui.log dui.out dui.run.xml dui.synctex.gz dui.toc dui.md.tex dui.pdf

