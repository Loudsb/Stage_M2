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
exemple(6,drs([x],[non(pierre(x)),imp_drs(drs([x,y],[fermier(x),âne(y),possede(x,y)]),drs([u,v],[eq(u,ante1),eq(v,ante2),battre(u,v)]))])).
