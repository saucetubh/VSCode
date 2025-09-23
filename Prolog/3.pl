%matching i.e doing for example point(X,Y)=point(2,3). gives X=2 and Y=3
%however doing point(x,Y)=point(2,3). gives false x isnt a vairable it is an atom

%point(X,Y).
%seg(point(X1,Y1), point(X2, Y2)).
%vertical(seg(point(X1, Y1), point(X1, Y2))).
%horizontal(seg(point(X1, Y1), point(X2, Y1))).
%rectangle(point(X1, Y1), point(X2, Y2), point(X3, Y3), point(X4, Y4)).

%let rectangle be defined on points
rectangle(P1, P2, P3, P4).
regular(rectangle(point(X1,Y1), point(X1, Y2), point(X2, Y2), point(X2, Y1))).