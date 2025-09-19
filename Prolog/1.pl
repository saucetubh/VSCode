parent(john, mary). %facts
parent(mary, bob). 

grandparent(X, Y) :- parent(X, Z), parent(Z, Y). %rule

%clause has the following structure: Head :- Body.
%after making changes, you have to load the file again in the terminal

%john, mary, bob, parent, grandparent are atoms
%X, Y, Z are variables. 
%parent and grandparent are functors 
%john, mary, bob are arguments 
%There are operators, for example, :- is called the neck operator
%comma , is called the conjunction operator
%period . is called the full stop operator
