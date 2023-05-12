%Transformation de DRS en logique DRT


%Exemple 1 facile
exemple(1,drs([x,y],[man(x),enter(x),smiled(y),eq(y,x)])).

%Exemple 2 implication
%Si un fermier possède un âne, il le bât.
%exist(x),exist(y),impl(and(fermier(x),and(âne(y),and(posseder(x,y),true))),
exemple(2,drs([],[imp_drs(drs([x,y],[fermier(x),âne(y),possede(x,y)]),drs([u,v],[eq(u,x),eq(v,y),battre(u,v)]))])).

%Exemple 3 négation
exemple(3,drs([],[non(drs([x,y],[man(x),enter(x),smiled(y),eq(y,x)]))])).

% TRADUCTION DES DRS EN LOGIQUE DRT

%Je crée une liste qui contient tous les référents de la DRS
listeRef(drs(ListeR,_), ListeR).
    
%Je crée une liste qui contient toutes les conditions
listeCond(drs(_,ListeC),ListeC).

%Traduction des référents
list_to_vars([],true).
list_to_vars([X], exist(X)) :- !.
list_to_vars([X|Xs], and(exist(X),E)) :- list_to_vars(Xs,E).


%Je fais un and() des formules des référents et des conditions
list_and(L1, L2, and(L1,L2)).
 

%IMPLICATION DE DRS

%Prend 2 formules et les met dans un implique
impl(F1,F2,imp(F1,F2)).

% Vérifie si une condition est une DRS
is_drs(drs(_,_)).

% Si la condition commence par imp et que les deux trucs sont des drs on les
% traduit en formules logiques et on applique l'implication
handle(imp_drs(X,Y), R) :- is_drs(X), is_drs(Y), !, drs_to_drt(X,R1), drs_to_drt(Y,R2), impl(R1,R2,R).
% Si la condition commence par non et qu'il s'agit d'une drs, on traduit
% en formule logique et on applique la négation
handle(non(X), not(R)) :- is_drs(X), !, drs_to_drt(X,R).
% Si la condition est une DRS, on la traduit simplement en formule logique
handle(X,R) :- is_drs(X), !, drs_to_drt(X,R).
%Si la condition est un prédicat basique je ne touche à rien
handle(X,X) :- \+ is_drs(X).

%trad_cond([],_).
trad_cond([X],Y) :- handle(X,Y), !.
trad_cond([X|Xs], and(Y,R)) :- handle(X,Y), trad_cond(Xs,R).

% Transformation d'une DRS en formule logique
drs_to_drt(DRS,R) :- listeRef(DRS,Re), listeCond(DRS,C), list_to_vars(Re,L1), trad_cond(C,L2), list_and(L1,L2,R).


trad_drs(X,R) :- exemple(X,DRS), drs_to_drt(DRS,R), format('La traduction de la drs est : ~n ~p. ~n',[R]).


% TRADUCTION EN LOGIQUE DU PREMIER ORDRE

trad_exist_fol(Exists,Cond,exist(Exists,Cond)).

get_exist_vars(exist(X), [X]) :- !.
get_exist_vars(and(F1, F2), L) :-
    get_exist_vars(F1, L1),
    get_exist_vars(F2, L2),
    append(L1, L2, L), !.
get_exist_vars(_, []) :- !.

get_cond(and(and(exist(_),_),C),[C]).
get_cond(and(true,X),R) :- get_cond(X,R).
get_cond(not(X),R) :- get_cond(X,R).

drt_to_fol(not(X),not(R)) :- drt_to_fol(X,R), !.
drt_to_fol(imp(X,Y),R) :- 
    drt_to_fol(X,R1),
    drt_to_fol(Y,R2),
    impl(R1,R2,R), !.
drt_to_fol(and(true,X),R) :- drt_to_fol(X,R), !.
drt_to_fol(F,R) :-
    get_exist_vars(F, L1),
    get_cond(F,L2),
    trad_exist_fol(L1,L2,R), !.


trad_fol(X,R) :- trad_drs(X,R1), drt_to_fol(R1,R), format('La traduction en fol est : ~n').




