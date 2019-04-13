/*================================================================================
							Report 1
							Dominik	 Sobota 	213644935
							Michael	 Mierzwa 	213550702
							2016 Septemeber 26
==================================================================================

Please Note:	Spacing and Indentation may not appear the same on all
				devices, and may make some of our formating hard to read.
				
=================================================================================
Exercise 1
	Work Division:
		* Domonik: q1, q2, q3, and q5.
		* Michael: q1, q4, and formating.
=================================================================================
----- Example -------------------------------------------
	 bathurst	spadina	christie	st_george	bay	young 
---------------------------------------------------------

1) "Spadina is west of bay" is not explicitly stated in the KB, but	since
	- spadina is left of st_george and st_george is left of bay, by
	  " If X is left of Y then X is west of Y", spadina is west of st_george
	  and st_george is west of bay.
	- "If X is left of Y and Y is west of Z, then X is west of Z" can be used
	   since Spadina is left of st_george and st_george is west of bay, 
	   therefore Spadina is west of Bay. 

2)	The KB does not have a definition for right, so the statement "spadina 
	is right of bathurst" is meaningless to it. One could define this rule by, 
	calling the predicate for left and reversing the arguments.
	right(X,Y) :- left(Y,X).
	
3) 	a)	- Not explicitly stated in KB, but can use left(X,Y) then west(X,Y)
		- spadina is left of st.george, then spadina is west of st.george
	
	b)	- Use rule west(X,Y) then east(Y,X)
	       * To make youge east of bay, bay must be west of young
		- Use rule left(X,Y) then west(X,Y)
		   * If bay is west of young, then that  means that bay is left of young
		- bay is left of young is a constant so therefore the query is true!
			
	c)	- Rule left(X,Y), west(Y,Z) then west(X,Z) applies
	      *	To make chirstie west of spadina, we can use bathurst is left of spadina
		    for the first part of the and, and this statement is true!
		  *	For the second part of the and, christie must be west of bathurst
		- Rule left(X,Y) then west(X,Y)
		  *	If chrisite is west of bathurst that must mean that chrisite is left
			of bathurst, and this statement is true
		
		- So(true and true) -> true is of the correct logical form, 
			and the query will return true.
		  
	
	d) - Rule left(X,Y) then west(X,Y)
	      * If young is west of young, , to make this statement, young should be
			left of young
		  * There is no constant defined indicating that young is left of young
		  * Will return false
	
	e) - Rule left(X,Y) then west(X,Y)
		  * If bay is west of sherbourne, to get to this it must mean that bay 
			is left of sherbourne.
		  * There are no constants defined that give bay being left of sherbourne,
			sherbourne is not defined at all in the KB
		  * Will return false

4) If the 2nd rule was replaced with "if X is west of Y and Y is left of Z 
	then X is west of Z", any call to the rule 'west' would result in an infinite
	loop because the first west rule calls to check if X is west of Y. If you 
	switched around conditions 2 and 3 it would no longer loop infinitely.
	3.d) will now constantly check "if young is west of young" recursively until
	it runs out of stack, since the conditions for deciding if west is true happen
	after another west is already called.

5) Spadina is west of X would give st_george, bay, young, bay , young, bay, continuing indefintiely as young and bay 
	will be in a infinite loop of recurisve calls.
	
=================================================================================
Exercise 2 
	Work Division:
		* Dominik: Adding ! (cuts), test cases, fixing the counter variable (N2) reset for
					rule #5, and fixing the starting value for N2.
		* Michael: Idea for 4 arguement everyNth(), general structure for rules,
					and test cases.
	Notes:	Michael tried two routes for the program, the first was one that used
			append, mod, and length to go through and check if we should remove
			a character or not. This route did not pan out and he suggested just 
			adding a counter variable as a fourth arguement. The counter had problems
			and would not properly reset.
			Dominik debugged the counter via write() statements and fixed the counter
			variable by subtracting the previous version by 1.
=================================================================================*/

