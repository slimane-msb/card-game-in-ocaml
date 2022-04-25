all: solitaire_defs.cmo solitaire.cmo main.cmo help_solitaire.cmo
	ocamlc -o solitaire.exe solitaire_defs.cmo help_solitaire.cmo solitaire.cmo main.cmo
    
    
solitaire.cmo:  solitaire.ml
	ocamlc -c solitaire.ml

main.cmo:  main.ml solitaire.cmo
	ocamlc -c main.ml
    
clean:
	rm -f solitaire.cm* main.cm* solitaire.exe

test: solitaire.cmo
	rlwrap ocaml -noinit solitaire_defs.cmo help_solitaire.cmo solitaire.cmo -open Solitaire_defs -open Solitaire


