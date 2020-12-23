SHELL=/bin/bash

OCAMLBUILD=ocamlbuild -classic-display
BINNAME=navig
ALLSRCFILES=xmlm.mli xmlm.ml graph_utils.mli graph_utils.ml  html_tree.mli html_tree.ml draw_html.ml navig.ml

# ocamlbuild gère les dépendances et les recompilation, donc on débranche le check des dates pour les cibles.
.PHONY: all clean cleanall navig.byte navig.opt doc doc.docdir/index.html projet-navig.tgz

all:navig.byte


navig.byte: 
	$(OCAMLBUILD) navig.byte

native:navig.native

# -I . is for users of compile.bat
toplevel: navig.byte
	ocaml -I . -I _build -init utils/init.ml


navig.native:
	$(OCAMLBUILD) navig.native

doc: navig.byte doc.docdir/index.html

doc.docdir/index.html: navig.byte
	mkdir -p doc.docdir
	ocamldoc -unsafe-string -w -3 -I _build -html -charset utf-8 -d doc.docdir  docsrc/graphics.mli $(ALLSRCFILES)
#	$(OCAMLBUILD) doc.docdir/index.html

clean:
	$(OCAMLBUILD) -clean

cleanall: clean
	rm -rf projet-*
	rm -rf doc.odocdir



