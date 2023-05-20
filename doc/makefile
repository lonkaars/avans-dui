.PHONY: all clean

TARGET := $(patsubst %.md,%.pdf, $(wildcard *.md))

all: $(TARGET)

garbage = $1.aux $1.bbl $1.bcf $1.blg $1.fdb_latexmk $1.fls $1.log $1.out $1.run.xml $1.synctex.gz $1.toc $1.md.tex

%.pdf: %.svg
	rsvg-convert -f pdf -o $@ $<

%.pdf: %.tex base.tex %.md.tex
	latexmk $< -shell-escape -halt-on-error -lualatex -f -g

%.md.tex: %.md
	pandoc -t latex -o $@ $<

clean:
	$(RM) $(call garbage,research) research.pdf

