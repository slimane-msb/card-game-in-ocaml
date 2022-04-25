open Solitaire
let () = if Array.length Sys.argv >= 2 && Sys.argv.(1) = "-norandom" then () else Random.self_init ()

let main () =
    let rec loop jeu msg =
        if victoire jeu then (Printf.printf "%sVictoire !\n" Solitaire_defs.clear_screen; affiche_jeu jeu)
        else begin
            Printf.printf "%s" Solitaire_defs.clear_screen;
            Printf.printf "%s\n%!" msg;
            affiche_jeu jeu;
            Printf.printf "Saisir une commande : %!";
            let com = String.uppercase_ascii (read_line ()) in
            let len = String.length com in
            if len = 0 then loop jeu "Dernière commande invalide !" else
            if com.[0] = 'P' && len = 1 then loop (pioche jeu) "Nouvelle carte piochée." else
            if com.[0] = 'R' && len = 2 then
                if com.[1] >= '1' && com.[1] <= '7' then
                    let i = (Char.code com.[1]) - (Char.code '1') in
                    let visibles, cachees = nieme jeu.piles i in
                    match visibles with
                        c :: reste -> 
                        let jeu, msg = try 
                            let njeu = { jeu with piles = remplace_nieme jeu.piles i (decouvre (reste, cachees)) } in
                            range_carte njeu c, Printf.sprintf "Carte %s rangée." (Solitaire_defs.string_of_carte c) 
                            with Failure msg -> jeu, msg
                        in loop jeu msg
                        | _ -> loop jeu (Printf.sprintf "La pile %d est vide!" i)
                else if com.[1] = 'D'  then
                    match jeu.defausse with
                        c :: reste ->
                        let jeu, msg = try 
                            let njeu = { jeu with defausse  = reste } in
                            range_carte njeu c, Printf.sprintf "Carte %s rangée." (Solitaire_defs.string_of_carte c) 
                            with Failure msg -> jeu, msg
                        in loop jeu msg
                        | _ -> loop jeu "La défausse est vide"
                      else loop jeu "Argument de commande 'R' invalide"
            else if com.[0] = 'D' && len = 3 then
                    if com.[2] >= '1' && com.[2] <= '7' then
                        let j = (Char.code com.[2]) - (Char.code '1') in
                        let njeu, msg =
                            try
                                if com.[1] >= '1' && com.[1] <= '7' then
                                let i = (Char.code com.[1]) - (Char.code '1') in
                                    pile_vers_pile jeu i j, Printf.sprintf "Carte(s) déplacées de la pile %d à la pile %d." (i+1) (j+1)
                                else if com.[1] = 'D' then
                                    defausse_vers_pile jeu j, Printf.sprintf "Carte déplacée de la défausse vers la pile %d." (j+1)
                                else jeu, "Source du déplacement invalide"
                            with Failure msg -> jeu, msg
                        in loop njeu msg
                    else loop jeu "Destination invalide"
            else if com.[0] = 'Q' && len = 1 then (Printf.printf "%sAbandon !\n" Solitaire_defs.clear_screen; affiche_jeu jeu)
            else loop jeu "Commande invalide"
        end
        in
        let jeu = init_jeu () in
        loop jeu "Début de partie.";
        Printf.printf "\n%!"
        
let () =
try
    main ()
with Failure msg -> Printf.eprintf "%s%s\n%!" Solitaire_defs.clear_screen msg
  | e -> Printf.printf "%sErreur : %s" Solitaire_defs.clear_screen (Printexc.to_string e)


                
