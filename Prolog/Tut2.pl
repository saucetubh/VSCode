%Q1
%house(color, nationality, pet, drink, smoke) 
%total 5 houses so lets make a list of 5 houses.

/*
next_to(X, Y, list) :- 
    list = [X, Y, _, _, _];
    list = [_, X, Y, _, _];
    list = [_, _, X, Y, _];
    list = [_, _, _, X, Y];
    list = [Y, X, _, _, _];
    list = [_, Y, X, _, _];
    list = [_, _, Y, X, _];
    list = [_, _, _, Y, X].
*/

%recursive method to implement this ->
next_to(X, Y, [X, Y|_]).
next_to(X, Y, [Y, X|_]).
next_to(X, Y, [_|Rest]) :- next_to(X, Y, Rest).

puzzle(Owner, Drinker) :-
    Street = [house(C1, N1, P1, D1, S1), house(C2, N2, P2, D2, S2), house(C3, N3, P3, D3, S3), house(C4, N4, P4, D4, S4), house(C5, N5, P5, D5, S5)], %Street is defined as a variable structure, must start with upper case letter, since if lower case then it is simply an atom.
    member(house(red, englishman, _, _, _), Street),
    member(house(_, spaniard, dog, _, _), Street),
    member(house(green, _, _, coffee, _), Street),
    member(house(_, ukrainian, _, tea, _), Street),
    member(house(_, _, snails, _, winston), Street),
    member(house(yellow, _, _, _, kools), Street),
    member(house(_, japanese, _, _, parliament), Street),
    member(house(_, _, _, orangejuice, luckystrike), Street),
    next_to(house(green,_,_,_,_), house(ivory,_,_,_,_), Street),
    next_to(house(_,_,fox,_,_), house(_,_,_,_,chesterfields), Street),
    next_to(house(_,_,_,_,kools), house(_,_,horse,_,_), Street),
    next_to(house(_,norwegian,_,_,_), house(blue,_,_,_,_), Street),
    N1=norwegian,
    D3=milk,
    member(house(_, Owner, zebra, _, _), Street),
    member(house(_, Drinker, _, water, _), Street).


%Q2
%permutation/2 is a predefined predicate in prolog so we could use it
%greater([1,2,4,2,3,5], [1,2,3,5,4,2]). %true

greater([H1|_], [H2|_]) :- H1 > H2.
greater([H1|T1], [H1|T2]) :- greater(T1, T2).

nhp(N, N1) :-
    permutation(N,N1), %matches N1 with permutations of N
    greater(N1,N). %matches if N1 is greater than N

%this code does not take into consideration if N1 is nhp. It is hp, but not next hp. What to do??


%Q3
