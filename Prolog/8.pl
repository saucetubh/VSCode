len([], 0).
len([_|T], N) :- len(T, M), N is M+1.

max(X,Y,X) :- X > Y.
max(X,Y,Y) :- Y > X.

maxlist([X], X).
maxlist([H|T], Max) :- maxlist(T, M1), max(H,M1, Max).

sumlist([],0).
sumlist([H|T], Sum) :- sumlist(T, Sum1), Sum is H + Sum1.

subsum([], 0, []).
subsum([H|T1], Sum, [H|T2]) :- subsum(T1, Sum1, T2), Sum is Sum1 + H.
subsum([_|T], Sum, S) :- subsum(T, Sum, S). 