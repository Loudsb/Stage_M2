% RESOLUTION DES ANAPHORES

%prédicat qui affiche les anaphores avec leurs antécédents possibles
afficher_ante(Ante,ReferentsPossibles) :-
    format('Les antécédents possibles pour la variable ~p sont : ~p~n',[Ante,ReferentsPossibles]).

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
    recuperer_referents(Ref,R1,ListeRef1), %d'abord je récupère les référents de la première DRS
    rechercher_anaphore(C1,ListeRef1), %je cherche dans les conditions de la première DRS s'il y a pas des anaphores
    recuperer_referents(ListeRef1,R2,ListeRef2), % je récupère les référents de la deuxième DRS et je les mets à la suite de ceux de la première car ils doivent tous être accessible par les anaphores de la deuxième DRS
    rechercher_anaphore(C2,ListeRef2), !.

%prédicat qui cherche les mots ante dans la drs
%   en premier la structure dans laquelle on cherche
%   en deuxième la liste des référents
%   en troisième la liste des antécédents trouvés

rechercher_anaphore(drs(R,C),Ref) :- %si on cherche dans une drs, on regarde dans les conditions
    recuperer_referents(Ref,R,ListeRef),
    rechercher_anaphore(C,ListeRef), !.

rechercher_anaphore([X|Reste],Ref) :- %si on est dans une liste de conditions on traite la première condition de la liste
    rechercher_anaphore(X,Ref),
    rechercher_anaphore(Reste,Ref), !.
    
rechercher_anaphore(eq(X,_),Ref) :-
    enlever_var(X,Ref,ListeRef), %enlever la variable de la liste des antécédents possibles
    afficher_ante(X,ListeRef),
    genre(X,G), % Récupérer le genre du mot X
    format('Le mot ~p', [X]),
    nombre(X,N), % Récupérer le nombre du mot X
    format('Le mot ~p est ~p et ~p~n', [X,G,N]), !.

rechercher_anaphore(imp_drs(DRS1,DRS2),Ref) :-
    rechercher_anaphore_imp(DRS1,DRS2,Ref).

rechercher_anaphore(non(X),Ref) :-
    rechercher_anaphore(X,Ref), !.

rechercher_anaphore(_,_).


recherche(X) :- exemple(X,DRS), rechercher_anaphore(DRS,[]).




%Pour une variable je veux être capable de retrouver tous les prédicats dans lesquels elle se trouve pour pouvoir connaitre leur genre et leur nombre

% Prédicat pour trouver les prédicats contenant une lettre spécifique dans une structure DRS
trouver_predicat_lettre(_, [], []).
trouver_predicat_lettre(Lettre, [Predicat|Reste], Resultat) :-
    prédicat_contient_lettre(Lettre, Predicat), % Vérifie si le prédicat contient la lettre
    trouver_predicat_lettre(Lettre, Reste, Temp),
    append([Predicat], Temp, Resultat).
trouver_predicat_lettre(Lettre, [_|Reste], Resultat) :-
    trouver_predicat_lettre(Lettre, Reste, Resultat).

% Prédicat pour vérifier si un prédicat contient une lettre spécifique
prédicat_contient_lettre(Lettre, Prédicat) :-
    member(Lettre, Prédicat). % Vérifie si la lettre est présente dans le prédicat

% Prédicat pour parcourir une DRS et trouver tous les prédicats contenant une lettre spécifique
parcourir_drs_lettre(Lettre, drs(_, Conditions), Resultat) :-
    trouver_predicat_lettre(Lettre, Conditions, Resultat).
parcourir_drs_lettre(Lettre, drs(_, Conditions, DRS), Resultat) :-
    trouver_predicat_lettre(Lettre, Conditions, Resultat1),
    parcourir_drs_lettre(Lettre, DRS, Resultat2),
    append(Resultat1, Resultat2, Resultat).
parcourir_drs_lettre(Lettre, [DRS|Reste], Resultat) :-
    parcourir_drs_lettre(Lettre, DRS, Resultat1),
    parcourir_drs_lettre(Lettre, Reste, Resultat2),
    append(Resultat1, Resultat2, Resultat).

% Prédicat principal pour trouver les prédicats contenant une lettre spécifique dans une structure DRS
trouver_predicats_lettre(Lettre, Exemple, Resultat) :-
    exemple(_, Exemple), % Rechercher l'exemple correspondant
    parcourir_drs_lettre(Lettre, Exemple, Resultat).
