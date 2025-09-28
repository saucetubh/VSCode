%member is a predefined predicate in prolog
%member(X, List) is true if X is an element of List
%we will try defining it ourselves

mymember(X, [X|_]).
mymember(X, [_|T]) :- mymember(X, T).

%append is a predefined predicate in prolog
%append(l1, l2, L) concatenates l1 and l2 into one list L

myappend([], L, L).
myappend([H|T], L, [H|R]) :- myappend(T, L, R). 

%defining another predicate that checks if two elements are next to each other in a list

next_to(X,Y,L) :- myappend(_, [X,Y|_], L); myappend(_, [Y,X|_], L).

mydelete(X, [X|T], T).
mydelete(X, [H|T1], [H|T2]) :- mydelete(X, T1, T2). 

/*
mydelete(X, [_|T1], [_|T2]) :- mydelete(X, T1, T2) //this doesnt work properly
*/

myadd(X, L1, L2) :- myappend(L1, [X], L2). %adds in the end of the list

add1(X,L,[X|L]). %adds in the beginning of the list


