.PHONY: all clean

all: dui.pdf

dui.pdf: ../assets/architecture-level-0.pdf
dui.pdf: ../assets/LSD_straightLines_Pic_0.png
dui.pdf: ../assets/LSD_straightLines_Pic_1.png
dui.pdf: ../assets/hough_straightLines_Pic_0.png
dui.pdf: ../assets/hough_straightLines_Pic_1.png

versionctl.tex:
	git tag -l 'doc-*' --format='%(refname:short)	%(*objectname:short)	%(contents:subject)	%(*authordate:format:%s)' | ./versiontable.awk -F'	' > $@

%.png: %.bmp
	convert $< $@

%.pdf: %.svg
	rsvg-convert -f pdf -o $@ $<

%.pdf: %.tex base.tex %.md.tex versionctl.tex
	latexmk $< -shell-escape -halt-on-error -lualatex -f -g

%.md.tex: %.md
	pandoc -t latex -o $@ $<

clean:
	$(RM) dui.aux dui.bbl dui.bcf dui.blg dui.fdb_latexmk dui.fls dui.log dui.out dui.run.xml dui.synctex.gz dui.toc dui.md.tex dui.pdf
	$(RM) ../assets/LSD_straightLines_Pic_0.png ../assets/LSD_straightLines_Pic_1.png ../assets/hough_straightLines_Pic_0.png ../assets/hough_straightLines_Pic_1.png

