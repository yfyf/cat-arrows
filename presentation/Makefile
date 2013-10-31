MAINFILE = presentation

all: ${MAINFILE}.pdf

SOURCES  = ${MAINFILE}.tex $(wildcard chapters/*.tex)

presentation.pdf: ${SOURCES}
	pdflatex ${MAINFILE}
