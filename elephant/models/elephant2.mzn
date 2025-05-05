include "global_cardinality.mzn";

int: T; % maximum time allowed;
set of int: TIME = 1..T;

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

% DECISION VARS %
var TIME: steps; % NUMBER OF STEPS TO CARRY STONES

set of int: TIME0 = 0..T; % includes time 0, the initial step at the start before stones are moved
array[TIME0] of var 0..E: sboat; %stones on boat EACH GUARD NEEDS THEIR OWN ARRAY LIKE THIS (?)

% LOCATION MATRIX              (on pier will be tracked differently)
%int: on_pier = 0;
int: on_boat = 1;
int: on_bank = 0;

array[GUARD,TIME0] of var {on_boat, on_bank}: location;


% FIXED VARIABLES

% act =
% [| 0, 10, 0, -1, 0, 10, 0, 0, 0, 0
% | 10, 0, -1, 0, 10, 0, 0, 0, 0, 0
% | 10, 0, 0, -1, 0, 10, 0, 0, 0, 0
% | 10, 0, 0, -1, 10, 0, 0, 0, 0, 0
% |];

% location =
% [| 0: 1: 2: 3: 4: 5: 6: 7: 8: 9: 10:
% | 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0
% | 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0
% | 0, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0
% | 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0
% |];

% location =
% [| 0: 1: 2: 3: 4: 5: 6: 7: 8: 9: 10:
% | 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 1
% | 0, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1
% | 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1
% | 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1
% |];



% CONSTRAINTS %

% starting position of all the guards is on the bank
constraint forall(g in GUARD)(location[g,0] = on_bank);

%connection between action matrix and location matrix
constraint forall(g in GUARD, t in 1..steps)
(if act[g,t] = 0 then location[g,t] = location[g, t-1] 
elseif act[g,t] = -1 then location[g,t] = on_bank
else location[g,t] = on_boat endif);

% constraint forall(g in GUARD, t in TIME)
% (if act[g,t] = -1 then location[g,t] = on_bank
% elseif act[g,t] > 0 then location[g,t] = on_boat
% else act[g,t] = 0 endif);


% Minimum stones constraint
constraint sum(g in GUARD, t in 1..steps where act[g,t]>0)(act[g,t]) >= E;

% Guard move constraint
constraint forall(g in GUARD, t in TIME)(act[g,t] in {easy[g], hard[g], 0, -1});

% Guard tiredness constraint

constraint forall(g in GUARD, t in 1..steps)
(if act[g,t] = hard[g] then forall(i in 1..tired[g])(if t+i <=T then act[g,t+i] in {0, -1} endif) endif);


% First moves constraint

% constraint forall(g in GUARD)
%  (act[g,1] != -1);

%constraint forall(g in GUARD, t in TIME)
%(if act[g,t] = -1 then location[g,t-1] = on_boat endif);

% constraint forall(g in GUARD, t in 1..steps+1)
% (if act[g,t] = -1 then act[g,t-1] >= 0 endif);

%constraint forall(g in GUARD)(forall (t in 0..steps)
%(if location[g,t] = 0 then act[g,t+1] != -1 endif));

% constraint forall(g in GUARD)(forall(t in TIME)(
% (if location[g,t-1] = on_bank then act[g,t] != -1 
% else act[g,t] < 0 endif)));

% constraint forall(g in GUARD, t in TIME)
% (location[g,t-1] = on_bank -> act[g,t] != -1);

%%%%%%%%%%%%%%%%%%%%% MOST RECENT %
% constraint forall(g in GUARD, t in TIME)
% (act[g,t] = -1 -> location[g,t-1] != on_bank);

%constraint forall(g in GUARD, t in 2..T)
%(act[g,t] = -1 -> act[g,t-1] > 0);

% constraint forall(g in GUARD, t in TIME where act[g,t]=-1)
% (forall (g in 1..t-1, tt in 1..t-1)())


% constraint forall(g in GUARD, t in 2..T)
% (if location[g,t] = on_bank then act[g,t-1] != -1 /\ act[g,t] != -1
% elseif location[g,t]= on_boat then act[g, t-1] <= 0 /\ act[g,t] <= 0
% else act[g,t] = 0 endif)

% constraint forall(g in GUARD, t in 1..T-1)
% (if location[g,t-1]= on_bank then act[g,t] != -1 /\ act[g,t+1] != -1
% else act[g,t] <=0 /\ act[g,t+1] <= 0 endif);


% Boat guard limit constraint
constraint forall(t in TIME)
(sum(g in GUARD where location[g,t] = on_boat)(1) <= b);

% Pier guard limit constraint

constraint forall(t in TIME)
 (sum(g in GUARD where act[g,t] != 0)(1) <= p);


% Move order constraints (allowed order of moves between locations)
constraint forall(g in GUARD, t in 1..steps-1)
(if act[g,t] > 0 then act[g,t+1] in {0, -1}
elseif act[g,t] = -1 then act[g,t+1] >= 0
else act[g,t+1] in {0,-1} endif);


% Movement and location after reaching minimum stones constraint
constraint forall(g in GUARD, t in steps+1..T)(act[g,t]=0 /\ location[g,t]=0);


% OBJECTIVE %
solve minimize steps; % DO IT IN THE LEAST NUMBER OF STEPS









%%%%%%%%%%%%%% STARTING CODE %%%%%%%%%%%%%%

% int: T; % maximum time allowed;
% set of int: TIME = 1..T;

% int: E; % weight of elephant in STONES;
% set of int: STONE = 0..E;

% int: G; % number of guards
% set of int: GUARD = 1..G;
% array[GUARD] of STONE: easy;
% array[GUARD] of STONE: hard;
% array[GUARD] of TIME: tired;

% GUARD: p; % maximum people on pier;
% GUARD: b; % maximum people on boat;

% set of int: ACT = -1..E; % -1 = goto bank, 0 = wait, > 0 carry stones
% int: wait = 0;
% int: to_bank = -1;
% array[GUARD,TIME] of var ACT: act;        % action at time t