% base case, recurse until the input list is empty
everyNth(N, [], []) :- !.

% base case, List2 is exactly the same as list 1
everyNth(1,L,L) :- !.

% base case for our 4 argument predicate, where both lists become empty and our counter variable is irrelevant
everyNth(N,[],[],_).

% transfers the three argument prediacte to 4 arguments in order to allow a counter vairable for N
everyNth(N,L1,L2) :- everyNth(N, L1, L2, 0).

% The case where the counter variable is not at the Nth position, 
% we only shift the first list by one position, passing over a decremented counter variable 
everyNth(N, [_|L1], L2, N2) :- N2 \= 0, N3 is N2 - 1, everyNth(N,L1,L2,N3).

% The case where the counter is at the Nth position, and we reset the counter 
% variable back to N - 1 because the next Nth position is N - 1 characters away
everyNth(N,[X|L1], [X|L2], N2) :- N2 = 0, N3 is N - 1, everyNth(N,L1,L2,N3).


:- begin_tests(e2).
% base case empty list
test(e2empty_list_N) :- everyNth(N,[],[]).
% base case every item, N = 1
test(e2every_item) :- everyNth(1,[1,2,3],[1,2,3]).
% N>1, no nested lists
test(e2no_nested) :- everyNth(2,[1,2,3,4,5], [1,3,5]).
% N > 1, with nested lists
test(e2nest) :- everyNth(3, [1,2,[3,4], 6, [[7]]], [1,6]).
:- end_tests(e2).


/*================================================================================
Exercise 3
	Work Division:
		* Domonik: implementing cases, documentation, and test cases.
		* Michael: Outlining cases and tests cases.
=================================================================================*/

% Base, Adding two empty lists together returns the empty list
sumOf( [], [] , [] ) :- !.

% The Case where List1 is empty and List2 still has integers left to place into List3. 
sumOf( [], [Integer2|List2] , [Integer3|List3] ) :- Integer3 is Integer2 , sumOf( [] , List2 , List3 ). 

% The Case where List2 is empty and List1 still has integers left to place in List3.
sumOf( [Integer1|List1] , []  , [Integer3|List3] ) :- Integer3 is Integer1 , sumOf( List1 , [] , List3 ), !.  

% The Case where both list are not empty, add the two integers as normal and place into L3.
sumOf( [Integer1|List1] , [Integer2|List2] , [Integer3|List3] ) :- Integer3 is Integer1 + Integer2 , sumOf( List1 , List2 , List3 ). 


:- begin_tests(e3).
% adding the empty list to an empty list yeilds the empty list
test(e3empty_list) :- sumOf([], [], []).
% Two lists of integers of same length will give a list of all the sums in the correct order
test(e3same_length) :- sumOf([1,1,1] ,[1,1,1],[2,2,2]).
% The first list is shorter than the second
test(e3first_shorter) :- sumOf([1,2,3],[1,2,3,4], [2,4,6,4]).
% The second list is shorter than the first
test(e3second_shorter) :-sumOf([1,2,3], [1,2], [2,4,3]).
:- end_tests(e3).


/*================================================================================
Exercise 4
	Work Division:
		* Domonik: suggesting [X,X|L1] in the rule instead of a helper rule and 
					test cases.
		* Michael: creating the cases, documenting, and test cases.
	Notes: for a long time we tried to use a helper rule as suggested by the hint
			and we called it isNext(). The problem was that even if we knew it was next
			we lost the data of what was before, this made it so switching from one
			character to the next resulted in false. After setting up the main rules
			to account for the previous terms, we were able to achieve the desired result.
			
=================================================================================*/

% if X and Y have nothing in the list then true
removeContig([],[]).

% if X and Y are identical then true
removeContig(L,L).

% if it is of the format a,a then remove head of L1 and recurse
removeContig([X,X|L1],L2) :- removeContig([X|L1],L2).

