#!/bin/bash
# Tapez "./compile.sh" pour tout compiler.

# Remplacez ocamlc par un chemin plus précis (\...\ocamlc) si ocamlc
# n'est pas dans votre PATH.
# montre les commandes exécutées

OPTIONS='-w d'
#OPTIONS="-w 3"
#OPTIONS="-w -deprecated"
set -o verbose

ocamlc -c $OPTIONS -o graph_utils.cmi graph_utils.mli
ocamlc -c $OPTIONS -o html_tree.cmi html_tree.mli
ocamlc -c $OPTIONS -o draw_html.cmo draw_html.ml
ocamlc -c $OPTIONS -o navig.cmo navig.ml
ocamlc -c $OPTIONS -o xmlm.cmi xmlm.mli
ocamlc -c $OPTIONS -o graph_utils.cmo graph_utils.ml
ocamlc -c $OPTIONS -o html_tree.cmo html_tree.ml
ocamlc -c $OPTIONS -o xmlm.cmo xmlm.ml
ocamlc graphics.cma graph_utils.cmo xmlm.cmo html_tree.cmo draw_html.cmo navig.cmo $OPTIONS -o navig.byte
