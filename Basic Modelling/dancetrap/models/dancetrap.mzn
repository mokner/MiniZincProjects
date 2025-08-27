% Beauty Trap
% Perform the most seductive dance

enum LEGS = {spin, leap, waltz, curtsey, prep, stand};
enum ARMS = {beckon, out, up, wrapped, neutral};
enum FACE = {smile, wink, batt, think, glow, blank};

int: maxlen;
set of int: STEP = 1..maxlen;
array[LEGS] of int: maxlegs;
array[ARMS] of int: maxarms;
array[FACE] of int: maxface;
constraint assert(maxlegs[stand] >= maxlen, "maxlegs[stand] smaller than maxlen");
constraint assert(maxarms[neutral] >= maxlen, "maxarms[neutral] smaller than maxlen");
constraint assert(maxface[blank] >= maxlen, "maxface[blank] smaller than maxlen");
array[LEGS,ARMS] of int: dance_value;
array[ARMS,FACE] of int: entice_value;
constraint assert(dance_value[stand,neutral] = 0, "incorrect dance_value array");
constraint assert(entice_value[neutral,blank] = 0, "incorrect entice_value array");
int: boredom; % how bored each step make the viewer

var STEP: len;
array[STEP] of var LEGS: legs;
array[STEP] of var ARMS: arms;
array[STEP] of var FACE: face;

include "regular.mzn";

constraint len < maxlen;

%LEG AUTOMATA
constraint regular([legs[i] | i in STEP], 7, 6, legsteps, 1, {7});

array[1..7, LEGS] of 0..7: legsteps =
       [| 2,0,4,5,6,7
        | 0,0,0,5,6,7
        | 2,0,4,0,0,7
        | 2,0,4,5,6,7
        | 2,0,4,0,0,7
        | 2,3,4,5,0,7
        | 2,0,4,5,6,7 |];
        

% Must prep before any leap [SEE IF NECESSARY]
%constraint forall(i in 1..len)(legs[i+1]=leap -> legs[i] = prep);

%Can't waltz more than three times in a row 

constraint forall(i in 1..len-3)((legs[i]=waltz /\ legs[i+1]=waltz /\ legs[i+2]=waltz) -> legs[i+3] != waltz);


%There must be a stand between a waltz and curtsey
%constraint forall(i in 1..len-2)(legs[i]= waltz /\ legs[i+2] = curtsey -> legs[i+1]= stand);

%constraint forall(i in 1..len-1)
%            ((legs[i] = waltz ->
%            forall(j in i+1..len)(legs[j] = curtsey -> 
%            exists(k in i+1..j-1)(legs[k] = stand))));
            
constraint forall(i in 1..len-1, j in i+1..len)((legs[i]=waltz /\ legs[j]=curtsey) -> exists(k in i+1..j-1)(legs[k]=stand));

%ARM AUTOMATA
constraint regular([arms[i] | i in STEP], 6, 5, armsteps, 1, {6});

array[1..6, ARMS] of 0..6: armsteps =
       [| 0,3,4,5,6
        | 0,3,4,5,6
        | 2,0,4,0,6
        | 2,3,0,0,6
        | 0,3,4,0,6
        | 0,3,4,5,6 |];

%No more than two arm moves in a row except neutral

%constraint forall(i in 1..len-2)((arms[i]=arms[i+1] -> arms[i+2] != arms[i+1]) in {beckon, out, up, wrapped});

constraint forall(i in 1..len-1)((arms[i+1] != arms[i] \/ arms[i] = neutral));  
        
%FACE AUTOMATA   
constraint regular([face[i] | i in STEP], 7, 6, facesteps, 1, {7});

array[1..7, FACE] of 0..7: facesteps =
       [| 2,3,4,5,6,7
        | 2,3,4,0,6,7
        | 2,0,4,5,6,7
        | 2,3,0,0,6,7
        | 2,3,4,0,6,7
        | 2,3,4,5,6,7
        | 2,3,4,5,6,7 |];

%No more than two face moves in a row except blank
%constraint forall(i in 1..len-2)((face[i] = face[i+1] -> face[i+2] != face[i+1]) in {smile, wink, batt, think, glow});
constraint forall(i in 1..len-2)(face[i] = face[i+1] -> (face[i+2] != face[i] \/ face[i+2] = blank));

%Must stay in neutral positions after dance ends
constraint forall (i in len+1..maxlen)(legs[i]=stand);
constraint forall (i in len+1..maxlen)(arms[i]=neutral);
constraint forall (i in len+1..maxlen)(face[i]=blank);

% no negative moves combinations constraint
constraint forall(i in 1..len)(dance_value[legs[i],arms[i]] >= 0); 
constraint forall(i in 1..len)(entice_value[arms[i],face[i]] >= 0);

% max moves constraints
include "global_cardinality_low_up.mzn";
constraint global_cardinality_low_up(legs, LEGS, [0 | i in LEGS], maxlegs);
constraint global_cardinality_low_up(arms, ARMS, [0 | i in ARMS], maxarms);
constraint global_cardinality_low_up(face, FACE, [0 | i in FACE], maxface);

var int: obj;

constraint obj = sum(i in 1..len)(dance_value[legs[i],arms[i]] + entice_value[arms[i],face[i]]) - boredom*len;

solve maximize obj;