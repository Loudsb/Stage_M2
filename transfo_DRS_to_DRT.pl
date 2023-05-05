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
%Je dit que toutes les variables de cette liste sont des référents.
referent(DRS, X) :- listeRef(DRS, L), member(X,L).
    
%Je crée une liste qui contient toutes les conditions
listeCond(drs(_,ListeC),ListeC).
%Je dit que toutes les variables de cette liste sont des conditions.
condition(DRS,X) :- listeCond(DRS,L), member(X,L).

%On ajoute tous les référents et les conditions pour faire une formule complète:
%Traduction des référents et des conditions
list_to_vars([],true).
list_to_vars([X|Xs], and(exist(X),E)) :- list_to_vars(Xs,E).

list_to_cond([],true).
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
trad_imp1(R) :- premisse_imp(_,DRS1), listeRef(DRS1,Re), listeCond(DRS1,C), list_to_vars(Re,L1), list_to_cond(C,L2), list_and(L1,L2,R).
%Traduit la conclusion en formule logique
trad_imp2(R) :- conclusion_imp(_,DRS2), listeRef(DRS2,Re), listeCond(DRS2,C), list_to_vars(Re,L1),list_to_cond(C,L2), list_and(L1,L2,R).
%IL FAUT GERER QUAND IL N'Y A PAS QUE DES CODITIONS STANDARD AUSSI, ET DONC UTILISER MAP

imp(F1,F2) :- trad_imp1(F1), trad_imp2(F2).

map([],true).
map([X|Xs], and(Y,R)) :- handle(X,Y), map(Xs,R).

% Si la condition commence par imp et que les deux trucs sont des drs on les
% traduit en formules logiques et on applique l'implication
handle(imp_drs(X,Y), R) :- is_drs(X), is_drs(Y), trad_imp1(R1), trad_imp2(R2), list_and(R1,R2,R3), 
    map([X,Y],R4), impl(R3,R5), list_and(R4,R5,R).
% Si la condition commence par non et qu'il s'agit d'une drs, on traduit
% en formule logique et on applique la négation
handle(non(X), not(R)) :- is_drs(X), map([X],R1), list_and(R1,true,R2), neg(R2,R).
% Si la condition est une DRS, on la traduit simplement en formule logique
handle(X,R) :- is_drs(X), map([X],R).

% Vérifie si une condition est une DRS
is_drs(drs(_,_)).

% Transformation d'une DRS en formule logique
drs_to_drt(DRS,R) :- map([DRS],R).



%impDRS(X,Y) :- X=drs(_,_), Y=drs(_,_), \+ X;Y.
%Negation de DRS
%non(DRS) :- not(DRS), D=drs(_,_).
%and([X|Reste]) :- X,Reste.
%drs(U,V) :- imp(X,_), X=drs(U,V).
%drs(U,V) :- imp(_,Y), Y=drs(U,V).
 

%is_drs(X) :- impDRS(X,_).
%is_drs(Y) :- impDRS(_,Y).

%Si la condition est une drs alors chaque élément qui la compose est aussi une condition

%drs_find([], [], []).
%drs_find([Ref|_], [Content|_], Ref-Content).
%drs_find([_|RestRefs], [_|RestConts], Res) :- drs_find(RestRefs, RestConts, Res).





% Je passes un peu à côté de mon stage

% J'avance pas bcp ça me stresse j'ai l'impression que je vais rien avoir à montrer à la fin

% Je me laisse envahir par la difficulté, elle me prend trop de temps

% Des réunions tous les vendredis avec Richard et toutes les 2 semaines avec Simon
% Avoir des deadlines 













%list_and([a],[b],X).





