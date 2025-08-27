int: n; % number of court members
set of int: COURT = 1..n;
int: emperor = 1;
array[COURT] of int: rank;
array[COURT] of int: ability;

int: m; % number of horses
set of int: HORSE = 1..m;
array[HORSE] of int: beauty;
array[HORSE] of int: speed;

array[COURT,HORSE] of int: enjoy;

int: partysize = min(n,m);

array[COURT] of var 0..m: horse;
array[HORSE] of var 0..n: court;

include "inverse.mzn";
%constraint inverse(horse, court);

constraint forall(i in COURT, j in HORSE)(horse[i]=j <-> court[j]=i);

% CONSTRAINTS
% -Emperor must have highest enjoyment level of anyone
% -All court members must ride unless there are no horses left
% -If a court member holds a higher rank than another, then either
% – (a) the beauty of their horses can be no less than that assigned to
% the other,
% – (b) the lower rank member does not ride, or
% – (c) both court members do not ride.
% -If a horses is faster than another then either
% – (a) the rider of the faster horses has no less riding ability than
% that of the slower horses,
% – (b) the faster horses has no rider, or
% – (c) both horses have no rider.
% The aim is to maximize the total enjoyment of the hunt over all riders. In truth the constraints are too hard to satisfy usually. So the last constraint can be violated for a penalty of 100 for each violation to the objective.

% Can't have negative enjoyment
constraint forall(i in COURT)(enjoy[i,horse[i]] < 0 -> horse[i]=0);

% Party size limit
constraint sum(h in HORSE)(court[h]>0) = partysize;

% Emperor enjoyment constraint
constraint forall(i in 2..n where horse[i] != 0)(enjoy[emperor, horse[emperor]] > enjoy[i, horse[i]]);

% Court to horses assignment heirarchy constraints
constraint forall(i,j in COURT)(rank[i] > rank[j] -> (beauty[horse[i]] >= beauty[horse[j]]) \/ (horse[j] = 0) \/ (horse[i]=0 /\ horse[j]=0));

% Penalty constraints
var int: penalty = sum(h1, h2 in HORSE where h1!=h2)(not (speed[h1] > speed[h2] -> ((court[h1]=0) \/ (court[h1]=0 /\ court[h2]=0) \/ (ability[court[h1]] >= ability[court[h2]])))) * 100;

var int: obj = (sum(i in COURT where horse[i]>0)(enjoy[i,horse[i]])) - penalty;

solve maximize obj;