% if it is of the format a,b then remove head of L1 and L2 and recurse
removeContig([X,Y|L1],[X|L2]) :- X \=Y, removeContig(L1,L2).


:- begin_tests(e4).
% removing duplicates from empty list yeilds empty list
test(e4empty_list) :- removeContig([],[]).
% removing duplicates from a list without duplicates yields that same list
test(e4identical_list) :- removeContig([1,2,3],[1,2,3]).
% ensures rule 3 can remove duplicates
test(e4first_dup) :- removeContig([a,a,b,c],[a,b,c]).
% see if rule 4 can then call rule 3
test(e4second_dup) :- removeContig([a,b,b,c],[a,b,c]).
% see if varrying amount of duplicates affect the outcome
test(e4various_dup) :- removeContig([a,a,b,b,b,c,c,c,c,c,c],[a,b,c]).
:- end_tests(e4).

/*================================================================================
Exercise 5
	Work Division:
		* Domonik: cases, implementation, cutting, and test cases.
		* Michael: documentation, question, and special test case.
	Notes: The only case where zipper([List1, List2], Zippered) , 
			unzipper(Zippered, [List1, List2]) is true is when List1 and List2,
			are the same length. Since the length of each list is lost when
			zippered or unzippered, any length other than equal will result
			in one list recieving more elements than it had previously
=================================================================================*/

%Base, Interleaving nothing with nothing gives the empty list
zipper([[],[]],[]) :- !.

% List1 and List2 are the same length
zipper([[X|L1], [Y|L2]], [X,Y|L3]) :- zipper([L1,L2],L3), !.

% List1 is shorter than List2
zipper([[], [Y| L2]], [Y|L3]) :- zipper([[],L2],L3).

% List2 is shorter than List1
zipper([[X|L1],[]], [X|L3]) :- zipper([L1,[]], L3).


/*--------------------------------------------------------------------------------
	unzipper
---------------------------------------------------------------------------------*/

% Base, The unzippered lists of an empty list are empty
unzipper([],[[],[]]) :- !.

% There are two elements in Zippered to be distrubited to L1 and L2, Zippered is of even length
unzipper([X,Y|L], [[X|L1], [Y|L2]]) :- unzipper(L, [L1, L2]), !.

%  There is only one element left in Zippered, Zippered is of odd length
unzipper([X|L], [[X|L1], []]) :- unzipper([], [L1, L2]).


:- begin_tests(e5).
%zipper base case
test(empty_list_zipper) :- zipper([[],[]],[]).
%zipper List1 and List2 are same length
test(same_length_zipper) :- zipper([[1,3], [2,4]], [1,2,3,4]).
%zipper L1 is shorter 
test(list1_shorter_zipper) :- zipper([[1,2],[3,4,5]], [1,3,2,4,5]).
%zipper L2 is shorter
test(list2_shorter_zipper) :- zipper([[1,3],[2]], [1,2,3]).

%the special case defined at the end of the exercise
test(zipper_unzipper) :- zipper([[1,3],[2,4]],Zip), unzipper(Zip, [[1,3], [2,4]]).

%unzipper base case
test(empty_lists_unzipper) :- unzipper([],[[],[]]).
%unzipper even length 
test(even_length_unzipper) :- unzipper([1,2,3,4], [[1,3], [2,4]]).
%unzipper odd length
test(odd_length_unzipper) :- unzipper([1,2,3,4,5], [[1,3,5], [2,4]]).
:- end_tests(e5).



