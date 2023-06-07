% TRADUCTION AU FORMAT TPTP

fol_to_tptp(forall(X,[Y]),R) :-
    fol_to_tptp(Y,R1),
    format(atom(R), '!~w:~w', [X, R1]), !.
fol_to_tptp(exist(X,[Y]),R) :-
    fol_to_tptp(Y,R1),
    format(atom(R), '?~w:~w', [X, R1]), !.
fol_to_tptp(and(F1,F2),R) :-
    fol_to_tptp(F1,R1),
    fol_to_tptp(F2,R2),
    format(atom(R), '~w & ~w', [R1,R2]), !.
fol_to_tptp(or(F1,F2),R) :-
    fol_to_tptp(F1,R1),
    fol_to_tptp(F2,R2),
    format(atom(R), '~w | ~w', [R1,R2]), !.
fol_to_tptp(imp(F1,F2),R) :-
    fol_to_tptp(F1,R1),
    fol_to_tptp(F2,R2),
    format(atom(R), '~w => ~w', [R1,R2]), !.
fol_to_tptp(eq(X,Y),R) :-
    fol_to_tptp(X,R1),
    fol_to_tptp(Y,R2),
    format(atom(R), '~w = ~w', [R1, R2]), !.
fol_to_tptp(not(F),R) :-
    fol_to_tptp(F,R1),
    format(atom(R), '~c(~w)', [126,R1]), !.
fol_to_tptp(F,R) :-
    format(atom(R), '~w', [F]), !.
 

trad_tptp(X,R) :-
    trad_fol_v2(X,R1),
    fol_to_tptp(R1,R),
    format('~nLa traduction au format tptp est : ~n ~p. ~n',[R]).
