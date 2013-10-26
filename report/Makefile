PAPER = report

all: ${PAPER}.pdf

TEXFILES = ${PAPER}.tex $(wildcard chapters/*.tex)

SOURCES = ${TEXFILES} $(wildcard *.ltx) literature.bib

${PAPER}.pdf: ${SOURCES}
	pdflatex ${PAPER}
	biber ${PAPER}
	pdflatex ${PAPER}
	pdflatex ${PAPER}
