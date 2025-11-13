%Q1
conc([], L, L).
conc([H|T], L, [H|R]) :- conc(T, L, R).
mysubset([],[]).
mysubset(S, L) :- conc(_, S, L2), conc(L2, _, L).
mysubset4(X1, X2, X3, X4, S) :- mysubset(X1, S), mysubset(X2, S), mysubset(X3, S), mysubset(X4, S).
%this implementation is actually sublist, not subset, they are different. In one, order matters, in the other it doesnt.
%Q3
myfib(0, 1).
myfib(1, 2).
myfib(X, Y) :- Y1 is Y-1, Y2 is Y-2, myfib(X1, Y1), myfib(X2, Y2), X is X1 + X2.
    %assumes Query will always give a value for Y

%Q4
mymerge(L,[],L).
mymerge([], L, L).
mymerge([H1|T1], [H2|T2], [H2|T3]) :- H1 > H2, mymerge(T2, [H1|T1], T3).
mymerge([H1|T1], [H2|T2], [H1|T3]) :- H1 < H2, mymerge(T1, [H2|T2], T3).