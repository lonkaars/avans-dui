#!/bin/awk -f
BEGIN {
	print "\\noindent\\begin{tabularx}{\\linewidth}{llXr}"
	print "\\toprule"
	print "Version & Commit & Notes & Date\\\\"
	print "\\midrule"
}
{
	sub("doc-", "", $1)
	print $1" & \\texttt{"$2"} & "$3" & \\DTMdisplaydate"strftime("{%Y}{%m}{%d}{-1}", $4)"\\\\"
}
END {
	print "\\bottomrule"
	print "\\end{tabularx}"
}
