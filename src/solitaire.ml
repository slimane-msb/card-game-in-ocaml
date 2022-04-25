open Solitaire_defs



(* 
    affiche_tas : carte list -> unit
    Affiche soit un emplacement vide (en utilisant la variable globale zone_vide) si le tas est vide
            soit la première carte du tas s'il est non vide. On peut convertir la carte en chaîne avec
            la fonction string_of_carte (qui s'occupe d'ajouter les couleurs correctement).

*)

let affiche_tas tas =

   match tas with 
      [] -> Printf.printf "%s" zone_vide
      | carte::ttas -> Printf.printf "%s"(string_of_carte carte)

 

   (*Help_solitaire.affiche_tas tas*)
;;

(* 
   affiche_piles : (carte liste * carte list) list -> unit
   Affiche la liste des piles. Chaque pile est précédée de son numéro, en
   commençant par 1. Pour chaque pile (lvisibles, lcachees) on affiche :
     - son numéro, suivi de deux points ":"
     - les cartes de lvisibles, chacune suivie d'un espace. Comme précédemment
       les cartes sont à convertir avec string_of_carte.
     - pour chaque carte de lcachees, on affiche la chaine contenue dans
       la variable globale carte_cachee, suivie d'un espace
     - deux retour à la ligne

   Une fonction utile est la fonction List.iteri: (int -> 'a -> unit) -> 'a list -> unit
   Elle est semblable à la fonction List.iter vue en cours mais la fonction f passée en argument
   reçoit en plus la position dans la liste, en plus de la valeur. Attention la position
   commence à 1.

   Par exemple
     List.iteri (fun i c -> Printf.printf "%d:%s " i c) ["a"; "b"; "c"]
   affiche:
     0:a 1:b 2:c

*)

let affiche_piles piles =

   let affiche_couple_list couple =
      List.iter (fun carte -> Printf.printf "%s "(string_of_carte carte)) (fst couple);(*c affiche_tas in*)
      List.iter (fun carte -> Printf.printf "%s " carte_cachee ) (snd couple);
      Printf.printf "\n\n"
   in 
   List.iteri (fun i couple -> 
      Printf.printf "%d: " (i+1) ;
      affiche_couple_list couple
    ) piles


   (*Help_solitaire.affiche_piles piles*)
;;

(* 
    affiche_pioche: carte list -> unit
    Affiche la pioche. Si celle ci est vide, on affiche la chaîne contenue dans la variable globale
    zone_vide sinon on affiche celle contenue dans la variable globale carte_cachee.

*)

let affiche_pioche pioche =

   match pioche with 
      [] -> Printf.printf "%s" zone_vide
      | carte::ppioche -> Printf.printf "%s"( carte_cachee) (*c vide _*)

   (*Help_solitaire.affiche_pioche pioche*)
;;


(* 
    affiche_jeu : jeu -> unit
    Affiche l'état du jeu. On utilise affiche_tas pour afficher dans l'ordre le tas de cœur, de pique, de trefle et de
    carreau chacun séparé de 2 espaces.
    Puis on affiche 4 espaces.
    Puis on utilise affiche_tas pour afficher la défausse.
    Puis on affiche 1 espace.
    Puis on affiche la pioche avec affiche_pioche.
    Puis on affiche deux retours à la ligne.
    Puis on affiche les piles avec affiche_piles
    Puis on affiche un retour à la ligne.

*)

let affiche_jeu jeu =

   affiche_tas jeu.coeur;
   Printf.printf "  ";
   
   affiche_tas jeu.pique;
   Printf.printf "  ";
   
   affiche_tas jeu.carreau;
   Printf.printf "  ";
   
   affiche_tas jeu.trefle;
   Printf.printf "    ";
   
   affiche_tas jeu.defausse;
   Printf.printf " ";
   
   affiche_pioche jeu.pioche;
   Printf.printf "\n";
   
   affiche_piles jeu.piles;
   Printf.printf "\n";
   
   (*Help_solitaire.affiche_jeu jeu*)
;;


let valeurs = [ Valeur 1; Valeur 2; Valeur 3; Valeur 4;
                Valeur 5; Valeur 6 ; Valeur 7; Valeur 8;
                Valeur 9 ; Valeur 10; Valet; Dame; Roi ]

(* 
    init_cartes : couleur -> carte list
    Utilise la variable globale valeurs pour renvoyer la liste de toutes
    les cartes de la couleur donnée en argument.

*)

let init_cartes couleur =

   List.map (fun vall ->  { couleur = couleur; valeur = vall }) valeurs;
   (*Help_solitaire.init_cartes couleur*)
;;

(* Le paquet de carte initiale, où les 13 cartes de chaque couleur sont présentes dans l'ordre *)
let paquet_initial = (init_cartes Coeur) @ (init_cartes Pique) @ (init_cartes Carreau) @ (init_cartes Trefle)
;;

(* 
    melange : carte list -> carte list
    Mélange aléatoirement la liste de carte donnée en argument. On peut utiliser l'algorithme suivant :
    On calcule une liste de paires d'un entier aléatoire (entre 0 1000, obtenu par Random.int 1000)
    et d'une carte.
    Puis on trie cette liste en utilisant List.sort avec la fonction de comparaison generique
    compare de la bibliothèque standard.
    Puis sur cette liste triée, on retire les entiers aléatoires pour obtenir une liste de cartes

*)
let melange paquet =

   List.map (fun c -> (snd c) ) (List.sort compare (List.map ( fun carte -> (Random.int 1000 , carte )) paquet))

   (*Help_solitaire.melange paquet*)
;;

(* 
   n_premieres: carte list -> int -> carte list * carte list
   Cette fonction récursive prend en argument une liste de cartes et un entier n.
   Elle renvoie une paire de listes (lprem, lreste) où :
   lprem est la liste des n premières cartes de la liste initiale et
   lreste est la liste des cartes restantes

   Si la liste est trop courte, lève l'erreur :
   failwith "npremiere: pas assez de cartes"

*)

let rec n_premieres paquet n =

   match paquet with 
   [] ->  
      if n<=0 then ([],[])
      else failwith "npremiere: pas assez de cartes"
   | cart::ppiquet -> 
      if n>0 then 
         let a,b = n_premieres ppiquet (n-1) in
         (cart::a,b)
      else([],cart::(snd (n_premieres ppiquet (n-1))))
   (* Help_solitaire.n_premieres paquet n *)
;;


(*
   Q8
   init_piles: carte list -> (carte list * carte list)
   Cette fonction prend en argument une liste de cartes l.
   Elle prend les 7 premières cartes de l et crée une pile
   [ ([c], l6) ] où c est la carte visible et l6 la liste des 6 cartes cachées.
   Puis elle fait de même sur les cartes restantes pour ajouter :
   [ ([c], l5) ; ([c], l6) ]
   Puis ainsi de suite jusqu à former
   [ ([c], []); ...; ([c], l7) ]


   La fonction est donnée, ne pas la modifier.
   Question : Quel est le type de la fonction interne 'init_pile' ?
   Réponse : carte list -> ( carte list * carte list) 

*)

let init_piles paquet =
    let init_pile cartes =
        match cartes with
            [] -> failwith "init_pile: pas assez de cartes"
        | p :: r -> [p], r
    in
    List.fold_left (fun (acc_piles, acc_reste) n ->
            let tas, acc_reste = n_premieres acc_reste n in
            let pile = init_pile tas in
            (pile :: acc_piles, acc_reste))
            ([], paquet) [ 7;6;5;4;3;2;1 ]

;;

(* La fonction qui initialise le jeu, ne pas modifier *)
let init_jeu () =
    let cartes = melange paquet_initial in
    let piles, reste = init_piles cartes in
    { coeur   = [];
      pique   = [];
      carreau = [];
      trefle  = [];
      defausse= [];
      pioche  = reste;
      piles   = piles;
      }
;;
(* : pioche : jeu -> jeu
   La fonction qui pioche une carte et renvoie le nouveau jeu. Pour cela :
   - si la défausse ET la pioche sont toutes les deux vides, alors lever l'erreur
     failwith "pioche: plus de carte à piocher"
   - si la pioche est vide, alors
        créer un nouveau jeu où la pioche contient les cartes de la défausse renversée
        et la défausse est vide, puis piocher dedans
   - sinon prendre la première carte de la pioche et la poser sur la défausse

*)
(* tocheck -> pourquoi c'est recursive*)
let rec pioche jeu =

   
   match jeu.pioche,jeu.defausse with
   [],[] -> failwith "pioche: plus de carte à piocher"
   | [],_ -> pioche  {  coeur   = jeu.coeur;
                        pique   = jeu.pique;
                        carreau = jeu.carreau;
                        trefle  = jeu.trefle;
                        piles   = jeu.piles;
                        defausse= [];
                        pioche  = jeu.defausse }
   |carte::jd,_ -> 
                     { coeur    = jeu.coeur;
                        pique   = jeu.pique;
                        carreau = jeu.carreau;
                        trefle  = jeu.trefle;
                        piles   = jeu.piles;
                        defausse= (carte::jeu.defausse);
                        pioche  =  jd }
   
  (* Help_solitaire.pioche jeu *)
;;

(* 0
   couleur_compatible: couleur -> couleur -> bool
   Renvoie vrai si les couleurs c1 et c2 sont compatibles
    (i.e. c1 est Pique ou Trefle et c2 est Coeur ou Carreau, et vice-versa.
   Renvoie faux dans les autres cas

*)
let couleur_compatible c1 c2 =

   match c1 with 
   |Pique  -> (
      match c2 with 
         |Coeur -> true  
         |Carreau -> true 
         |_-> false )
   |Trefle -> (
      match c2 with 
         |Coeur|Carreau -> true 
         |_-> false )
   |_-> (
      match c2 with 
      |Trefle -> true 
      |Pique -> true
      |_-> false )
   (*Help_solitaire.couleur_compatible*)
;;

(* 1 renvoie la valeur suivante à celle donnée en argument.
       Si v vaut Roi, lève l'erreur
       failwith "valeur_suivante: appel sur un roi"

*)

let valeur_suivante v =

   match v with 
      Roi -> failwith "valeur_suivante: appel sur un roi"
      | Dame -> Roi 
      | Valet -> Dame 
      | Valeur 10 ->  Valet 
      | Valeur a -> Valeur (a+1)


   (*Help_solitaire.valeur_suivante v    *)
;;

(* 2
   est_suivante_meme_couleur: carte -> carte -> bool
   Renvoie vrai si est seulement si suiv est la carte juste après c et que les deux sont de même couleur
   (i.e. toutes les deux du Pique ou toutes les deux du Coeur. Coeur et Carreau ne sont pas la même couleur)
   Si ce n'est pas le cas la fonction renvoie faux.

   0.5 *)

let est_suivante_meme_couleur c suiv =

   ((couleur_compatible c.couleur suiv.couleur = false) &&  ((valeur_suivante c.valeur)= suiv.valeur))
  (* Help_solitaire.est_suivante_meme_couleur c suiv  *)
;;

(* 3
   est_suivante_couleur_diff c suiv
   Renvoie vrai si et seulement si suiv est la carte juste après c et les deux cartes sont de couleur compatible
    
*)
let est_suivante_couleur_diff c suiv =

   ((couleur_compatible c.couleur suiv.couleur = true) &&  ((valeur_suivante c.valeur)= suiv.valeur))
   (*Help_solitaire.est_suivante_couleur_diff c suiv *)
;;

(* 4
   cherche_index_pour_suivante: carte list -> carte -> int
   Étant donnée une carte suiv, renvoie la position (à partir de 1) de la carte c telle que
   est_suivante_couleur_diff c suiv, si elle existe.
   Si ce n'est pas le cas, renvoie 0.

   Par exemple, si suiv est le 9 de Pique, cherche_index_pour_suivante l suiv, renvoie la
   position du 8 de cœur ou du 8 de carreau si l'un des deux est présent dans l, et 0 sinon.
   On peut supposer qu'au plus une de ces cartes est dans l.

   Il peut être judicieux de faire une fonction recursive auxiliaire interne.

*)

let cherche_index_pour_suivante tas suiv =

   let rec aux_cips tas suiv ind =
      match tas with
      [] -> 0
      | carte::ttas -> 
         if est_suivante_couleur_diff carte suiv then ind
         else  aux_cips ttas suiv (ind +1)
   in
   aux_cips tas suiv 1
   (* Help_solitaire.cherche_index_pour_suivante tas suiv *)
;;

(* 5
   retire_defausse: jeu -> carte * jeu
   Prend en argument un jeu et renvoie la carte se trouvant au sommet de la defausse
   et le jeu sans cette carte.

   Lève l'erreur :
       failwith "retire_defausse: pas de carte"
   si la défausse est vide.

*)

let retire_defausse jeu =

   match jeu.defausse with
   [] -> failwith "retire_defausse: pas de carte"
   (* | carte::dfs -> jeu.defausse=dfs ; (carte,jeu)  *)
   | carte::dfs -> (carte,
                           {  coeur   = jeu.coeur;
                              pique   = jeu.pique;
                              carreau = jeu.carreau;
                              trefle  = jeu.trefle;
                              piles   = jeu.piles;
                              defausse= dfs;
                              pioche  =  jeu.pioche }
   )
   (*Help_solitaire.retire_defausse jeu*)
;;

(* 6
   nieme: 'a list -> n -> 'a
   renvoie le nième élément d'une liste. Doit lever l'erreur
   failwith "nieme: pas assez d'éléments" s'il n'y a pas assez d'éléments.

   On ne peut donc pas utiliser simplement List.nth, car il faut renvoyer
   une erreur différente en cas d'erreur.

   Les indices commencent à partir de 0.

*)


let rec nieme l n =

   match l with 
   [] -> failwith "nieme: pas assez d'éléments" 
   | e::ll -> 
      if n=0 then e 
      else nieme ll (n-1)
   (* Help_solitaire.nieme l n *)
;;

(* 7
   remplace_nieme: 'a list -> int -> 'a -> 'a list
   remplace la nieme valeur de l par v et renvoie la nouvelle liste.
   Lève l'erreur
       failwith "remplace_nieme: pas assez d'éléments"
   s'il n'y a pas assez d'éléments.

*)

let rec remplace_nieme l n v =

   match l with 
   [] -> ( if n>=0 then failwith "nieme: pas assez d'éléments"
         else [] )  
   | carte::ll -> (
      if n=0 then ( v::(remplace_nieme ll (n-1) v) )
      else (carte::(remplace_nieme ll (n-1) v)) )
   (* Help_solitaire.remplace_nieme l n v *)
;;


(* 8
   decouvre: carte list * carte list -> carte list * carte list
   La fonction prend en argument une pile (i.e. une paire (visibles, cachees))
   S'il n'y a pas de carte visible et au moins une carte cachée, la première carte
   cachée est mise dans le tas des visibles (et retirée du tas des cachées).
   La nouvelle paire est renvoyée.

   Sinon la pile est renvoyée telle qu'elle.

*)

let decouvre pile =

   match pile with 
   [],carte::cachee -> ([carte],cachee)
   |_,_ -> pile

   (* Help_solitaire.decouvre pile *)
;;

(* 9 :
   On demande de ne faire que l'UNE des fonctions ci-dessous. Vous pouvez bien sûr chercher
   l'autre si vous voulez, mais vous pouvez laisser l'appel au code du corrigé dans l'une des deux.
   Faire les deux fonctions ne rapporte pas plus de points.

   2 points
*)


(* defausse_vers_pile: jeu -> int -> jeu.
   Cette fonction implémente le mouvement qui consiste à prendre la première pile de la défausse
   (au moyen de retire_defausse) et de la placer sur la pile numéro n (ATTENTION: n va de 0 à 6)
   Deux cas sont possibles :
   - si la pile numéro n est vide (ni carte visible, ni carte cachée) alors on ne peut faire ce
     mouvement que si la carte en haut de la défausse est un Roi.
     sinon on doit lever l'erreur: failwith "defausse_vers_pile: non-roi sur une case vide"

   - si la pile numéro n est non vide, alors il faut vérifier que la carte visible qui est en premier
     est une valeur plus grande que la carte de la défausse et de couleur compatible.
     Par exemple si la carte de la défausse est le 10 de Coeur, la premiere carte visible de la pile
     choisie doit être un Valet de Pique ou un Valet de Trefle (pour pouvoir poser le 10 de Coeur en
     dessous.
     Si la carte de la pile n'a pas la bonne valeur, lever l'erreur:
         failwith "defausse_vers_pile: déplacement invalide"

*)

let defausse_vers_pile jeu n =

   (*recuperer la niem pile*)
   match (nieme jeu.piles n),(jeu.defausse) with 
   ([],[]),(carte::ldef)-> 
         ( match carte.valeur with 
               Roi -> 
                  {  coeur   = jeu.coeur;
                     pique   = jeu.pique;
                     carreau = jeu.carreau;
                     trefle  = jeu.trefle;
                     piles   = remplace_nieme jeu.piles n ([carte],[]);
                     defausse= ldef;
                     pioche  =  jeu.pioche }
               |_-> failwith "defausse_vers_pile: non-roi sur une case vide" )
   |(carteV::visible,cachee),carteD::ldef -> ( 
      if est_suivante_couleur_diff carteD carteV then 
         {  coeur   = jeu.coeur;
            pique   = jeu.pique;
            carreau = jeu.carreau;
            trefle  = jeu.trefle;
            piles   = (remplace_nieme jeu.piles n (carteD::carteV::visible,cachee));
            defausse= ldef;
            pioche  =  jeu.pioche }
      else failwith "defausse_vers_pile: déplacement invalide" )
   (* si la defausse est vide, on fait rien *)
   |_,_-> jeu 

   (* Help_solitaire.defausse_vers_pile jeu n *)
;;

(* pile_vers_pile: jeu -> int -> int -> jeu.
   Cette fonction réalise le mouvement du plus grand nombre de cartes possible depuis la pile n1
   vers la pile n2 (ATTENTION: n1 et n2 vont de 0 à 6, vous pouvez supposer qu'ils sont distincts,
   pas besoin de le vérifier).

   Pour cela, on récupère les deux piles correspondant à n1 et n2.

   Si la pile de destination est vide, alors lever une erreur :
       failwith ("pile_vers_pile: la pile " ^ (string_of_int n2) ^" est vide")
       (Noter que ce cas empêche de déplacer une suite commençant par un Roi, d'une pile vers
        une pile vide, ce qui est un mouvement inutile)

   Si la pile de destination possède une carte c2 visible, alors rechercher l'index dans les
   cartes visibles de la pile 1, de la carte de valeur juste inférieure à c2 et compatible (au moyen
   de la fonction cherche_index_pour_suivante).

       Si cette dernière renvoie 0, alors lever une erreur:
           failwith "pile_vers_pile: déplacement impossible"
       Si elle renvoie une valeur i >= 1, alors renvoyer le jeu où le i premières cartes
       visibles de la pile n1 sont déplacée en tête des cartes visibles de n2.

   Une fois les cartes de n1 retirées, on n'oubliera pas d'appeler decouvre sur cette pile,
   car si jamais on a retirer toutes les cartes visibles, il faut retourner la premier carte cachée.
*)

let pile_vers_pile jeu n1 n2 =


   Help_solitaire.pile_vers_pile jeu n1 n2
;;

(* 0:
   Pour chacune des fonctions suivantes, donner son type dans le commentaire ci-dessous :

   tas_par_couleur : jeu -> couleur -> carte list
   range_tas_par_couleur : jeu -> couleur -> carte list -> jeu 
   range_carte : jeu -> carte -> jeu 

*)

let tas_par_couleur jeu c =
    match c with
        Coeur -> jeu.coeur
        | Pique -> jeu.pique
        | Trefle -> jeu.trefle
        | Carreau -> jeu.carreau
;;

let range_tas_par_couleur jeu c tas =
    match c with
        Coeur -> { jeu with coeur = tas }
        | Pique -> { jeu with pique = tas }
        | Trefle -> { jeu with trefle = tas }
        | Carreau -> { jeu with carreau = tas }
;;

let range_carte jeu c =
    let tas = tas_par_couleur jeu c.couleur in
    let ntas = match tas with
                [] -> (if c.valeur = Valeur 1 then [ c ] else failwith "range_carte: carte invalide" )
                | c2:: _ -> ( if est_suivante_meme_couleur c2 c then c :: tas else failwith "range_carte: carte invalide")
    in
    range_tas_par_couleur jeu c.couleur ntas

;;

(* 1
   victoire: jeu -> bool
   La fonction renvoie vrai si et seulement si jeu correspond à une partie terminée, c'est à dire :
   - la pioche ET la défausse sont vides
   - chaque paquet de cartes de couleur est de taille 13
   (et si les fonctions précédentes ne sont pas buggées, alors cela implique
    que toutes les piles sont vides)

*)

let victoire jeu =

   match jeu.pioche,jeu.defausse,(List.length jeu.coeur),(List.length jeu.pique),(List.length jeu.carreau),(List.length jeu.trefle) with
   [],[],13,13,13,13 -> true 
   |_,_,_,_,_,_-> false
   (* Help_solitaire.victoire jeu *)
;;
