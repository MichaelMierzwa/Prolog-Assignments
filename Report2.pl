/**************************************************************

Report 2
Dominik Sobota 213644935	
Michael Mierzwa 213550702

**************************************************************/
:- op(100,xfy,at).

/* Exercise 1 */

/**********************************************************************
Require: GridLabel is the name of Grid
         Start is the cell from which a path begins
         End is the cell at which a path ends
            End ~= Start
         CutOffTotal the ceiling+1 integer value for a path.

Ensure: Path is a list of cell coordinates such that the total of the
            integers associated with each cell is less than CutOffTotal.
************************************************************************/

findPath(GridLabel, Start, End, CutOffTotal, Path) :-

  /* Obtain grid data -- this enables you to have multiple grids
     defined in your database. */

      grid(GridLabel, RCmax, TenTimesCells)

  /* aPath asserts that Path is a list of cells from Start to End,
     inclusive, in a grid with RCmax rows and columns. */

    , aPath(Start, End, RCmax, Path)

  /* desiredPath asserts that the path Path has an associated integer
     total less than CutOffTotal, where TenTimesCells are the ones
     with ten times the base value of row_index + column_index. */

    , desiredPath(Path, TenTimesCells, CutOffTotal).

/* You are to define the predicates grid, aPath and desiredPath, as specified */

	%defining example grids
	
	grid(onebyone,[1,1],[]).
	grid(twobytwo,[2,2],[[1,2]]).
	grid(threebythree, [3,3], [[2,2],[3,2]]).
	grid(fourbyfour,[4,4],[[2,2],[4,1],[3,2]]).
	
	
	/*
	aPath(Start,Start,[RMax,CMax], []).
	
	aPath(Start, End, [RMax,CMax], Path) :- Start \= End,  append([],[Start], Path), aPath(Start,End, [RMax,CMax], Path, Start).
	
	%Ending Path
	aPath(Start,[RE,CE],[RMax,CMax], Path, [RE,CE]) :- write(Path). 
	%Going up
	aPath(Start,End,[RMax,CMax], Path, [R,C]) :- write(Path). %R > 1, R1 is R - 1, \+ member([R1,C], Path), add_tail(Path, [R1,C], NewPath),  aPath(Start, End, [RMax,CMax], NewPath, [R1,C]). 
	%Going down
	%aPath(Start,End,[RMax,CMax], BeforePath, [R,C]) :- write([R,C]), nl,  R < RMax, R1 is R + 1, \+ member([[R1,C]], BeforePath),  append(BeforePath,[[R1,C]],  Path), write(Path) % aPath(Start, End, [RMax,CMax], Path, [R1,C]). 
	%Going Left
	%aPath(Start,End,[RMax,CMax], BeforePath, [R,C]) :- write(left), nl, C > 1, C1 is C - 1, \+ member([[R,C1]], BeforePath),  append(BeforePath,[[R,C1]],  Path), aPath(Start, End, [RMax,CMax], Path, [R,C1]). 
	%Going Right
	%aPath(Start,End,[RMax,CMax], BeforePath, [R,C]) :- write(right), nl,  C < CMax, C1 is C + 1, \+ member([[R,C1]], BeforePath),  append(BeforePath,[[R,C1]],  Path), aPath(Start, End, [RMax,CMax], Path, [R,C1]). 
	*/
	
	aPath(Start, End, [RMax,CMax], Path) :- Start \= End, validNextStep([RMax,CMax], [], Start), append([],Start, NewPath), write(NewPath),nextStep(Start, [NR,NC]),.
	%write a path that checks if you can move there, if it makes you at the end, if you can move there but not the end then recurse.
	validNextStep([RMax,CMax], Path, [R,C]) :- R > 0, C > 0, R =< RMax, C =< CMax, \+ member([R,C], Path). 
	
	nextStep([R,C],[NR,NC]) :- NC is C, NR is R+1.
	nextStep([R,C],[NR,NC]) :- NC is C, NR is R-1.
	nextStep([R,C],[NR,NC]) :- NC is C +1, NR is R.
	nextStep([R,C],[NR,NC]) :- NC is C-1, NR is R.
	
