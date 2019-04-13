/**************************************
Report 3
EECS3041 Fall 2016

Dominik Sobota 213644935
Michael Mierzwa 213550702

**************************************/

/*************************************

Exersize 1

preorder_a(BinaryTree, Order) asserts that Order is the pre-order list of data in BinaryTree
inorder_a(BinaryTree, Order) asserts that Order is the in-order list of data in BinaryTree
postorder_a(BinaryTree,Order) asserts that Order is the post-order list of data in BinaryTree
Accumulators will be used to accumulate the tree path
**************************************/




inorder_a(BT,Order) :- inorder_a(BT,[],ReverseOrder), reverse(ReverseOrder, Order), !.
inorder_a(BT, Order, Order) :- var(BT),   !.  %End Node, no children
inorder_a(t(Data,Left,Right), Acc ,Order) :- inorder_a(Left, Acc, LeftOrder),  inorder_a(Right, [Data|LeftOrder], Order).

preorder_a(BT,Order) :- preorder_a(BT,[],ReverseOrder), reverse(ReverseOrder, Order), !.
preorder_a(BT, Order, Order) :- var(BT),  !.  %End Node, no children
preorder_a(t(Data,Left,Right), Acc ,Order) :- preorder_a(Left, [Data|Acc], LeftOrder ),  preorder_a(Right, LeftOrder, Order).

postorder_a(BT,Order) :- postorder_a(BT,[],ReverseOrder), reverse(ReverseOrder, Order), !.
postorder_a(BT, Order, Order) :- var(BT),  !.  %End Node, no children
postorder_a(t(Data,Left,Right), Acc ,Order) :- postorder_a(Left, Acc, LeftOrder ),  postorder_a(Right, LeftOrder, RightOrder), Order = [Data|RightOrder].





/******************Utilites**************/
%BinTree

t(Data,Left,Right).



/******Tests ************/





/******************************************
Exersize 2
preorder_a(BinaryTree, Order) asserts that Order is the pre-order list of data in BinaryTree
inorder_a(BinaryTree, Order) asserts that Order is the in-order list of data in BinaryTree
postorder_a(BinaryTree,Order) asserts that Order is the post-order list of data in BinaryTree
Holes will be used to accumulate the tree path

********************************************/


inorder_h(BT,Order) :- inorder_h(BT,[],Order).
inorder_h(BT, Hole, Hole) :- var(BT), !. %end node
inorder_h(t(Data,Left,Right), Hole, [LOrder|ROrder]) :-  inorder_h(Left,Hole1, LOrder),  write(LOrder), nl,  inorder_h(Right, Hole, ROrder). 

 



/*********************************************

Exersize 3
Parse Rules are given below, Parsing will be done by using DCG translator
1. Stop.   Chatting ceases
2. _  is the _ of _.      Example: Alfred is the brother of Fred
3. Is _ the _ of _? 	  Example: Is Alice the mother of Mary?
4. Who is the _ of _. Example: Who is the mother of Eliza?
5. X is the _ of Y if X is the_ of Z and Z is the _ of Y.
**********************************************/
:- consult('chatBasis.pl').

/************
parse(Clause, Sentence , Left-Over) parses the input sentence where
- Clause is the encoded result of parsing input
- Sentence is a list that matches the the prefix of input
- Left-Over is all that is left over after prefix parsed

First Rule for parsing, Stop. is used to terminate the chat program with nothing left over
*************/
parse(stop, [ 'Stop', '.' ], []) .

/*
Rule 2 for parsing,
 _ is the _ of _. 
 
 */ 
  

parse(Clause) --> thing(Name) , [ is , the] , type(T) , [of], thing(Name2), ['.'],  
						 { Head =.. [T, Name, Name2],  Clause = Head, !} .

/*
Rule 3 for parsing 
Is _ the _ of _?
*/
parse(Clause) --> ['Is'] , thing(Name) , [the] , type(T) , [of], thing(Name2), ['?'],
                 { Goal =.. [T, Name, Name2 ], Clause = ('?-'(Goal)) , ! } .

/* 
Rule 4 for parsing
Who is the _ of _?
*/
parse(Clause) --> ['Who', 'is', 'the'] , type(T) , [ of ] , thing(Name) , ['?']
                , { Goal =.. [T,  Unknown, Name] , Clause = ('?'(Goal)) , ! } .

/*
Rule 5 for parsing
X is the _ of Y if X is the _ of Z and Z is the _ of Y			
*/

parse(Clause) --> thing(X), [is, the], type(T1), [of], thing(Y), [if], thing(X), [is, the], type(T2), [of], thing(Z), [and], thing(Z), [is, the], type(T3), [of], thing(Y), ['.'],
						{ XtoY =.. [T1, A, B], XtoZ =.. [T2, A, C], ZtoY =..[T3, C, B], Clause=(XtoY :- XtoZ, ZtoY), !}.
				
/*
For all other inputs, noparse is used
*/
parse(noparse, _, _) .

