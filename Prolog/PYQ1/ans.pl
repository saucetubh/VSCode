%Q1
conc([],L,L).
conc([H1|T1], L, [H1|T2]) :- conc(T1,L,T2).
myreverse([],[]).
myreverse([H1|T1], L) :- myreverse(T1, T2), conc(T2, [H1], L).

%Q3
sublist([],[]).
sublist(L,S) :- conc(L1,_,L),conc(_,S,L1).
    %order of clauses here is important

%Q4
num(0).
num(1).
num(2).
num(3).
num(4).
num(5).
num(6).
num(7).
num(8).
num(9).
triplet(X,Y,Z) :- num(X), num(Y), num(Z), X=\=Y, X=\=Z, Y=\=Z, Z=\=0, X/Z =:= ((10*X)+Y)/((10*Y)+Z).

%Q5
pow(_,0,[]).
pow(X,N,L) :- N>0, X1 is X**N, N1 is N-1, pow(X,N1,L1), conc(L1,[X1],L).
mymerge(L,[],L).
mymerge([],L,L).
mymerge([H|T1],[H|T2],[H|T3]) :- mymerge(T1, T2, T3).
mymerge([H1|T1], [H2|T2], [H1|T3]) :- H1<H2, mymerge(T1, [H2|T2], T3).
mymerge([H1|T1], [H2|T2], [H2|T3]) :- H2<H1, mymerge([H1|T1], T2, T3).
take([H|_],1,[H]).
take([H|T],N,L1) :- N>0, N1 is N-1,conc([H],L2,L1),take(T,N1,L2).
powers([X],N,L) :- pow(X,N,L).
powers([H|T],N,L) :- 
    pow(H,N,L1),
    powers(T,N,L2),
    mymerge(L1,L2,L3),
    take(L3,N,L).