/***************************************************************

Exersize 2

The predicate patients(Table) defines a Table of patients sitting on a bench left to right order.

There are...
- 5	Patients        (Leila,Adam,Ali,Alice,Farah)
- 5    Blood Groups (A,B,AB,O,AO)
- 5    Ages             (5,9,30,46,60)
- 5    Heights         (40,48,60,65,74)
- 5    Weights         (40,75,96,125,165)

1. The person on the far right is 37 years older than Leila, and is 60 inches tall
2. Leila weighs 56 pounds more than height
3. Alice weighs 75 pounds and is 74 inches tall
4. Ali is type AB and weighs 56 pounds less than Leila
5. The person in the center is 9 years old, is blood type AO and weighs 96 pounds
6. Adam, who is the first, is 65 inches tall, and weighs 100 pounds more than his height
7. The person who is blood type O, is 25 years older than the person to the left of them
8. Farah is 60 years old
9. The person who is blood type A, is 55 years younger than Farah, and 17 inches shorter than Farah
10. The person who is next to the 9 year old but not next to the person who is 65 inches tall, is blood 
type B, and weighs 125 pounds


*****************************************************************/

/*******************FACTS**************************************/
age(5). age(9). age(30). age(46). age(60).
height(40). height(48). height(60). height(65). height(74).
weight(40). weight(75). weight(96). weight(125). weight(165).



patients(FormatTable) :- 

	makepatients(5,Table), %0

	Table = [_,_,_,_,patient(_,_,FRAge, 60,_)],  age(FRAge), age(LeilaAge), FRAge is LeilaAge + 37, %1

	patient('Leila', _,LeilaAge,LeilaH, LeilaW) at Table ,height(LeilaH), weight(LeilaW), LeilaW is LeilaH + 56, %2

	patient('Alice',_,_,74,75) at Table, %3

	patient('Ali','AB',_,_,LeilaH) at Table, %4 ali's weight is equal to Leilas height
 
	Table = [_,_,patient(_,'AO',9,_,96),_,_], %5

	Table = [patient('Adam',_,_,AdamH,AdamW),_,_,_,_], height(AdamH), weight(AdamW), AdamW is AdamH + 100,%6

	sublist( [patient(_, _, 5, _, _), patient(_,'O', 30, _, _)], Table), %7

	patient('Farah',_,60,FarahH,_) at Table, %8

	patient(_,'A',5, AH,_) at Table, height(FarahH), height(AH), AH is FarahH + 17,%9

	%FOR RULE 10, the 9 year old is the centre, so the person next to them is in rather position 2 or 4
	%adam(position 1) is 65 inches tall, so therefore rule 10 applies to the 4th position

	Table = [_,_,_,patient(_,'B',_,_,125),_],

	%formating output of Table

	formatTable(Table, FormatTable), !.

