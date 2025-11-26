%Q1
mydescendant(X,Y) :- parent(Y,X).
mydescendant(X,Y) :- parent(W,X), mydescendant(W,Y).

%Q4
mymember(X,[X|_]).
mymember(X,[_|T]) :- mymember(X,T).
mysubset([],[]).
mysubset([H|T1],[H|T2]) :- mysubset(T1, T2).
mysubset(S,[_|T]) :- mysubset(S,T).
conc([], L, L).
conc([H|T], L, [H|T1]) :- conc(T, L, T1).
mydelete(H, [H|T], T).
mydelete(X, [H|T], [H|T1]) :- mydelete(X, T, T1).
insert(X,L1,L2) :- mydelete(X,L2,L1).
mypermutation([],[]).
mypermutation([H|T],P) :- mypermutation(T, T1), insert(H,T1,P).

mylistpartition(A,B,C) :-
    mysubset(B,A),
    mysubset(C,A),
    conc(B,C,L1),
    mypermutation(A,L1).

%Q5
mydelete2(H, [H|T], T).
mydelete2(X, [H|T], [H|T1]) :- X \= H, mydelete(X, T, T1).
insert2(X,L1,L2) :- mydelete2(X,L2,L1).
mypermutation2([],[]).
mypermutation2([H|T],P) :- mypermutation2(T, T1), insert2(H,T1,P).

mysetpartition(A,B,C) :-
    mysubset(B,A),
    mysubset(C,A),
    conc(B,C,L1),
    mypermutation2(A,L1).

