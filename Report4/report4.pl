:- [f12_3_Astar].
:- [f13_10_RTA].
:- ['set_print_options.pl'].

/******************************************************************************/
% Four fixed example calls.

t1(Path) :- run(astar, h_e, 6, 1-1, 6-6, Path).
t2(Path) :- run(astar, h_m, 6, 1-1, 6-6, Path).
t3(Path) :- run(rta,   h_e, 6, 1-1, 6-6, Path).
t4(Path) :- run(rta,   h_m, 6, 1-1, 6-6, Path).

/*******************************************************************************
The run predicate is the start of all test cases.

Example call for general case.
  run( astar,    % The functor for the predicate to call
       h_e,      % The functor for the heuristic function to be used
       Grid_size % Number of rows & columns for square grid
       Start,    % The start state for the robot
       Goal,     % The goal state
       Path      % The returned search path
       ).
*/

run(Algorithm, H_functor, Grid_size, Start, Goal, Path) :-
    ( retract(grid_size(_)),
        retractall(s(_,_,_)),
        assertz(grid_size(Grid_size)),
        createEdges(Grid_size), !
    ;
      assertz(grid_size(Grid_size)) , createEdges(Grid_size)
    ) ,

    ( retract(h_functor(_)) ; true ),
    asserta(h_functor(H_functor)),
	
    ( retract(goal(_)) ; true ),
    asserta(goal(Goal)), ! ,

    Predicate =.. [Algorithm, Start, Path],
    call(Predicate), !.  	% New (added a cut to remove choice points)


% Add your predicates after this comment.


/**************************************
createEdges(GridSize) asserts all the edge predicates, s(State,NewState,Cost),
between the locations in a square grid of size GridSize x GridSize that A* and RTA* uses

***************************************/

%difficulty is (Column^3 + Row^3) MOD 17 and is implemented as follows
difficulty(RowNumber, ColNumber, Cost) :-  Row is RowNumber ^ 3, Col is ColNumber ^ 3, Sum is Row + Col, Cost is mod(Sum, 17). 

%one arguement version simply instantiates where to start creating the sucecsor functions
createEdges(GridSize) :- createEdges(GridSize, 1, 1), !.

%top left corner, assert edges from corner to the cell below and to the right of State
createEdges(GridSize, CurrentRow, CurrentCol) :- 
																			
																			Right is CurrentCol + 1, Below is CurrentRow + 1, 
																			CurrentRow = 1, CurrentCol = 1, 
																			%write(CurrentRow - CurrentCol), nl, 
													
																			%from the top left corner you can move down
																			difficulty(Below, CurrentCol, BelowCost), 
																			assertz(s(CurrentRow-CurrentCol, Below-CurrentCol, BelowCost)),
																			
																			%from the top left corner you can move right
																			difficulty(CurrentRow, Right, RightCost), 
																			assertz(s(CurrentRow-CurrentCol,CurrentRow-Right, RightCost)),
																			
																			
																			%shift current node to right
																			createEdges(GridSize, CurrentRow, Right), !.
																	
																	     
																		 
%Top Row, assert edges from any non corner cell in top row to its left, right and below the State																		 
createEdges(GridSize, CurrentRow, CurrentCol) :- 
																		
																			Right is CurrentCol + 1, Below is CurrentRow + 1, Left is CurrentCol - 1, 
																			CurrentRow = 1, CurrentCol > 1, CurrentCol < GridSize,
																			%write(CurrentRow - CurrentCol), nl, 
																			
																			%from the top row you can move down
																			difficulty(Below, CurrentCol, BelowCost),
																			assertz(s(CurrentRow-CurrentCol, Below-CurrentCol, BelowCost)),
																			
																			%from the top row you can move right
																			difficulty(CurrentRow, Right, RightCost),
																			assertz(s(CurrentRow-CurrentCol,CurrentRow-Right, RightCost)),
																			
																			%from the top row you can move left
																			difficulty(CurrentRow, Left, LeftCost),
																			assertz(s(CurrentRow-CurrentCol, CurrentRow-Left, LeftCost)), 
																			
																			%shift currrent node to right
																			createEdges(GridSize, CurrentRow, Right), !.
					
