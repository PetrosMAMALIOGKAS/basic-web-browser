 (** Ce module est celui où vous devez travailler; Le but du projet est
d'y définir les fonctions (mutuellement récursives) display_html et
display_html_list. *)

open Graph_utils
open Graphics
open Html_tree


exception Pas_encore_implante


(*************************************************************************
  * Le type [display_state] représente l'entrée du moteur d'affichage:
  *  position courante dans la fenêtre, style du texte courant...
  ******************************************************************** *)
type display_state =
  {
    start_pos: position;   (** La position courante de l'afficheur. C'est là que le texte doit continuer. *)
    style: text_style;     (** Le style courant de l'afficheur. C'est comme ça que doit être affiché du texte brut. *)
  }



(***************************************************************
  *Le type [return_state] représente les données de sortie de l'afficheur: La
  *  liste des actionns d'affichage à faire, la nouvelle position, les ancres
  *  détectées...
  ***************************************************************************  *)
type return_state =
  {
    list_actions: drawing_action list;                      (** La liste des drawing actions. Une par mot. *)
    last_position: position;                                 (** Position situé à la fin de tous les affichages. *)
    (* ancres:(int*int*int*int*string) list;*)               (*  Rectangles des positions dans les ancres. *)
  }




(**************************************************************************
  *{1 LE MOTEUR D'AFFICHAGE}
  *  Le moteur d'affichage est une fonction récursive prenant en argument:
  *  - l'arbre html (de type html_tree) à afficher,
  *  - l'état du moteur d'affichage (de type display_state) et retourne le
  *    nouvel état de l'affichage (et aura pour effet d'afficher l'arbre dans
  *    la fenêtre graphique.)
  *
  * En fait c'est une fonction mutuellement récursive avec celle qui traite une
  * liste d'arbres. En effet chaque noeud de l'arbre html contient une liste de
  * sous-arbres.
  *-**************************************************************************)
(***********************************************************************
  * Affichage d'un mot de texte brut.
  *  [display_word state w] retourne la liste des actions d'affichage
  *  nécessaires pour afficher (texte brut) le mot [w] dans l'état [state].
  *  C'est ici qu'on décide où on place le mot dans la fenêtre (doit-on passer
  *  à la ligne?
  *****************************************************************)
let  display_word state wrd =
    let actions = [Text {texte = wrd; style = state.style; pos = state.start_pos }]
        in
        let strlen = text_width state.style wrd in
        let extremiteDroite = x_bottom_right_corner () in

    if ((fst state.start_pos + strlen + 10) < extremiteDroite )    then
        {
          list_actions = actions;
          last_position = ((fst state.start_pos + strlen + 10), (snd state.start_pos))
        }
    else
        let actionsSauteLigne =
           [Text {texte = wrd; style = state.style; pos =  (0, (snd state.start_pos - 20))}]
           in
          {
            list_actions = actionsSauteLigne;
            last_position = (0 + strlen + 10, snd state.start_pos - 20)
           }




 (********************************************************************
  * Affichage d'un arbre HTML.
  *  [display_html state tr] retourne la liste des actions d'affichage nécessaires
  *  pour afficher l'arbre [tr] à partir de l'état d'affichage [state].
  *****************************************************************)
let rec display_html (state:display_state) (tr:html_tree) : return_state =
match tr with
| Empty     -> {list_actions = []; last_position = state.start_pos}

| Html (_,l) -> let init_state =  {
                                    start_pos = (x_high_left_corner()+10 , y_high_left_corner()-10);
                                    style = default_style
                                  }
                                    in display_html_list init_state l

| Word s   -> display_word state s

| P (_, l) -> let newstate = {
                                state with start_pos = (0, (snd state.start_pos) - 20)
                             }
                                in display_html_list newstate l

| I (_,l)  ->  let newstate = {
                                state with style = {state.style with italicness = true}
                               }
                                in display_html_list newstate l

| B (_,l)  ->  let newstate = {
                                state with style = { state.style with boldness = true}
                              }
                                in display_html_list newstate l

| U (_,l)  ->  let newstate = {
                                state with style = { state.style with underlined = true}
                              }
                                in display_html_list newstate l

| A (_,l)  ->  let newstate = {
                                state with style = { state.style with color = blue}
                              }
                                in display_html_list newstate l

| H1 (_,l) ->  let newstate = {
                                 start_pos = (0, (snd state.start_pos) - 20);
                                 style = {state.style with size = 1;interligne=6 }
                              }
                                in display_html_list newstate l

| H2 (_,l) -> let newstate = {
                               start_pos = (0, (snd state.start_pos) - 20);
                               style = {state.style with size = 2; interligne=5 }
                              }
                               in display_html_list newstate l

| H3 (_,l) -> let newstate = {
                               start_pos = (0, (snd state.start_pos) - 20);
                               style = {state.style with size = 3; interligne=4 }
                              }
                               in display_html_list newstate l

| H4 (_,l) ->  let newstate = {
                                start_pos = (0, (snd state.start_pos) - 20);
                                style = {state.style with size = 4; interligne=3 }
                              }
                                in display_html_list newstate l

| H5 (_,l)  ->   let newstate = {
                                 start_pos = (0, (snd state.start_pos) - 20);
                                 style = {state.style with size = 5; interligne=2}
                                }
                                in display_html_list newstate l

| _        -> {list_actions = []; last_position = state.start_pos}





(****************************************************
  * Affichage d'une liste d'arbres HTML.
  *  [display_html_list state ltr] retourne la liste des actions d'affichage
  *  nécessaires pour afficher la liste d'arbres [ltr] à partir de l'état
  *  d'affichage [state]. On appelle [display_html] sur chaque arbres avec une
  *  position mise à jour à chaque fois.
  ******************************************************)
and display_html_list (state:display_state) (ltr:html_tree list) =
match ltr with
| [] ->  {list_actions = []; last_position = state.start_pos}
| a::l -> let ret_state_a =  display_html state a in
          let ret_state_l = display_html_list { state with start_pos = ret_state_a.last_position } l
          in
          {
            last_position = ret_state_l.last_position ;
            list_actions =  ret_state_a.list_actions @  ret_state_l.list_actions
          }







let display htree =
  (***************************************************
  *  L'état d'affichage initial: en haut à gauche de la fenêtre graphique, texte normal.
  ***********************************************************)
  let init_state =
    { start_pos = (x_high_left_corner()-10 , y_high_left_corner()-10);
      style = default_style } in
  display_html init_state htree
