% RESOLUTION DES ANAPHORES

%prédicat qui affiche les anaphores avec leurs antécédents possibles
afficher_ante(Ante,ReferentsPossibles) :-
    format('Les antécédents possibles pour le mot ~p sont : ~p~n',[Ante,ReferentsPossibles]).

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
    recuperer_referents(R2,ListeRef1,ListeRef2), % je récupère les référents de la deuxième DRS et je les mets à la suite de ceux de la première car ils doivent tous être accessible par les anaphores de la deuxième DRS
    rechercher_anaphore(C2,ListeRef2), !.

%prédicat qui cherche les mots ante dans la drs
%   en premier la structure dans laquelle on cherche
%   en deuxième la liste des référents
%   en troisième la liste des antécédents trouvés

rechercher_anaphore(drs(R,C),Ref) :- %si on cherche dans une drs, on regarde dans les conditions
    recuperer_referents(R,Ref,ListeRef),
    rechercher_anaphore(C,ListeRef), !.

rechercher_anaphore([X|Reste],Ref) :- %si on est dans une liste de conditions on traite la première condition de la liste
    rechercher_anaphore(X,Ref),
    rechercher_anaphore(Reste,Ref), !.
    
rechercher_anaphore(eq(_,A),Ref) :-
    afficher_ante(A,Ref), !.

rechercher_anaphore(imp_drs(DRS1,DRS2),Ref) :-
    rechercher_anaphore_imp(DRS1,DRS2,Ref).

rechercher_anaphore(non(X),Ref) :-
    rechercher_anaphore(X,Ref), !.

rechercher_anaphore(_,_).


recherche(X) :- exemple(X,DRS), rechercher_anaphore(DRS,[]).
