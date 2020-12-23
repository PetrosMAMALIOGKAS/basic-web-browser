:: Tapez "compile.bat" pour tout compiler.

:: Remplacez ocamlc par un chemin plus précis (C:\...\ocamlc.exe) si
:: ocamlc n'est pas dans votre PATH.

:: montre les commandes exécutées
@echo on

ocamlc -c -w -3 -o xmlm.cmi xmlm.mli
ocamlc -c -w -3 -o graph_utils.cmi graph_utils.mli
ocamlc -c -w -3 -o html_tree.cmi html_tree.mli
ocamlc -c -w -3 -o draw_html.cmo draw_html.ml
ocamlc -c -w -3 -o navig.cmo navig.ml
ocamlc -c -w -3 -o graph_utils.cmo graph_utils.ml
ocamlc -c -w -3 -o html_tree.cmo html_tree.ml
ocamlc -c -w -3 -o xmlm.cmo xmlm.ml
ocamlc graphics.cma graph_utils.cmo xmlm.cmo html_tree.cmo draw_html.cmo navig.cmo -w -3 -o navig.byte

