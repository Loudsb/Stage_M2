% TRADUCTION EN LOGIQUE DU PREMIER ORDRE

trad_exist_fol(Exists,Cond,exist(Exists,Cond)).
trad_forall_fol(Forall,Cond,forall(Forall,Cond)).

%Récupère les variables existentielles
get_exist_vars(exist(X), [X]) :- !.
get_exist_vars(and(F1, F2), L) :-
    get_exist_vars(F1, L1),
    get_exist_vars(F2, L2),
    append(L1, L2, L), !.
get_exist_vars(_, []) :- !.

%Récupère les conditions
get_cond(and(and(exist(_),_),C),[C]).
get_cond(and(exist(_),C),[C]) :- C \= exist(_).
get_cond(and(true,X),R) :- get_cond(X,R).
get_cond(not(X),R) :- get_cond(X,R).
 

drt_to_fol(not(X),not(R)) :- drt_to_fol(X,R), !.
drt_to_fol(imp(X,Y),R) :- 
    get_exist_vars(X,E),
    get_cond(X,C),
    drt_to_fol(Y,R2),
    impl(C,R2,R3),
    trad_forall_fol(E,[R3],R), !.
drt_to_fol( and(true,X),R) :- drt_to_fol(X,R), !.
drt_to_fol(F,R) :-
    get_exist_vars(F, L1),
    get_cond(F,L2),
    trad_exist_fol(L1,L2,R), !.

%Si j'ai la négation j'applique le prédicat sinon je laisse le truc comme il est

negation(not(exist(X,[Y])),forall(X,[R2])) :- 
    negation(Y,R2), !.
negation(not(forall(X,[Y])),exist(X,[R2])) :-
    negation(Y,R2), !.
negation(and(X,Y),or(R1,R2)) :-
    negation(X,R1),
    negation(Y,R2), !.
negation(or(X,Y),and(R1,R2)) :-
    negation(X,R1),
    negation(Y,R2), !.
negation(X,not(X)) :- !.
negation(not(X),X) :- !.


neg(not(X),R) :-
    negation(not(X),R),
    format('~nAprès application de la négation : ~n ~p. ~n',[R]), !.

neg(X,X) :- !.

trad_fol(X,R) :- trad_drs(X,R1), drt_to_fol(R1,R2), format('~nLa traduction en fol est : ~n ~p. ~n',[R2]), neg(R2,R).