%top right corner, edges to the left and below					
createEdges(GridSize, CurrentRow, CurrentCol) :- 
																			
																			Below is CurrentRow + 1, Left is CurrentCol - 1, 
																			CurrentRow = 1, CurrentCol = GridSize, 
																			%write(CurrentRow - CurrentCol), nl, 
																	 
																			%from the top right corner you can move down
																			difficulty(Below, CurrentCol, BelowCost),
																			assertz(s(CurrentRow-CurrentCol, Below-CurrentCol, BelowCost)),
																			
																			%from the top right corner you can move left
																			difficulty(CurrentRow, Left, LeftCost),
																			assertz(s(CurrentRow-CurrentCol, CurrentRow-Left, LeftCost)), 
																		
																			%shift current node to next row, starting from first column
																			createEdges(GridSize, Below, 1), !.

 %first column, not first or last row, edges above, below, and right																			
createEdges(GridSize, CurrentRow, CurrentCol) :- 
																			
																			Right is CurrentCol + 1, Below is CurrentRow + 1, Above is CurrentRow - 1, 
																			CurrentCol = 1, CurrentRow > 1, CurrentRow < GridSize,
																			%write(CurrentRow - CurrentCol), nl,
																			
																			%from the left edge you can move up
																			difficulty(Above, CurrentCol, AboveCost), 
																			assertz(s(CurrentRow-CurrentCol, Above-CurrentCol, AboveCost)),
																			
																			%from the left edge you can move down
																			difficulty(Below, CurrentCol, BelowCost),
																			assertz(s(CurrentRow-CurrentCol, Below-CurrentCol, BelowCost)),
																			
																			%from the left edge you can move right
																			difficulty(CurrentRow, Right, RightCost), 
																			assertz(s(CurrentRow-CurrentCol,CurrentRow-Right, RightCost)),
																			
																			%shift current node right
																			createEdges(GridSize, CurrentRow, Right), !.


%middle of row and column, edges above,below,left and right														
createEdges(GridSize, CurrentRow, CurrentCol) :- 
																			
																			Right is CurrentCol + 1, Below is CurrentRow + 1, Above is CurrentRow - 1, Left is CurrentCol - 1, 
																			CurrentCol > 1, CurrentCol < GridSize, CurrentRow > 1, CurrentRow < GridSize,
																			%write(CurrentRow - CurrentCol), nl, 
																			
																			%from a cell not touching an edge or corner you can move up
																			difficulty(Above, CurrentCol, AboveCost), 
																			assertz(s(CurrentRow-CurrentCol, Above-CurrentCol, AboveCost)),
																			
																			%from a cell not touching an edge or corner you can move down
																			difficulty(Below, CurrentCol, BelowCost),
																			assertz(s(CurrentRow-CurrentCol, Below-CurrentCol, BelowCost)),
																			
																			%from a cell not touching an edge or corner you can move right
																			difficulty(CurrentRow, Right, RightCost), 
																			assertz(s(CurrentRow-CurrentCol,CurrentRow-Right, RightCost)),
																			
																			%from a cell not touching an edge or corner you can move left
																			difficulty(CurrentRow, Left, LeftCost),
																			assertz(s(CurrentRow-CurrentCol, CurrentRow-Left, LeftCost)), 
																			
																			%shift current node right
																			
																			createEdges(GridSize, CurrentRow, Right),!.
																	  
																	  
%last column, not first or last row, edges above,below,left																	  
createEdges(GridSize, CurrentRow, CurrentCol) :- 
																			
																			Below is CurrentRow + 1, Above is CurrentRow - 1, Left is CurrentCol - 1, 
																			CurrentCol = GridSize, CurrentRow > 1, CurrentRow < GridSize,
																			%write(CurrentRow - CurrentCol), nl, 
																			
																			%from the right edge you can move up
																			difficulty(Above, CurrentCol, AboveCost), 
																			assertz(s(CurrentRow-CurrentCol, Above-CurrentCol, AboveCost)),
																			
																			%from the right edge you can move down
																			difficulty(Below, CurrentCol, BelowCost),
																			assertz(s(CurrentRow-CurrentCol, Below-CurrentCol, BelowCost)),
																			
																			%from the right edge you can move left
																			difficulty(CurrentRow, Left, LeftCost),
																			assertz(s(CurrentRow-CurrentCol, CurrentRow-Left, LeftCost)), 
															
																			%shift current node to next row, starting from first column
																			createEdges(GridSize, Below, 1), !.

