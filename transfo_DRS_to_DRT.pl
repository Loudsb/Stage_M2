% -*- Mode:Prolog -*-

%Transformation de DRS en logique DRT


%Exemple 1 facile
exemple(1,drs([x,y],[man(x),enter(x),smiled(y),eq(y,_)])).

%Exemple 2 implication
%Si un fermier possède un âne, il le bât.
%exist(x),exist(y),impl(and(fermier(x),and(âne(y),and(posseder(x,y),true))),
exemple(2,drs([],[imp_drs(drs([x,y],[fermier(x),âne(y),possede(x,y)]),drs([u,v],[eq(u,_),eq(v,_),battre(u,v)]))])).

%Exemple 3 négation
exemple(3,drs([],[non(drs([x,y],[man(x),enter(x),smiled(y),eq(y,_)]))])).

%Je crée une liste qui contient tous les référents de la DRS
listeRef(drs(ListeR,_), ListeR).
    
%Je crée une liste qui contient toutes les conditions
listeCond(drs(_,ListeC),ListeC).

%Traduction des référents et des conditions
list_to_vars([X], exist(X)).
list_to_vars([X|Xs], and(exist(X),E)) :- list_to_vars(Xs,E).

list_to_cond([X],X).
list_to_cond([X|Xs], and(X,E)) :- list_to_cond(Xs,E).

%Je fais un and() des formules des référents et des conditions
list_and(L1, L2, and(L1,L2)).

%Je l'affiche
formule_simple(X) :- exemple(X,DRS), listeRef(DRS,Re),
    listeCond(DRS,C), list_to_vars(Re,L1),list_to_cond(C,L2), list_and(L1,L2,R), format('La traduction de la drs est : ~n ~p. ~n',[R]).
 
 

%IMPLICATION DE DRS

%Récupère la prémisse de l'implication
premisse_imp(imp_drs(X,_),X).
%Récupère la conclusion de l'implication
conclusion_imp(imp_drs(_,Y),Y).

%Traduit la prémisse en formule logique
trad_imp1(DRS1,R) :- listeRef(DRS1,Re), listeCond(DRS1,C), list_to_vars(Re,L1), trad_cond(C,L2), list_and(L1,L2,R).
%Traduit la conclusion en formule logique
trad_imp2(DRS2,R) :- listeRef(DRS2,Re), listeCond(DRS2,C), list_to_vars(Re,L1),trad_cond(C,L2), list_and(L1,L2,R).
%Il y a pas besoin d'avoir ça je penses



%Prend 2 formules et les met dans un implique
impl(F1,F2,imp(F1,F2)).

trad_cond([X], Y) :- handle(X, Y).
trad_cond([X|Xs], and(Y,R)) :- handle(X,Y), trad_cond(Xs,R).

% Si la condition commence par imp et que les deux trucs sont des drs on les
% traduit en formules logiques et on applique l'implication
handle(imp_drs(X,Y), R) :- is_drs(X), is_drs(Y), drs_to_drt(X,R1), drs_to_drt(Y,R2), impl(R1,R2,R).
% Si la condition commence par non et qu'il s'agit d'une drs, on traduit
% en formule logique et on applique la négation
handle(non(X), not(R)) :- is_drs(X), drs_to_drt(X,R).
% Si la condition est une DRS, on la traduit simplement en formule logique
handle(X,R) :- is_drs(X), drs_to_drt(X,R).
%Si la condition est un prédicat basique je ne touche à rien
handle(X,X) :- \+ is_drs(X).

% Vérifie si une condition est une DRS
is_drs(drs(_,_)).

% Transformation d'une DRS en formule logique
drs_to_drt(DRS,R) :- listeRef(DRS,Re), listeCond(DRS,C), list_to_vars(Re,L1), trad_cond(C,L2), list_and(L1,L2,R).


trad(X) :- exemple(X,DRS), drs_to_drt(DRS,R), format('La traduction de la drs est : ~n ~p. ~n',[R]).



