/*================================================================================
Exercise 6
	Work Division:
		* Domonik: fixing distance incrementer, cousins(), conditional statement
					within cousins(), and cuts (!).
		* Michael: entering family tree, ancestor(), and test cases.
	Notes: We had multiple answers for ancestor because each person had many ancestors.
			in this case we fixed it by asserting that the ancestor had to be the same,
			but we could have looked for the ancestor by dumping all the 
			ancestors into a list and picking the first common ancestor or just the 
			greatest ancestor (both work for our distacne calculations).
=================================================================================*/
%-------- Example Family Tree ---------------------------------------------------
%leila is a person and has no parent.
person(leila). 
%leila is the parent of two people named min and seema.
person(min). person(seema).
parent(leila, min). parent(leila, seema).
%seema is the parent of the person zack.
person(zack). parent(seema, zack).
%zack is the parent of three people named kyle, nikolay, and wei.
person(kyle). person(nikolay). person(wei).
parent(zack, kyle). parent(zack, nikolay). parent(zack, wei).
%kyle is the parent of william and nikolay is the parent of saul.
person(william). person(saul).
parent(kyle, william). parent(nikolay, saul).
%ali is the parent of three people named ali, jesse, and john.
person(ali). person(jesse). person(john).
parent(min, ali). parent(min, jesse). parent(min, john).
%ali is the parent of two people named sean and steven.
person(sean). person(steven).
parent(ali, sean). parent(ali, steven).
%sean is the parent of a person named ping.
person(ping). parent(sean, ping).
%jesse is the parent of two people named dallas and mustafa.
person(dallas). person(mustafa).
parent(jesse, dallas). parent(jesse, mustafa).
%dallas is the parent of a person named farah.
person(farah). parent(dallas, farah).
%mustafa is the parent of two people named ignat and thomas.
person(ignat). person(thomas).
parent(mustafa, ignat). parent(mustafa,thomas).
%-------- End of Family Tree ----------------------------------------------------

%your parent is your ancestor
ancestor(Person, Ancestor) :- parent(Ancestor, Person).

%call your parent as the person and check the ancestor of your parent.
ancestor(Person, Ancestor) :- parent(X, Person), ancestor(X, Ancestor).

%a person is not their own ancestor.
distance(Person, Person, 0).
%as long as the person is not their ancestor then find the parent of the person, call distance with the parent,
%and increment Distance only if you backtrack from being your own ancestor.
distance(Person, Ancestor, Distance) :- Person \= Ancestor, parent(Parent, Person), distance(Parent, Ancestor, Dist), Distance is Dist + 1, !.

%Name1 and Name2 are cousins when the distance between them and a shared ancestor is >= 2 and
%otherwise they are not cousins
cousins(Name1,Name2, P,Q) :- ancestor(Name1, Ancestor), ancestor(Name2, Ancestor), !,   
								distance(Name1, Ancestor, A), distance(Name2,Ancestor, B), 
								(
								(A >= 2, B >= 2) -> P is min(A,B) - 1, Abs is A - B, Q is abs(Abs); 
								P is -1, Q is -1		
								).
:- begin_tests(e6).
%ignat and thomas are not cousins (they are brothers)
test(e6siblings) :- cousins(ignat,thomas,-1,-1).
%ignat and mustafa are not cousins(they are child and parent)
test(e6parent_child) :- cousins(ignat,mustafa,-1,-1).
%ignat is not his own cousin
test(e6self_cousin) :- cousins(ignat,ignat,-1,-1).
%ignat and farah are 1st cousins
test(e6first_cousin) :- cousins(ignat,farah,1,0).
%sean and farah are 1st cousins once removed
test(e6first_cousin_once_removed) :- cousins(sean,farah,1,1).
%ping and saul are 3rd cousins
test(e6third_cousin) :- cousins(ping,saul,3,0).
%ping and zack are 1st cousins twice removed
test(e6first_cousin_twice_removed) :- cousins(ping,zack,1,2).
:- end_tests(e6).
								
/*================================================================================
	end of report
	
	One final note, while we looked at help for prolog we found
	someone on stack overflow posting the assignment (with what appeared to be
	his real name) on the site as individual questions...  
	http://stackoverflow.com/questions/39689283/calculating-cousin-relationship-in-prolog
=================================================================================*/