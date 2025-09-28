% some frequently used predicates
mymember(X,[X|_]).
mymember(X,[_|T]) :- mymember(X, T).
conc([], L, L).
conc([H|T], L, [H|T1]) :- conc(T, L, T1).
del(X, [X|T], T).
del(X, [H|T], [H|T1]) :- del(X, T, T1).
insert(X, L1, L2) :- del(X, L2, L1).
mypermutation([],[]).
mypermutation([H|T], P) :- mypermutation(T,T1), insert(H,T1,P).
sublist([],[]).
sublist(L, S) :- conc(_, L2, L), conc(S,_,L2).
% 3.3
evenlength([]).
evenlength([_, _|T]) :- evenlength(T).
oddlength([_]).
oddlength([_, _|T]) :- oddlength(T).
% 3.4
reverse([], []).
reverse([H|T], R) :- reverse(T, T1), conc(T1, [H], R).
% 3.5
palindrome(L) :- reverse(L, L).
% 3.6
shift([H|T], L) :- conc(T, [H], L).
% 3.7
means(0, zero).
means(1, one).
means(2, two).
means(3, three).
means(4, four).
means(5, five).
means(6, six).
means(7, seven).
means(8, eight).
means(9, nine).
translate([],[]). %very important step
translate([H|T], [X|T1]) :- means(H,X), translate(T,T1).
% 3.8
subset([],[]).
subset([H|T], [H|S]) :- subset(T, S).
subset([_|T], S) :- subset(T,S). %allows to check for subset of tail of list if first elements in the lists dont match
% 3.9 
dividelist([], [], []).
dividelist([X], [X], []).
dividelist([X,Y|T],[X|L1],[Y|L2]) :- dividelist(T, L1, L2).
% 3.10 
% 3.11

% Sample Qpaper
mylast(X,L) :- conc(_,[X],L).
myfirst(X,[X|_]).
mytwice([X], [X,X]).
mytwice([H1|T1],[H1,H1|T2]) :- mytwice(T1, T2).