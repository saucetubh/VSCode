%Q1
myack(X, Y, Z) :- a(X,Y,Z).
a(0,Y,Y).
a(X,0,Z) :- X>0, X1 is X-1, a(X1, 1, Z).
a(X,Y,Z) :- X>0, Y>0, X1 is X-1, Y1 is Y-1, a(X,Y1,Z1), a(X1, Z1, Z).

%Q2
mysize([_], 1).
mysize([_|T],X) :- mysize(T,X1), X is X1+1. 
    %X1 is X-1 wont work, order also matters, smth about variables in rhs being instantiated
mylisttonum([X], X).
mylisttonum([H|T], N) :- mysize([H|T], X), mylisttonum(T, N1), N is (N1 + H*(10**(X-1))). 

%Q3
isnum(1).
isnum(2).
isnum(3).
isnum(4).
uniq(R1, R2, R3, R4) :- isnum(R1),isnum(R2),isnum(R3),isnum(R4),R1 =\= R2, R1 =\= R3, R1 =\= R4, R2 =\= R3, R2 =\= R4, R3 =\= R4.
mysudoku(R11, R12, R13, R14, R21, R22, R23, R24, R31, R32, R33, R34, R41, R42, R43, R44) :- uniq(R11, R12, R13, R14), 
                                                                                            uniq(R21, R22, R23, R24),
                                                                                            uniq(R31, R32, R33, R34),
                                                                                            uniq(R41, R42, R43, R44),
                                                                                            uniq(R11, R21, R31, R41), 
                                                                                            uniq(R12, R22, R32, R42),
                                                                                            uniq(R13, R23, R33, R43),
                                                                                            uniq(R14, R24, R34, R44),
                                                                                            uniq(R11, R12, R21, R22), 
                                                                                            uniq(R13, R14, R23, R24),
                                                                                            uniq(R31, R32, R41, R42),
                                                                                            uniq(R33, R34, R43, R44).