%Q1
teaches(wallen, logic).
teaches(wallen, 'proof theory').
teaches(srinivasan, 'logic programming').
teaches(hoare, 'software eng').
teaches(jones, hardware).

takes(adams, logic, a).
takes(adams, 'logic prog', b).
takes(arnold, 'logic prog', b).
takes(arnold, 'proof theory', c).
takes(arnold, 'software eng', a).
takes(milton, 'software eng', a).

%Q2
grade(G) :- takes(_, _, G).
study_under(S, T) :- takes(S, C, _), teaches(T, C).

%Q3
wants(adams, semantics).
wants(adams, 'proofs and types').
wants(arnold, semantics).
wants(arnold, 'proofs and types').
wants(milton, requirements).

avail(adams, semantics).
avail(arnold, 'proofs and types').
avail(milton, semantics).
avail(milton, 'proofs and types').

union(S, C) :- wants(S,C);avail(S,C).
intersection(S,C) :- wants(S,C),avail(S,C).
diff(S,C) :- wants(S,C), \+ avail(S,C).

%Q4
below(E, B) :- employee(E, B).
below(E, B) :- employee(E, B1), below(B1, B).

%Q8
gcd(X, X ,X).
gcd(X,Y,Z) :- X<Y, Y1 is Y-X, gcd(X,Y1,Z).
gcd(X,Y,Z) :- X>Y, gcd(Y,X,Z).

%Q9
f(0,1).
f(N,X) :- N>0, N1 is N-1, f(N1, X1), X is N*X1.

%Q10
fib(0, 0).
fib(1, 1).
fib(N, M) :- N1 is N-1, N2 is N-2, fib(N1,M1), fib(N2,M2), M is M1+M2.

%Q11
mydelete(X,[X|T],T).
mydelete(X,[H|T],[H|T1]) :- X \= H, mydelete(X,T,T1).

%Q12
greater([H1|_], [H2|_]) :- H1 < H2.
greater([H|T1], [H|T2]) :- greater(T1, T2).
mdel(X,[X|T], T).
mdel(X,[H|T],[H|T1]) :- mdel(X, T, T1).
mins(X, L, L1) :- mdel(X, L1, L).
mypermutation([],[]).
mypermutation([H|T], L) :- mypermutation(T, T1), mins(H, T1, L).
hp(N1, N2) :- mypermutation(N1, N2), greater(N1, N2). 
    %order of clauses is important here
nhp(N1, N2) :- hp(N1, N2), \+ (hp(N1, N3),greater(N3, N2)).
    %space after \+ is important, idk why

%Q13
mymember(X,[X|_]).
mymember(X,[_|T]) :- mymember(X,T).
mysubset([], []).
mysubset([H|T], L) :- mymember(H,L), mysubset(T, L).
mysubset2([],[]).
mysubset2([H|T1], [H|T2]) :- mysubset2(T1, T2).
mysubset2(S, [_|T]) :- mysubset(S,T).
myequal(L1,L2) :- mysubset(L1, L2), mysubset(L2, L1). 
powerset(S, S1) :- mysubset(S, S1).

%fix this