%bottom left corner, edges to above and to the right																			
createEdges(GridSize, CurrentRow, CurrentCol) :- 
																			
																			Right is CurrentCol + 1, Above is CurrentRow - 1, 
																			CurrentRow = GridSize, CurrentCol = 1, 
																			%write(CurrentRow - CurrentCol), nl, 																	  
																			
																			%from the bottom left corner you can move up
																			difficulty(Above, CurrentCol, AboveCost), 
																			assertz(s(CurrentRow-CurrentCol, Above-CurrentCol, AboveCost)),
																			
																			%from the bottom left corner you can move right
																			difficulty(CurrentRow, Right, RightCost), 
																			assertz(s(CurrentRow-CurrentCol,CurrentRow-Right, RightCost)),
																			
																			%shift current node right
																			createEdges(GridSize, CurrentRow, Right), !.

%bottom row, not a corner, edges above, left and right																			
createEdges(GridSize, CurrentRow, CurrentCol) :- 
																			
																			Right is CurrentCol + 1, Above is CurrentRow - 1, Left is CurrentCol - 1, 
																			CurrentRow = GridSize, CurrentCol > 1, CurrentCol < GridSize,
																			%write(CurrentRow - CurrentCol), nl, 																	  
																
																			%from the bottom edge you can move up
																			difficulty(Above, CurrentCol, AboveCost), 
																			assertz(s(CurrentRow-CurrentCol, Above-CurrentCol, AboveCost)),
																			
																			%from the bottom edge you can move right
																			difficulty(CurrentRow, Right, RightCost), 
																			assertz(s(CurrentRow-CurrentCol,CurrentRow-Right, RightCost)),
																			
																			%from the bottom edge you can move left
																			difficulty(CurrentRow, Left, LeftCost),
																			assertz(s(CurrentRow-CurrentCol, CurrentRow-Left, LeftCost)), 
																			
																			%shift current node right
																			createEdges(GridSize, CurrentRow, Right),!.


%bottom right corner, edges to the left and above																			
createEdges(GridSize, CurrentRow, CurrentCol) :- 
																			
																			Above is CurrentRow - 1, Left is CurrentCol - 1, 
																			CurrentRow = GridSize, CurrentCol = GridSize, 
																			%write(CurrentRow - CurrentCol), nl, 
																			
																			%from the bottom right corner you can move left
																			difficulty(CurrentRow, Left, LeftCost),
																			assertz(s(CurrentRow-CurrentCol, CurrentRow-Left, LeftCost)), 
																			
																			%from the bottom right corner you can move up
																			difficulty(Above, CurrentCol, AboveCost), 
																			assertz(s(CurrentRow-CurrentCol, Above-CurrentCol, AboveCost)),
																			!.
		
	
/**********************************************************************************************
h_e(State, H) defines the Euclidian distance between the robots location State, and the goal, the answer returned in H

h_m(State, H) defines the Euclidian distance between the robots location State, and the goal, the answer returned in H
**********************************************************************************************/

%h_e is defined as 		
		%sqrt((Column - GoalColumn)^2 + (Row - GoalRow)^2)
h_e(RowNumber-ColNumber, H) :-  goal(GRow-GCol), X is RowNumber - GRow, Y is ColNumber - GCol, X2 is X ^ 2, Y2 is Y ^ 2, 
													   Z is X2 + Y2, H is sqrt(Z). 
									
%h_m is defined as 
		%abs(Column - GoalColumn)	+ 	abs(Row - GoalRow)					
