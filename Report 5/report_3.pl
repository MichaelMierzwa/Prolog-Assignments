/*****************************************
Report 5 
EECS 3401 Fall 2016

Dominik Sobota 213644935
Michael Mierzwa 213550702

report_3.pl

Task 2.3
***************************************/
:- ['f16_4_BayesianNet.pl'].


/**Parent child relationships***/

parent(dam_burst, flood).
parent(flood_barrier_fails, flood).
parent(flood, loss_of_life).
parent(rapid_emergency_response, loss_of_life).

/***********************/

p(dam_burst, 0.1).
p(flood_barrier_fails, 0.1).
p(rapid_emergency_response, 0.9).

p(flood, [dam_burst, flood_barrier_fails], 1.0).
p(flood, [dam_burst, ~flood_barrier_fails], 0.1).
p(flood, [~dam_burst, flood_barrier_fails], 0.2).
p(flood, [~dam_burst, ~flood_barrier_fails], 0).

p(loss_of_life, [flood, rapid_emergency_response], 0.1).
p(loss_of_life, [flood, ~rapid_emergency_response], 1.0).
p(loss_of_life, [~flood, rapid_emergency_response], 0).
p(loss_of_life, [~flood, ~rapid_emergency_response], 0).


/*************************************************************

p(~flood_barrier_fails| flood) ANSWER



p(flood_barrier_fails) = 0.1
p(~flood_barrier_fails) = 0.9
p(dam_burst) = 0.1
p(~dam_burst) = 0.9

p(flood) = p(flood|dam_burst ^ flood_barrier_fails)*p(dam_burst)*p(flood_barrier_fails) 
            + p(flood|dam_burst ^ ~flood_barrier_fails)*p(dam_burst)*p(~flood_barrier_fails) 
			+ p(flood|~dam_burst ^ flood_barrier_fails)*p(~dam_burst)*p(flood_barrier_fails)
			+ p(flood|~dam_burst ^ ~flood_barrier_fails)*p(~dam_burst)*p(~flood_barrier_fails) 		

p(flood) = 1(0.1)(0.1) + (0.1)(0.1)(0.9) + (0.2)(0.9)(0.1) + 0 = 0.037			

p(flood| ~flood_barrier_fails) = p(flood|~flood_barrier_fails ^ dam_burst)*p(dam_burst) 
										 + p(flood|~flood_barrier_fails ^ ~dam_burst)*p(~dam_burst)

p(flood|~flood_barrier_fails) = (0.1)(0.1) + 0 = 0.009

p(~flood_barrier_fails| flood) = p(~flood_barrier_fails) * (p(flood| ~flood_barrier_fails) / p(flood))

p(~flood_barrier_fails| flood) = (0.9) * ((0.001)/(0.037)) = 0.243

The program calculated 0.2342, which is very close to our manual calulation 

***************************************************************************8
p(dam_burst| loss_of_life) ANSWER



p(dam_burst| loss_of_life) = p(dam_burst) * (p(loss_of_life| dam_burst) / p(loss_of_life))

p(dam_burst) = 0.1
p(~dam_burst) = 0.9
p(flood) = 0.037
p(rapid_emergency_response) = 0.9
p(~rapid_emergency_response) = 0.1


p(loss_of_life) = p(loss_of_life|flood ^ rapid_emergency_response)*p(flood)*p(rapid_emergency_response)
					 + p(loss_of_life|flood ^ ~rapid_emergency_response)*p(flood)*p(~rapid_emergency_response)
					 + p(~loss_of_life|flood ^ rapid_emergency_response)*p(~flood)*p(rapid_emergency_response)
					 + p(~loss_of_life|flood ^ ~rapid_emergency_response)*p(~flood)*p(~rapid_emergency_response)
					 
p(loss_of_life) = 0.1(0.037)(0.9) + (1)(0.037)(0.1) + 0 + 0 = 0.00703


p(loss_of_life|flood) = p(loss_of_life|flood ^ rapid_emergency_response)*p(rapid_emergency_response) + p(loss_of_life| flood ^ ~rapid_emergency_response)*p(~rapid_emergency_response)
							   = 0.1(0.9) + (1)(0.1) = 0.19
						
p(flood|dam_burst) = p(flood|dam_burst ^ flood_barrier_fails)*p(flood_barrier_fails) + p(flood|dam_burst ^ ~flood_barrier_fails)*p(~flood_barrier_fails)
							= 1(0.1) + 0.1(0.9) = 0.19
							
p(loss_of_life|~flood) = p(loss_of_life|~flood ^ rapid_emergency_response)*p(rapid_emergency_response) + p(loss_of_life| ~flood ^ ~rapid_emergency_response)*p(~rapid_emergency_response)
							   = 0 + 0 = 0
p(~flood|dam_burst) = p(~flood|dam_burst ^ flood_barrier_fails)*p(flood_barrier_fails) + p(~flood|dam_burst ^ ~flood_barrier_fails)*p(~flood_barrier_fails)
							= 0 + 0 = 0 						
	
p(loss_of_life| dam_burst) = p(loss_of_life|flood)*p(flood|dam_burst)
									  + p(loss_of_life|~flood)*p(~flood|~dam_burst)

									= 0.19(0.19) + 0 = 0.0361
									
p(dam_burst| loss_of_life) = p(dam_burst) * (p(loss_of_life| dam_burst) / p(loss_of_life))
								      = (0.1)((0.0361)/(0.00703))
									  = 0.513
									  
The answer calulcated by the program is 0.5135135... so the the manually calculated answer macthes the computed one. 

*/
