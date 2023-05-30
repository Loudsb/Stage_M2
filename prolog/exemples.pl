% EXEMPLES

%Exemple 1 facile
exemple(1,drs([x,y],[man(x),enter(x),smiled(y),eq(y,x)])).

%Exemple 2 implication
%Si un fermier possède un âne, il le bât.
%exist(x),exist(y),impl(and(fermier(x),and(âne(y),and(posseder(x,y),true))),
exemple(2,drs([],[imp_drs(drs([x,y],[fermier(x),âne(y),possede(x,y)]),drs([u,v],[eq(u,x),eq(v,y),battre(u,v)]))])).

%Exemple 3 négation
exemple(3,drs([],[non(drs([x,y],[man(x),enter(x),smiled(y),eq(y,x)]))])).

%Exemple 4 négation
%Pierre ne connait aucune fille
exemple(4,drs([x],[pierre(x),non(drs([y],[fille(y),connait(x,y)]))])).

%Exemple 5 implication
exemple(5,drs([x],[pierre(x),imp_drs(drs([x,y],[fermier(x),âne(y),possede(x,y)]),drs([u,v],[eq(u,x),eq(v,y),battre(u,v)]))])).