/****Tests******/
:- begin_tests(e3).
tests(first) :- see('chatInput1.text') , chat , seen , told.
:- end_tests(e3).

/********************************
 SplitOff rules for parsing.
In the example period, '.', question mark, '?' and possesive, "'s" are split off
the end of input words.
*********************************/

   splitOff(ApostropheS) :- name("'s", ApostropheS).
   splitOff(QuestionMark) :- name("?", QuestionMark).
   splitOff(Period) :- name(".", Period).
   
/*****
respondTo responds to the parse rules defined above and gives the correct output to the user   
*****/   
% is ? rule
respondTo('?-'(Goal)) :-  Goal =.. [TY, Name1, Name2],
									( Goal -> write('Yes, '), write(Name1), write(' is the '), write(TY), write( ' of '), write(Name2), write('.') 
									; write('No, '), write(Name1), write(' is not the '), write(TY), write(' of '), write(Name2), write('.')  ), !, nl, nl. 

%who is rule
respondTo('?'(Goal)) :- Goal =.. [TY, Unknown, Known],                                
									(	Goal -> write(Unknown), write( ' is the '), 
											write(TY), write('.')
										; write('No one.')
									), !, nl, nl.									
   
%If the result of parsing is stop, then the chat program is terminated
   
respondTo(stop) :- write('All done.') , nl , ! .
   
%If the result of parsing is noparse, then the input cannot be parsed
 
respondTo(noparse) :- write('Can''t parse that.' ) , nl , ! .

 %If the result of parsing is a clause to add into the database
respondTo(Clause) :- asserta(Clause) , write('Ok') , nl , ! .
   
   
/*************TESTS**************/


/*********************************
Exersize 4 
Parse Rules are given below, Parsing will not use DCG translator
1. Stop.   Chatting ceases
2. _  is the _ of _.      Example: Alfred is the brother of Fred
3. Is _ the _ of _? 	  Example: Is Alice the mother of Mary?
4. Who is the _ of _. Example: Who is the mother of Eliza?
5. X is the _ of Y if X is the_ of Z and Z is the _ of Y.
**********************************/

/************
parse(Clause, Sentence , Left-Over) parses the input sentence where
- Clause is the encoded result of parsing input
- Sentence is a list that matches the the prefix of input
- Left-Over is all that is left over after prefix parsed

First Rule for parsing, Stop. is used to terminate the chat program with nothing left over
*************/
parse_t(stop, [ 'Stop', '.' ], []) .

/*
Rule 2 for parsing,
 _ is the _ of _. 
 
 */ 
  

parse_t(poop, S, SRem) :- thing(Name, S, S0), det2(S0,S1), thing(Type,S1, S2), det4(S2, S3), thing(Name2, S3, S4), det6(S4, SRem), write(Name), write(Type).

 

thing(Name, S, SRem) :- det1(S, SRem, Name).
type(Type, S, SRem) :- det3(S, SRem, Type).

det1([Name|St], St, Name). 
det2([is, the| St], St).
det3([Type|St], St, Type).
det4([of|St], St).
det5([P2|St], St).
det6(['.'|St], St). 

/*
Rule 3 for parsing 
Is _ the _ of _?
*/


/* 
Rule 4 for parsing
Who is the _ of _?
*/


/*
Rule 5 for parsing
X is the _ of Y if X is the _ of Z and Z is the _ of Y			
*/


/*
For all other inputs, noparse is used
*/
parse_t(noparse, _, _) .

capital(Name) :- name(Name,[F|_]) , F < 96 .


/********************************
 SplitOff rules for parsing.
In the example period, '.', question mark, '?' and possesive, "'s" are split off
the end of input words.
*********************************/

   splitOff(ApostropheS) :- name("'s", ApostropheS).
   splitOff(QuestionMark) :- name("?", QuestionMark).
   splitOff(Period) :- name(".", Period).
   
/*****
respondTo responds to the parse rules defined above and gives the correct output to the user   
*****/   


% is ? rule
respondTo('?-'(Goal)) :-  Goal =.. [TY, Name1, Name2],
									( Goal -> write('Yes, '), write(Name1), write(' is the '), write(TY), write( ' of '), write(Name2), write('.') 
									; write('No, '), write(Name1), write(' is not the '), write(TY), write(' of '), write(Name2), write('.')  ), !, nl, nl. 

%who is rule
respondTo('?'(Goal)) :- Goal =.. [TY, Unknown, Known],                                
									(	Goal -> write(Unknown), write( ' is the '), 
											write(TY), write('.')
										; write('No one.')
									), !, nl, nl.									
   
%If the result of parsing is stop, then the chat program is terminated
   
respondTo(stop) :- write('All done.') , nl , ! .
   
%If the result of parsing is noparse, then the input cannot be parsed
 
respondTo(noparse) :- write('Can''t parse that.' ) , nl , ! .

 %If the result of parsing is a clause to add into the database
respondTo(Clause) :- asserta(Clause) , write('Ok') , nl , ! .
   