h_m(RowNumber-ColNumber, H) :-  goal(GRow-GCol), X is RowNumber - GRow, Y is ColNumber - GCol, X2 is abs(X), Y2 is abs(Y), 
													   H is X2 + Y2.  																	
																	

									
/****************************************************************************************				
									Test Cases
*****************************************************************************************/
									
:- begin_tests(report4).

%Each test comes in a set of 4, trying each heuristic and search algorithm combination

%simple test
test(simp1) :- run(astar, h_e, 2, 1-1, 2-2, [1-1,1-2,2-2]).
test(simp2) :- run(astar, h_m, 2, 1-1, 2-2, [1-1,1-2,2-2]).
test(simp3) :- run(rta, h_e, 2, 1-1, 2-2, [1-1,1-2,2-2]).
test(simp4) :- run(rta, h_m, 2, 1-1, 2-2, [1-1,1-2,2-2]).
%arbitrary goal (start and goal are same)
test(arbGoal1) :- run(astar, h_e, 2, 2-2, 2-2, [2-2]).
test(arbGoal2) :- run(astar, h_m, 2, 2-2, 2-2, [2-2]).
test(arbGoal3) :- run(rta, h_e, 2, 2-2, 2-2, [2-2]).
test(arbGoal4) :- run(rta, h_m, 2, 2-2, 2-2, [2-2]).

%count tests
test(count1) :- run(astar, h_e, 2, 1-1, 2-2, [1-1,1-2,2-2]), count(4).
test(count2) :- run(astar, h_m, 2, 1-1, 2-2, [1-1,1-2,2-2]), count(4).
%we were not able to implement count for rta (this is outlined in the report)

%test given examples
test(example1) :- t1([1-1,1-2,1-3,2-3,3-3,4-3,4-4,5-4,6-4,6-5,6-6]).
test(example2) :- t2([1-1,2-1,3-1,3-2,3-3,4-3,4-4,4-5,4-6,5-6,6-6]).
test(example3) :- t3([1-1,1-2,1-3,2-3,3-3,3-2,4-2,4-3,4-4,4-5,4-6,5-6,6-6]).
test(example4) :- t4([1-1,1-2,1-3,2-3,3-3,3-2,4-2,4-3,4-4,4-5,4-6,5-6,6-6]).

%5x5 grid, start is 1-5 and the goal is 5-2
test(five_test1) :- run(astar, h_e, 5, 1-5, 5-2, [1-5,2-5,2-4,2-3,3-3,3-2,4-2,5-2]).
test(five_test2) :- run(astar, h_m, 5, 1-5, 5-2, [1-5,1-4,2-4,2-3,3-3,3-2,4-2,5-2]).
test(five_test3) :- run(rta,   h_e, 5, 1-5, 5-2, [1-5,2-5,2-4,2-3,3-3,3-2,4-2,4-3,4-4,5-4,5-5,4-5,3-5,3-4,3-3,3-2,3-3,2-3,2-4,3-4,4-4,4-3,4-2,5-2]).
test(five_test4) :- run(rta,   h_m, 5, 1-5, 5-2, [1-5,1-4,2-4,2-3,3-3,3-2,4-2,4-3,4-4,5-4,5-5,4-5,3-5,3-4,3-3,3-2,4-2,5-2]).

%6x6 grid, start is 1-3 and the goal is 6-5
test(six_test1) :- run(astar, h_e, 6, 1-3, 6-5, [1-3,2-3,3-3,4-3,4-4,5-4,6-4,6-5]).
test(six_test2) :- run(astar, h_m, 6, 1-3, 6-5, [1-3,2-3,3-3,3-4,4-4,5-4,6-4,6-5]).
test(six_test3) :- run(rta, h_e, 6, 1-3, 6-5, [1-3,2-3,3-3,3-2,4-2,4-3,4-4,5-4,6-4,6-5]).
test(six_test4) :- run(rta, h_m, 6, 1-3, 6-5, [1-3,2-3,3-3,3-2,4-2,4-3,4-4,5-4,6-4,6-5]).

