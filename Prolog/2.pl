%lists are denoted by square brackets []

member_my(X, [X|_]).

%X is a member of a list if X is the head of the list
%member is a predefined predicate in prolog. aka member/2, where 2 represents the number of arguments
%If i type a query using member in prolog it will use the predefined predicate not the one i defined here, so i will name my functor something else, not member
%_ is an anonymous variable, it can match anything but we don not care what it is

member_my(X, [_|T]) :- member_my(X, T). 

%T is a variable representing the tail of the list, i.e it is a list itself
%X is a member of a list if X is a member of the tail of the list
%member is a functor (a type of atom)
%so essentialy, in line 5, we recursively check if X is in the list. First we define the base case (a rule) in line 3, then we define the recursive case in line 5
%if i put a query in the terminal like ?- member(b, [a, b, c]). it will use the rule to recursively check if b is in the list [a, b, c]
%it will first check if b is the head of the list (it is not), then it will check if b is in the tail of the list [b, c]. it will find that b is the head of this list and return true.

concat([], L, L). 

%base case
%concatenation of an empty list with L is L. L is a variable representing a list

concat([H|T], L2, [H|R]) :- concat(T, L2, R).

%concatenation of a list whose head is H and tail is T with L2 is a list whose head is H and tail is R, if R is the concatenation of T with L2
%this is recursively appending the head of the first list to the result of concatenating the tail of the first list with the second list
%so if i put a query in the terminal like ?- concat([a, b], [c, d], X). it will use the rule to recursively concatenate the two lists
%it will take the head of the first list (a) and append it to the result of concatenating the tail of the first list ([b]) with the second list ([c, d])
%it will then take the head of the new first list (b) and append it to the result of concatenating the tail of the new first list ([]) with the second list ([c, d])
%it will then reach the base case and return [c, d]. it will then append b to this result to get [b, c, d], and finally append a to this result to get [a, b, c, d].


%THINK RECURSIVELY
