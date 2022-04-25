type valeur = Valeur of int | Valet | Dame | Roi

type couleur = Coeur | Pique | Carreau | Trefle 

type carte = { couleur : couleur; valeur : valeur }


type jeu = { coeur : carte list;
                pique : carte list;
                carreau : carte list;
                trefle : carte list;
                piles : (carte list * carte list) list;
                defausse : carte list;
                pioche : carte list }


(* Ci-dessous uniquement des caractères spéciaux destinés à faire un affichage en couleur
   dans la console.
   Pour plus d'explications voir  : https://en.wikipedia.org/wiki/ANSI_escape_code
   
   *)
   
let rouge = "\x1b[37;41;1m" ;;   (* Le texte suivant ces caractères passe en fond rouge *)
let bleu = "\x1b[37;44;1m"  ;;  (* Le texte suivant ces caractères passe en fond bleu *)
let blanc = "\x1b[30;47;1m"  ;;  (* Le texte suivant ces caractères passe en fond blanc *)
let no_color = "\x1b[0m"    ;;  (* Le texte suivant ces caractères passe dans la couleur du terminal *)
let clear_screen =  "\x1b[2J\x1b[H" ;; (* Si on affiche cette chaîne l'écran est effacé *)


(* Une fonction qui convertit une carte en chaîne de caractère un peu jolie *)

let string_of_carte c =
    let v = match c.valeur with 
            | Valeur 1 -> " A"
            | Valeur 10 -> "10" 
            | Valeur i -> " "^string_of_int i
            | Valet -> " J"
            | Dame -> " Q"
            | Roi -> " K"
    in
    let coul, symb = match c.couleur with
            | Coeur -> rouge,"\226\153\165"
            | Pique -> bleu,"\226\153\160"
            | Carreau -> rouge,"\226\153\166"
            | Trefle -> bleu, "\226\153\163"
    in coul ^ v ^ symb ^ no_color
;;

let carte_cachee = blanc ^ "   " ^ no_color;; (* La chaîne "   " en blanc affiche un grand rectangle  *)

let zone_vide = "\226\172\154\226\172\154\226\172\154";;   (* La chaîne "⬚⬚⬚" *)