:- begin_tests(e2).
%for the rules instead of leaving many _'s in each test I found it easier to copy the main correct test and only restrict the parts pertaining to the rule.
test(full_table) :- patients([['Adam', 'A', 5, 65, 165], ['Alice', 'O', 30, 74, 75], ['Leila', 'AO', 9, 40, 96], ['Farah', 'B', 60, 48, 125], ['Ali', 'AB', 46, 60, 40]]).
test(wrong_order, [fail]) :- patients([['Alice', 'O', 30, 74, 75], ['Adam', 'A', 5, 65, 165],['Leila', 'AO', 9, 40, 96], ['Farah', 'B', 60, 48, 125], ['Ali', 'AB', 46, 60, 40]]).
test(new_person, [fail]) :- patients([['George', 'A', 5, 65, 165], ['Alice', 'O', 30, 74, 75], ['Leila', 'AO', 9, 40, 96], ['Farah', 'B', 60, 48, 125], ['Ali', 'AB', 46, 60, 40]]).
test(table_too_big,[fail]) :- patients([['Adam', 'A', 5, 65, 165], ['Alice', 'O', 30, 74, 75], ['Leila', 'AO', 9, 40, 96], ['Farah', 'B', 60, 48, 125], ['Ali', 'AB', 46, 60, 40], ['Alice', 'O', 30, 74, 75]]).
test(table_too_small, [fail]) :- patients([['Alice', 'O', 30, 74, 75], ['Leila', 'AO', 9, 40, 96], ['Farah', 'B', 60, 48, 125], ['Ali', 'AB', 46, 60, 40]]).
test(rule1) :- patients([['Adam', 'A', 5, 65, 165], ['Alice', 'O', 30, 74, 75], ['Leila', 'AO', LA, 40, 96], ['Farah', 'B', 60, 48, 125], [_, _, AA, 60, _]]), AA is LA + 37.
test(rule2) :- patients([['Adam', 'A', 5, 65, 165], ['Alice', 'O', 30, 74, 75], ['Leila', _, _, LH, LW], ['Farah', 'B', 60, 48, 125], ['Ali', 'AB', 46, 60, 40]]), LW is LH + 56.
test(rule3) :- patients([['Adam', 'A', 5, 65, 165], ['Alice', _, _, 74, 75], ['Leila', 'AO', 9, 40, 96], ['Farah', 'B', 60, 48, 125], ['Ali', 'AB', 46, 60, 40]]).
test(rule4) :- patients([['Adam', 'A', 5, 65, 165], ['Alice', 'O', 30, 74, 75], ['Leila', 'AO', 9, W, 96], ['Farah', 'B', 60, 48, 125], ['Ali', 'AB', _, _, W]]).
test(rule5) :- patients([['Adam', 'A', 5, 65, 165], ['Alice', 'O', 30, 74, 75], [_, 'AO', 9, _, 96], ['Farah', 'B', 60, 48, 125], ['Ali', 'AB', 46, 60, 40]]).
test(rule6) :- patients([['Adam', _, _, H, W], ['Alice', 'O', 30, 74, 75], ['Leila', 'AO', 9, 40, 96], ['Farah', 'B', 60, 48, 125], ['Ali', 'AB', 46, 60, 40]]), W is H + 100.
test(rule7) :- patients([[_, _, A1, _, _], [_, 'O', A2, _, _], ['Leila', 'AO', 9, 40, 96], ['Farah', 'B', 60, 48, 125], ['Ali', 'AB', 46, 60, 40]]), A1 is 5, A2 is 30.
test(rule8) :- patients([['Adam', 'A', 5, 65, 165], ['Alice', 'O', 30, 74, 75], ['Leila', 'AO', 9, 40, 96], ['Farah', _, A, 48, _], ['Ali', 'AB', 46, 60, 40]]), A is 60.
test(rule9) :- patients([[_, 'A', 5, AH, _], ['Alice', 'O', 30, 74, 75], ['Leila', 'AO', 9, 40, 96], ['Farah', 'B', 60, FarahH, 125], ['Ali', 'AB', 46, 60, 40]]), AH is FarahH + 17.
test(rule10) :- patients([['Adam', 'A', 5, 65, 165], ['Alice', 'O', 30, 74, 75], ['Leila', 'AO', 9, 40, 96], [_, 'B',_,_, 125], ['Ali', 'AB', 46, 60, 40]]).

:- end_tests(e2).

/*********************Definitions*********************************/


makepatients(0,[]).
makepatients(N,[patient(_, _, _, _, _)|Table]) 
		:- N>0, N1 is N - 1, makepatients(N1,Table).  

formatTable([],[]).
formatTable([X|R], [[Name, BG, Age, Height, Weight]| R2]) :- X = patient(Name,BG,Age,Height,Weight),  formatTable(R, R2).
		
sublist(S, L) :- add(S, _, L).
sublist(S, [_ | T]) :- sublist(S, T).

add([], L, L).
add([X | R], Y, [X | T]) :- add(R,Y,T).

add_tail([],X,[X]).
add_tail([H|T],X,[H|L]):-add_tail(T,X,L).

X at [X | _].
X at [_ | R]  :-  X at R.
