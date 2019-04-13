/*****************************************
Report 5 
EECS 3401 Fall 2016

Dominik Sobota 213644935
Michael Mierzwa 213550702

report_4.pl

Task 2.4
***************************************/

:- [bayesianNet_multistate].

parent(flood_defenses, flood).
parent(post_water_level, flood).
parent(rain, post_water_level).
parent(prior_water_level, post_water_level).

p(rain=none, 0.1667).
p(rain=low, 0.3333).
p(rain=high, 0.5).

p(prior_water_level=low, 0.3333).
p(prior_water_level=medium, 0.3333).
p(prior_water_level=high, 0.3333).

p(flood_defenses=poor, 0.1667).
p(flood_defenses=good, 0.3333).
p(flood_defenses=excellent, 0.5).

/*********************/

p(post_water_level=low, [prior_water_level=low, rain=none], 1).
p(post_water_level=low, [prior_water_level=low, rain=low], 0.9).
p(post_water_level=low, [prior_water_level=low, rain=high], 0.2).

p(post_water_level=low, [prior_water_level=medium, rain=none], 0.7).
p(post_water_level=low, [prior_water_level=medium, rain=low], 0.1).
p(post_water_level=low, [prior_water_level=medium, rain=high], 0).

p(post_water_level=low, [prior_water_level=high, rain=none], 0.1).
p(post_water_level=low, [prior_water_level=high, rain=low], 0).
p(post_water_level=low, [prior_water_level=high, rain=high], 0).

p(post_water_level=medium, [prior_water_level=low, rain=none], 0).
p(post_water_level=medium, [prior_water_level=low, rain=low], 0.1).
p(post_water_level=medium, [prior_water_level=low, rain=high], 0.7).

p(post_water_level=medium, [prior_water_level=medium, rain=none], 0.3).
p(post_water_level=medium, [prior_water_level=medium, rain=low], 0.8).
p(post_water_level=medium, [prior_water_level=medium, rain=high], 0.2).

p(post_water_level=medium, [prior_water_level=high, rain=none], 0.7).
p(post_water_level=medium, [prior_water_level=high, rain=low], 0.1).
p(post_water_level=medium, [prior_water_level=high, rain=high], 0).

p(post_water_level=high, [prior_water_level=low, rain=none], 0).
p(post_water_level=high, [prior_water_level=low, rain=low], 0).
p(post_water_level=high, [prior_water_level=low, rain=high], 0.1).

p(post_water_level=high, [prior_water_level=medium, rain=none], 0).
p(post_water_level=high, [prior_water_level=medium, rain=low], 0.1).
p(post_water_level=high, [prior_water_level=medium, rain=high], 0.8).

p(post_water_level=high, [prior_water_level=high, rain=none], 0.2).
p(post_water_level=high, [prior_water_level=high, rain=low], 0.9).
p(post_water_level=high, [prior_water_level=high, rain=high], 1).

/****************************************************/

p(flood=no, [post_water_level=low, flood_defenses=poor], 0.85).
p(flood=no, [post_water_level=low, flood_defenses=good], 0.95).
p(flood=no, [post_water_level=low, flood_defenses=excellent], 0.98).

p(flood=no, [post_water_level=medium, flood_defenses=poor], 0.6).
p(flood=no, [post_water_level=medium, flood_defenses=good], 0.8).
p(flood=no, [post_water_level=medium, flood_defenses=excellent], 0.92).

p(flood=no, [post_water_level=high, flood_defenses=poor], 0.35).
p(flood=no, [post_water_level=high, flood_defenses=good], 0.65).
p(flood=no, [post_water_level=high, flood_defenses=excellent], 0.85).


p(flood=yes, [post_water_level=low, flood_defenses=poor], 0.15).
p(flood=yes, [post_water_level=low, flood_defenses=good], 0.05).
p(flood=yes, [post_water_level=low, flood_defenses=excellent], 0.02).

p(flood=yes, [post_water_level=medium, flood_defenses=poor], 0.4).
p(flood=yes, [post_water_level=medium, flood_defenses=good], 0.2).
p(flood=yes, [post_water_level=medium, flood_defenses=excellent], 0.08).

p(flood=yes, [post_water_level=high, flood_defenses=poor], 0.65).
p(flood=yes, [post_water_level=high, flood_defenses=good], 0.35).
p(flood=yes, [post_water_level=high, flood_defenses=excellent], 0.15).

/******************************************************************************
p(flood=yes|post_water_level=high ^ flood_defenses=poor) = 0.65
p(flood=yes|post_water_level=high ^ flood_defenses=good) = 0.35
p(flood=yes|post_water_level=high ^ flood_defenses=excellent) = 0.15

p(flood_defenses=poor) = 0.1667
p(flood_defenses=good) = 0.3333
p(flood_defenses=excellent) = 0.5



p(flood=yes|post_water_level=high) =   p(flood=yes|post_water_level=high ^ flood_defenses=poor)*p(flood_defenses=poor) 
													+  p(flood=yes|post_water_level=high ^ flood_defenses=good)*p(flood_defenses=good)
													+  p(flood=yes|post_water_level=high ^ flood_defenses=excellent)*p(flood_defenses=excellent) 
													
													=(0.65)(0.1667) + (0.35)(0.3333) + (0.15)(0.5)
													
													=0.299

The answer we calculate was 0.299, as compared to 0.300 by the program

***********************************************************************/



