/*****************************************
Report 5 
EECS 3401 Fall 2016

Dominik Sobota 213644935
Michael Mierzwa 213550702

report_1.pl

Task 2.1
***************************************/

%Frame Figure: The parent class
figure(type_of, type_of).


/*==========================================================*/

%Frame four_sided_polygon class

four_sided_polygon(type_of, figure).
four_sided_polygon(boundary_length, sum_of_side_lengths).
four_sided_polygon(area, four_sided_area).
four_sided_polygon(side_count, 4).
													%rectangle
four_sided_area([Bot,Left,Top,_], Height, A) :- (Height = Left, A is Bot * Height, !;
													%parallelogram
													(Bot = Top, A is Bot * Height, !;
													%trapazoid
													C is ((Top + Bot)/2), A is C * Height, !)).
sum_of_side_lengths([A,B,C,D], Sum) :- Sum is A + B + C + D.

/*==========================================================*/

%Frame trapezoid class
trapezoid(type_of, four_sided_polygon).

/*************/

%Frame parallelogram class
parallelogram(type_of, four_sided_polygon).

/*************/

%Frame rectangle class
rectangle(type_of, parallelogram).

/*==========================================================*/

%Frame regular_polygon class

regular_polygon(type_of, figure).
regular_polygon(boundary_length, side_length_x_side_count).

side_length_x_side_count(SideLength, SideCount, Result) :- Result is SideLength * SideCount.

/*==========================================================*/

%Frame eq_triangle class
eq_triangle(type_of, regular_polygon).
eq_triangle(area, eq_triangle_area).
eq_triangle(side_count, 3).

eq_triangle_area(SideLength, Area) :- Area is ((sqrt(3)/4) * SideLength^2).

/*************/

%Frame square class
square(type_of, regular_polygon).
square(area, square_area).
square(side_count, 4).

square_area(SideLength ,Area) :- Area is SideLength * SideLength.

/*************/

%Frame pentagon class
pentagon(type_of, regular_polygon).
pentagon(area, pentagon_area).
pentagon(side_count, 5).

pentagon_area(SideLength, Area) :- A is 1/4, B is sqrt(5 * ( 5 + ( sqrt(5) * 2 ))),
									C is SideLength^2, Area is A * B * C.

/*==========================================================
		Instances
==========================================================*/

%Frame trapezoid instance
tra(type_of, trapezoid).
tra(side_length, [4,3,2,3]).
tra(height, 2).

/*************/

%Frame parallelogram instance
par(type_of, parallelogram).
par(side_length, [4,3,4,3]).
par(height,2).

/*************/

%Frame rectangle instance
rec(type_of, rectangle).
rec(side_length, [4,2,4,2]).
rec(height, 2).

/*************/

%Frame eq_triangle instance
eqt(instance_of, eq_triangle).
eqt(side_length, 3).

/*************/

%Frame square instance
squ(instance_of, square).
squ(side_length, 3).


/*************/

%Frame pentagon instance
pen(instance_of, pentagon).
pen(side_length, 3).

/***********************
Predicates
***********************/


side_count(Thing, SideCount) :- superParent(Thing, side_count, Parent), Query =.. [Parent, side_count, SideCount],
								Query,!.


boundary_length(Thing, Length) :- Side =..[Thing, side_length, SideLength], Side,
								superParent(Thing, boundary_length, Parent),
								Bound =.. [Parent,boundary_length,BoundFunc], Bound, 
								(is_list(SideLength), Find =.. [BoundFunc,SideLength,Length], Find
								; 
							%above is for four_sided_polygon, below is for regular_polygon
								side_count(Thing,SideCount), Find =.. [BoundFunc,SideLength,SideCount,Length], 
								Find ),!.
								

%this rule is for all instances of regular_polygon
area(Thing, Area):- Side =.. [Thing, side_length, SideLength], Side
					, parent(Thing,Parent), Query =.. [Parent, area, AreaFunc], Query, 
					Find =.. [AreaFunc, SideLength, Area], Find, !.
%this rule is for all instances of four_sided_polygon
area(Thing, Area):-  Side =.. [Thing, side_length, SideLength], Side, 
					 High =.. [Thing, height, Height], High, 
					 superParent(Thing, area, Parent), Query =.. [Parent, area, AreaFunc], Query,
					 Find =.. [AreaFunc, SideLength, Height,Area], Find, !.

					 
/* HELPER PREDICATES */
					 
%modified version of parent from framesQuery
parent(Frame, ParentFrame) :-
    (Query =.. [Frame, type_of, ParentFrame]
    ;
    Query =.. [Frame, instance_of, ParentFrame]
	),
    Query.

%an implementation of parent that looks for the first parent that has a given attribute
superParent(Frame, Attr, SuperFrame) :- parent(Frame, A), Query =.. [A, Attr, _], (Query, SuperFrame = A; superParent(A,Attr,SuperFrame)), !.
	
%added rule to stop superParent from looking farther than figure	
type_of(type_of,_) :- false.

/*================================================
				Test Cases
==================================================*/
:- begin_tests(e1).

%side_count tests
test(side_tra) :- side_count(tra,4).
test(side_par) :- side_count(par,4).
test(side_rec) :- side_count(rec,4).
test(side_eqt) :- side_count(eqt,3).
test(side_squ) :- side_count(squ,4).
test(side_pen) :- side_count(pen,5).

%boundary_length tests
test(bound_tra) :- boundary_length(tra, 12).
test(bound_par) :- boundary_length(par, 14).
test(bound_rec) :- boundary_length(rec, 12).
test(bound_eqt) :- boundary_length(eqt, 9).
test(bound_squ) :- boundary_length(squ, 12).
test(bound_pen) :- boundary_length(pen, 15).

%area tests
test(area_tra) :- area(tra, 6).
test(area_par) :- area(par, 8).
test(area_rec) :- area(rec, 8).
test(area_eqt) :- area(eqt, 3.8971143170299736).
test(area_squ) :- area(squ, 9).
test(area_pen) :- area(pen, 15.484296605300703).

:- end_tests(e1).


