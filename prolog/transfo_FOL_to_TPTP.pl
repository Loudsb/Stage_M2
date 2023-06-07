% TRADUCTION AU FORMAT TPTP

%prédicat qui prend une liste de variables et qui les mets en lettres majuscules
convert_to_uppercase([], []).
convert_to_uppercase([T|Q],[S|R]) :-
    upcase_atom(T,S),
    convert_to_uppercase(Q,R).

%vérifie que le paramètre donné est bien un prédicat
est_predicat(Term) :- compound(Term), functor(Term, _, Arity), Arity > 0.


fol_to_tptp(forall(X,[Y]),R) :-
    fol_to_tptp(Y,R1),
    convert_to_uppercase(X,X1),
    format(atom(R), '(!~w : (~w))', [X1, R1]), !.
fol_to_tptp(exist(X,[Y]),R) :-
    fol_to_tptp(Y,R1),
    convert_to_uppercase(X,X1),
    format(atom(R), '(?~w : (~w))', [X1, R1]), !.
fol_to_tptp(and(F1,F2),R) :-
    fol_to_tptp(F1,R1),
    fol_to_tptp(F2,R2),
    format(atom(R), '(~w & ~w)', [R1,R2]), !.
fol_to_tptp(or(F1,F2),R) :-
    fol_to_tptp(F1,R1),
    fol_to_tptp(F2,R2),
    format(atom(R), '(~w | ~w)', [R1,R2]), !.
fol_to_tptp(imp(F1,F2),R) :-
    fol_to_tptp(F1,R1),
    fol_to_tptp(F2,R2),
    format(atom(R), '(~w => ~w)', [R1,R2]), !.
fol_to_tptp(eq(X,Y),R) :-
    fol_to_tptp(X,R1),
    fol_to_tptp(Y,R2),
    format(atom(R), '(~w = ~w)', [R1, R2]), !.
fol_to_tptp(not(F),R) :-
    fol_to_tptp(F,R1),
    format(atom(R), '~c(~w)', [126,R1]), !.
fol_to_tptp(F,R) :-
    atom(F), %si c'est un atom
    upcase_atom(F,U),
    format(atom(R), '~w', [U]), !.
fol_to_tptp(F,R) :-
    est_predicat(F), % si c'est un prédicat
    functor(F, Foncteur, Arity),
    functor(R, Foncteur, Arity),
    fol_to_tptp_params(F, R, Arity),
    !.

% Règle pour transformer les paramètres en majuscules
fol_to_tptp_params(_, _, 0). %tous les paramètres ont été traités
fol_to_tptp_params(F, R, N) :-
    N > 0, %il reste des paramètres à traiter
    arg(N, F, Parametre), %prend le N-ème paramètre du prédicat et l'assigne à la variable Parametre
    arg(N, R, ParametreMajuscule), %prend le N-ème paramètre du résultat et l'assigne à la variable ParametreMajuscule
    upcase_atom(Parametre, ParametreMajuscule),
    N1 is N - 1,
    fol_to_tptp_params(F, R, N1).

trad_tptp(X,R) :-
    trad_fol_v2(X,R1),
    fol_to_tptp(R1,R),
    format('~nLa traduction au format tptp est : ~n ~p. ~n',[R]).
