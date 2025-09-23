%Q1
f(1, one).
f(s(1), two).
f(s(s(1)), three).

f(s(s(s(X))), N) :- f(X,N).
%Q2
parent(alice, bob).
parent(bob, carol).
parent(alice, dave).
parent(bob, eve).
parent(frank, eve).
parent(pratham, utkarsh).

predecessor(X, Y) :- parent(X, Y).
predecessor(X, Y) :- parent(X, Z), predecessor(Z, Y).

related(X,Y) :- predecessor(X,Y);predecessor(Y,X);predecessor(Z,X),predecessor(Z,Y);predecessor(X,Z),predecessor(Y,Z).
