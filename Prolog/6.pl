%3.1
conc([], L, L).
conc([H1|T1], L, [H1|T2]) :- conc(T1, L, T2).

%Goal to delete the last three elements from a list L, producing L1
%The goal uses the fact that L = L1 + [three elements]
%so my goal i.e query would be this conc(L1, [_, _, _], L).

%Predicate to delete the last three elements from a list
%delete_last_three(List, Result) - removes last 3 elements from List, giving Result
%delete3(L, L1) :- conc(L1, [_, _, _], L).
%conc([_,_,_], L1, L). This query to remove first three elements

%3.2
last1(Item, List) :- conc(_, [Item], List).

last2(Item, [_,Item]).
last2(Item, [_|T]) :- last2(Item, T). 

%sublist
sublist(S, L) :- conc(L1, _, L), conc(_,S,L1).

%insert, can also be defined using the delete predicate(refer to book)
insert(X, L, R) :- conc(L1, L2, L), conc(L1, [X], L3), conc(L3, L2, R).

%Permutation 
mypermutation([], []).
mypermutation([H|T], P) :-  permutation(T,T1), insert(H, T1, P).