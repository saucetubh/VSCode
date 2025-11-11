conc([], L, L).
conc([H|T], L, [H|T1]) :- conc(T, L, T1).

substring([],[]).
substring(L,S) :- conc(L1,_,L), conc(_,S,L1).

mymem(H,[H|_]).
mymem(X,[_|T]) :- mymem(X,T).

% part a
parent(_,_).
mydescendant(X,Y) :- parent(Y,Z), mydescendant(X,Z).
%this is incorrect implementation, fix it

% part b
mymember(H,[H|_],1).
mymember(X,[_|T],N) :- mymember(X,T,N1), N is N1 + 1. 
%this is incorrect implementation, fix it

% part c 
mydelete(H, [H|T], T).
mydelete(X, [H|T], [H|T1]) :- 
            X \= H, 
            mydelete(X, T, T1).

insert(X,L1,L2) :- mydelete(X,L2,L1).
permutation([],[]).
permutation([H|T],P) :- permutation(T, T1), insert(H,T1,P).

% part d
mynextto(L, X, Y) :- substring(L, [X,Y]).

% part e
greater([H1|_],[H2|_]) :- H1 > H2.
greater([H|T1], [H|T2]) :- greater(T1, T2). 
myhp(N1, N2) :- permutation(N2, N1), greater(N1, N2).

