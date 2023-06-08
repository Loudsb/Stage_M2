% EXEMPLES

%Exemple 1 facile
exemple(1,drs([x,y],[man(x),enter(x),smiled(y),eq(y,ante)])).

%Exemple 2 implication
%Si un fermier possède un âne, il le bât.
%exist(x),exist(y),impl(and(fermier(x),and(âne(y),and(posseder(x,y),true))),
exemple(2,drs([],[imp_drs(drs([x,y],[fermier(x),âne(y),possede(x,y)]),drs([u,v],[eq(u,ante1),eq(v,ante2),battre(u,v)]))])).

%Exemple 3 négation
exemple(3,drs([],[non(drs([x,y],[man(x),enter(x),smiled(y),eq(y,ante)]))])).

%Exemple 4 négation
%Pierre ne connait aucune fille
exemple(4,drs([x],[pierre(x),non(drs([y],[fille(y),connait(x,y)]))])).

%Exemple 5
%À chaque fois que Marie relit un livre, il l’impressionne.
exemple(5,drs([x],[lea(x), imp_drs(drs([y],[livre(y),relit(x,y)]),drs([u,v],[impressionne(u,v),eq(u,ante1),eq(v,ante2)]))])).

%Exemple 6
%Un exemple qui n'a aucun sens pour tester différents cas de figures
exemple(6,drs([x],[non(pierre(x)),imp_drs(drs([x,y],[fermier(x),âne(y),possede(x,y)]),
                                          drs([u,v],[eq(u,ante1),eq(v,ante2),battre(u,v)]))])).


% BASE DE CONNAISSANCE
% Faits représentant le genre et le nombre des mots
genre(man, masculin).
genre(singe, masculin).
genre(âne, masculin).
genre(fermier, masculin).
genre(livre, masculin).
genre(pierre, masculin).
genre(fille, féminin).
genre(lea, féminin).

nombre(man, singulier).
nombre(singe, singulier).
nombre(âne, singulier).
nombre(fermier, singulier).
nombre(livre, singulier).
nombre(pierre, singulier).
nombre(fille, singulier).
nombre(lea, singulier).
nombre(man, pluriel).


% RESOLUTION DES ANAPHORES

%prédicat qui affiche les anaphores avec leurs antécédents possibles
afficher_ante(Ante,ReferentsPossibles) :-
    format('Les antécédents possibles pour le mot ~p sont : ~p~n',[Ante,ReferentsPossibles]).

%prédicat qui enlève les variables identiques à celles dont on cherche l'antécédent
enlever_var(_, [], []) :- !.
enlever_var(Var, [Var|T], R) :- enlever_var(Var, T, R), !.
enlever_var(Var, [H|T], [H|R]) :- enlever_var(Var, T, R).

%prédicat qui récupère les référents et les mets dans une liste
recuperer_referents([], List, List).
recuperer_referents([Head|Tail], List1, Result) :-
    recuperer_referents(Tail, List1, Temp),
    append([Head], Temp, Result).

%prédicat qui s'occupe du cas où il y a un implique entre 2 DRS
%parce que les anaphores à droite de l'implique doivent avoir accès
%aux antécédents présents dans la DRS à gauche de l'implique
rechercher_anaphore_imp(drs(R1,C1),drs(R2,C2),Ref) :-
    recuperer_referents(R1,Ref,ListeRef1), %d'abord je récupère les référents de la première DRS
    rechercher_anaphore(C1,ListeRef1), %je cherche dans les conditions de la première DRS s'il y a pas des anaphores
    recuperer_referents(R2,ListeRef1,ListeRef2), % je récupère les référents de la deuxième DRS et je les mets à la suite
                                                 % de ceux de la première car ils doivent tous être accessible par
                                                 % les anaphores de la deuxième DRS
    rechercher_anaphore(C2,ListeRef2), !.

%prédicat qui cherche les mots ante dans la drs
%   en premier la structure dans laquelle on cherche
%   en deuxième la liste des référents
%   en troisième la liste des antécédents trouvés

rechercher_anaphore(drs(R,C),Ref) :- %si on cherche dans une drs, on regarde dans les conditions
    recuperer_referents(Ref,R,ListeRef),
    rechercher_anaphore(C,ListeRef), !.

rechercher_anaphore([X|Reste],Ref) :- %si on est dans une liste de cond on traite la première cond de la liste
    rechercher_anaphore(X,Ref),
    rechercher_anaphore(Reste,Ref), !.
    
rechercher_anaphore(eq(X,_),Ref) :-
    enlever_var(X,Ref,ListeRef), %enlever la variable de la liste des antécédents possibles
    format('Les antécédents possibles pour le mot ~p sont : ~p~n',[X,ListeRef]),
    trouver_predicats_lettre(X,DRS), !.

rechercher_anaphore(imp_drs(DRS1,DRS2),Ref) :-
    rechercher_anaphore_imp(DRS1,DRS2,Ref).

rechercher_anaphore(non(X),Ref) :-
    rechercher_anaphore(X,Ref), !.

rechercher_anaphore(_,_).


recherche(X) :- exemple(X,DRS), rechercher_anaphore(DRS,[]).


    %genre(X,G), % Récupérer le genre du mot X
    %nombre(X,N), % Récupérer le nombre du mot X
    %format('Le mot ~p est ~p et ~p~n', [X,G,N])

%Pour une variable je veux être capable de retrouver tous les prédicats
%dans lesquels elle se trouve pour pouvoir connaitre leur genre et leur nombre

% Prédicat pour parcourir une DRS et trouver tous les prédicats contenant une lettre spécifique
parcourir_drs_lettre(_, [], []).
parcourir_drs_lettre(Lettre, drs(_, Cond), R) :-
    parcourir_drs_lettre(Lettre, Cond, R), !.
parcourir_drs_lettre(Lettre, [C1|Reste], R) :- %si c'est une liste de conditions
    parcourir_drs_lettre(Lettre, C1, R1),
    parcourir_drs_lettre(Lettre, Reste, R2),
    append(R1, R2, R), !.
parcourir_drs_lettre(Lettre,imp_drs(DRS1,DRS2),R) :- %si c'est une implication de 2 DRS
    parcourir_drs_lettre(Lettre, DRS1, R1),
    parcourir_drs_lettre(Lettre, DRS2, R2),
    append(R1, R2, R), !.
parcourir_drs_lettre(Lettre,non(P),R) :- %si c'est une implication de 2 DRS
    parcourir_drs_lettre(Lettre, P, R), !.
parcourir_drs_lettre(Lettre,C,R) :- %si c'est un prédicat normal
    compound(C), %je vérifie que la condition est bien un terme composé (un prédicat)
    C =.. [P|Arg], %j'extrait les arguments du prédicat, les met dans une liste et je récupère le nom du prédicat
    member(Lettre,Arg), %je vérifie que le prédicat contient bien la lettre
    R = [P|Reste],
    parcourir_drs_lettre(Lettre, Reste, ResteResultat),
    append(ResteResultat, R, R), !.
parcourir_drs_lettre(Lettre, C, R) :-
    compound(C),
    C =.. [_ | Args],
    \+ member(Lettre, Args),
    parcourir_drs_lettre(Lettre, Args, R), !.
parcourir_drs_lettre(_, _, []).
    

% Prédicat principal pour trouver les prédicats contenant une lettre spécifique dans une structure DRS
trouver_predicats_lettre(Lettre, DRS, R) :-
    exemple(_, DRS),
    parcourir_drs_lettre(Lettre, DRS, R),
    format('La lettre ~p est présente dans le(les) prédicat(s) : ~p~n',[Lettre,R]).


%ETAPE 1 
%Afficher les prédicats dans lesquels se trouve la lettre

%ETAPE 2

