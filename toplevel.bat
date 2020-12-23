:: Si vous avez compilé avec compil.bat, alors -I . suffit
:: si vous avez compilé avec make (qui utilise ocamlbuild) alors -I _build
ocaml -I . -I _build -init utils\init.ml