%7x7 grid, start is 7-2 and the goal is 2-6
test(seven_test1) :- run(astar, h_e, 7, 7-2, 2-6, [7-2,6-2,6-3,6-4,6-5,6-6,5-6,4-6,3-6,2-6]).
test(seven_test2) :- run(astar, h_m, 7, 7-2, 2-6, [7-2,6-2,6-3,6-4,6-5,6-6,5-6,4-6,3-6,2-6]).
test(seven_test3) :- run(rta, h_e, 7, 7-2, 2-6, [7-2,6-2,6-3,6-4,6-5,6-6,5-6,4-6,3-6,2-6]).
test(seven_test4) :- run(rta, h_m, 7, 7-2, 2-6, [7-2,6-2,6-3,6-4,6-5,6-6,5-6,4-6,3-6,2-6]).

%8x8 grid, start is 4-8 and end is 8-1
test(eight_test1) :- run(astar, h_e, 8, 4-8, 8-1, [4-8,5-8,5-7,5-6,6-6,6-5,6-4,6-3,6-2,7-2,7-1,8-1]).
test(eight_test2) :- run(astar, h_m, 8, 4-8, 8-1, [4-8,5-8,5-7,5-6,6-6,6-5,6-4,6-3,6-2,7-2,7-1,8-1]).
test(eight_test3) :- run(rta, h_e, 8, 4-8, 8-1, [4-8,5-8,5-7,5-6,6-6,6-5,6-4,6-3,6-2,7-2,7-1,8-1]).
test(eight_test4) :- run(rta, h_m, 8, 4-8, 8-1, [4-8,5-8,5-7,5-6,6-6,6-5,6-4,6-3,6-2,7-2,7-1,8-1]).

%9x9 gird, start at 9-9 and end at 3-3
test(nine_test1) :- run(astar, h_e, 9, 9-9, 3-3, [9-9,9-8,9-7,9-6,9-5,8-5,7-5,6-5,6-4,5-4,4-4,4-3,3-3]).
test(nine_test2) :- run(astar, h_m, 9, 9-9, 3-3, [9-9,9-8,9-7,9-6,9-5,8-5,7-5,6-5,6-4,5-4,4-4,4-3,3-3]).
test(nine_test3) :- run(rta, h_e, 9, 9-9, 3-3, [9-9,8-9,7-9,8-9,8-8,9-8,9-7,8-7,8-8,7-8,7-9,8-9,9-9,9-8,9-7,9-6,9-5,8-5,7-5,6-5,6-6,5-6,4-6,3-6,2-6,2-7,1-7,1-8,2-8,2-9,3-9,4-9,5-9,5-8,5-7,5-6,5-5,4-5,4-4,3-4,3-3]).
test(nine_test4) :- run(rta, h_m, 9, 9-9, 3-3, [9-9,8-9,7-9,8-9,8-8,9-8,9-7,8-7,8-8,7-8,7-9,8-9,7-9,6-9,5-9,5-8,5-7,5-6,4-6,3-6,2-6,2-7,1-7,1-8,2-8,2-9,3-9,4-9,4-8,3-8,3-7,3-6,3-5,3-4,3-3]).

%----fail tests----

%one problem with count is that these test cases do not have their count removed
%because they failed before doing so

%out of grid bounds
test(fail1, [fail]) :- run(astar, h_e, 2, 1-1, 2-4, _).
test(fail2, [fail]) :- run(astar, h_m, 2, 1-1, 2-4, _).
%these tests do not finish due to the nature of rta
%test(fail3, [fail]) :- run(rta, h_e, 2, 1-1, 2-4, _).
%test(fail4, [fail]) :- run(rta, h_m, 2, 1-1, 2-4, _).

%incorrect path
test(fail5, [fail]) :- run(astar, h_e, 2, 1-1, 2-2, [1,1,2-1,2-2]).
test(fail6, [fail]) :- run(astar, h_m, 2, 1-1, 2-2, [1,1,2-1,2-2]).
test(fail7, [fail]) :- run(rta, h_e, 2, 1-1, 2-2, [1,1,2-1,2-2]).
test(fail8, [fail]) :- run(rta, h_m, 2, 1-1, 2-2, [1,1,2-1,2-2]).
																	
:- end_tests(report4). 																


