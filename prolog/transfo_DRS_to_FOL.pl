% DEUXIEME MANIERE DE TRADUIRE EN FOL (DIRECTEMENT A PARTIR DE LA DRS)

drs_to_fol(drs(X,Y),R) :- %cas où la DRS n'a pas de marqueurs référents
    X = [], %Je vérifie qu'elle n'en a pas
    drs_to_fol(Y,R), !. %Je traduis ses conditions en logique du premier ordre

drs_to_fol(drs(X,Y),R) :- %cas d'une DRS normale
    drs_to_fol(Y,R1), %Je traduis ses conditions en logique du premier ordre
    trad_exist_fol(X,[R1],R), !. %Je prend ses marqueurs référents et je les met dans un exist avec à droite les conditions traduite en fol

drs_to_fol(imp_drs(X,Y),R) :- %cas où la condition est un implication de DRS
    impl_drs_to_fol(X,Y,R), !.

drs_to_fol(non(X),R) :- %cas où la condition est une négation de DRS
    drs_to_fol(X,R1), %je traduit la drs normalement
    neg_v2(not(R1),R), !. %je gère la négation

drs_to_fol([X],R) :- %cas où la DRS ne contient qu'une seule condition
    drs_to_fol(X,R).

drs_to_fol([X|Reste],R) :- %cas où j'ai une liste de condition
    Reste \= [], %je vérifie que la liste contienne bien au moins 2 éléments
    drs_to_fol(X,R1), %je traduis la première condition
    drs_to_fol(Reste,R2), %je traduit le reste des conditions
    list_and(R1,R2,R), !. %je fais un and entre les deux conditions
    
drs_to_fol(X,X) :- !. %cas où on a juste une condition "normale"

impl_drs_to_fol(drs(X,Y),DRS2,R) :- %cas où on a une DRS en tête d'implication
    drs_to_fol(Y,R1), % je traduis les conditions de la première DRS
    drs_to_fol(DRS2,R2), %je traduis la deuxième DRS
    impl(R1,R2,R3), %on fait implique entre les conditions de la première et la deuxième DRS
    trad_forall_fol(X,[R3],R), !. %On met ses marqueurs référents dans un forall

neg_v2(not(X),R) :-
    negation(not(X),R), !.
neg_v2(X,X) :- !.

trad_fol_v2(X,R2) :- 
    exemple(X,DRS),
    drs_to_drt(DRS,R1),
    drs_to_fol(DRS,R2),
    format('~p ~n',[DRS]), %j'affiche la DRS qu'on traduit
    format('~nLa traduction en logique drt est : ~n ~p. ~n',[R1]),
    format('~nLa traduction en fol est : ~n ~p. ~n',[R2]).