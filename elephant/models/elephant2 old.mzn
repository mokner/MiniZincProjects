include "global_cardinality.mzn";

int: T; % maximum time allowed;
set of int: TIME = 1..T;

var TIME: steps; % NUMBER OF STEPS TO CARRY STONES

int: E; % weight of elephant in STONES;
set of int: STONE = 0..E;

int: G; % number of guards
set of int: GUARD = 1..G;
array[GUARD] of STONE: easy;
array[GUARD] of STONE: hard;
array[GUARD] of TIME: tired;

GUARD: p; % maximum people on pier;
GUARD: b; % maximum people on boat;

set of int: ACT = -1..E; % -1 = goto bank, 0 = wait, > 0 carry stones
int: wait = 0;
int: to_bank = -1;
array[GUARD,TIME] of var ACT: act;        % action at time t

set of int: TIME0 = 0..T;
array[TIME0] of var 0..E: sboat; %stones on boat EACH GUARD NEEDS THEIR OWN ARRAY LIKE THIS (?)

enum POS = { Bank, Boat };
array[TIME0] of var POS: pos;

% LOCATION MATRIX

int: on_pier = 0;
int: on_boat = 1;

array[GUARD,TIME0] of var {on_pier, on_boat}: location;

constraint forall(g in GUARD)(location[g,0] = on_pier);

constraint forall(g in GUARD, t in TIME)
(if act[g,t] = 0 then location[g,t] = location[g, t-1] 
elseif act[g,t] = -1 then location[g,t]= on_pier 
else location[g,t] = on_boat endif);

% Max stones constraint
constraint sum(g in GUARD, t in 1..steps where act[g,t]>0)(act[g,t]) >= E;

% Max guards on boat constraint
% constraint forall(t in TIME0)
% (sum(g in GUARD)(location[g,t]) <= b);

% Max guards on pier constraint, adds 1 to sum everytime a guard is on the pier, then checks if sum of guards less than or equal to pier limit p
% constraint forall(t in TIME)
% (sum(g in GUARD where act[g,t] != 0)(1) <= p);

% Guard move constraint
constraint forall(g in GUARD, t in TIME)(act[g,t] in {easy[g], hard[g], 0, -1});

% Guard tiredness constraint
%constraint forall(g in GUARD, t in TIME)
%();
%%%% if act[g,t] = hard[g] then (for i in 1..tired[g]) (act[g,t+i] = 0)
%%%% 

constraint forall(g in GUARD, t in 1..steps)
(if act[g,t] = hard[g] then forall(i in 1..tired[g])(if t+i <=T then act[g,t+i] in {0, -1} endif) endif);


% Going back to shore constraint
constraint forall(g in GUARD, t in 1..steps-1)
(if act[g,t] > 0 then act[g,t+1] in {0, -1}
elseif act[g,t] = -1 then act[g,t+1] >= 0
else act[g,t+1] in {0,-1} endif);


% First move constraint
constraint forall(g in GUARD)
(act[g,1] != -1);

% Boat guard limit constraint
constraint forall(t in TIME)
(sum(g in GUARD where location[g,t]=1)(1) <= b);

% Pier guard limit constraint
constraint forall(t in TIME)
(sum(g in GUARD where location[g,t]= 0)(1) <= p);

solve minimize steps; % DO IT IN THE LEAST NUMBER OF STEPS

% Weight reached constraint
% constraint forall(t in 1..steps)
% (sum(g in GUARD)(act[g,t]) = E -> forall(g in GUARD, j in steps..T)(act[g,j]=0));

%%%%%%%%%%%%%%%%%%% FIXED VARS %%%%%%%%%%%%%%%%%%%
% act = array2d(GUARD,TIME,[
% 10, 0, 0, 0, 0, 0, 0, 0, 0, 0,
% 5, -1, 10, 0, 0, 0, 0, 0, 0, 0,
% 5, -1, 10, 0, 0, 0, 0, 0, 0, 0,
% 0, 0, 10, 0, 0, 0, 0, 0, 0, 0]);

% T = 10;

% E = 50;

% G = 4;

% easy = [5,5,5,5];
% hard = [10,10,10,10];
% tired = [3,3,3,3];
% p = 3;
% b = 4;
%%%%%%%%%%%%%%%%%%% END OF FIXED VARS %%%%%%%%%%%%%%%%%%%


%constraint: TOTAL NUMBER (except any -1's) in each guard's act array must equal to E

%constraint: NO TWO NUMBERS ABOVE 0 IN A ROW (to simulate waiting (0) and going back to bank (-1))

%constraint: A GUARD'S ACT array cannot have more than their value of "hard" a.k.a a guard cannot carry more than their "hard" num of stones in a single trip

%constraint: IF A GUARD CARRIES MORE THAN THEIR "easy" value, THEIR ACT ARRAY must rest for their "tired" value number of steps (0) before continuing

%constraint: guards must go back to the bank after dropping stones off at boat [[[[and once their rest period (if they need one) completes]]]] [according to document guards can move back to bank even after a tiring carry, but have to rest for their "tired" period back at the bank] [so basically a carrying stones action must be followed by a rest (0) if you reach E stones or bank return (-1)]

%constraint: a return to bank (-1) must be followed by a rest (0) or stone carry

%constraint: ONCE ALL STONES ON BOAT, GUARDS CAN JUST REST (0) UNTIL TIME T

%constraint: the obj value is the number of steps it takes to reach E stones



