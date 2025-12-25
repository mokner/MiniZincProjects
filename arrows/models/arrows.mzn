include "diffn.mzn";
include "lex_lesseq.mzn";

int: length; % height of lake
set of int: LENGTH = 0..length-1;
int: width; % width of lake
set of int: WIDTH = 0..width-1;

int: ntypes;  % number of types of ship
set of int: TYPE = 1..ntypes;
array[TYPE] of int: number;         % number of each type of ship
array[TYPE] of set of SHAPE: config; % configs for each type of ship

int: nshapes; % number of shapes
set of int: SHAPE = 1..nshapes;
set of int: SHAPE0 = 0..nshapes;
array[SHAPE] of set of ROFF: shape;

int: nroff; % number of rectangle offsets
set of int: ROFF = 1..nroff;
array[ROFF,1..4] of int: rectoff; % x offset, y offset, width, height

int: total_ships = sum(number);
set of int: SHIP = 1..total_ships;
array[SHIP] of var LENGTH:  x;
array[SHIP] of var WIDTH:   y;
array[SHIP] of var SHAPE0:  k;

array[LENGTH] of WIDTH: mist; % mist starts at this width, goes downward
array[WIDTH] of int: arrow;  % number of arrows that arrive at this height
array[TYPE] of int: price;
int: budget;
enum STAGE = {A,B,C,D,E,F};
STAGE: stage;



%%% STAGE A

% ship type arrays (types, lengths, and widths)

array[TYPE] of int: ship_sum = [ sum(i in 1..t-1)(number[i]) | t in TYPE ];
array[SHIP] of TYPE: ship_types = [max(ty in TYPE)(ty*(s > ship_sum[ty])) | s in SHIP];

array[SHIP] of int: ship_len =
            [ rectoff[ship_types[s], 3] | s in SHIP ];
            
array[SHIP] of int: ship_wid =
            [ rectoff[ship_types[s], 4] | s in SHIP ];

constraint (stage = A) -> 
(

  % overlap constraint
  diffn(x, y, ship_len, ship_wid)
  
  /\
  % boundaries constraint
  forall(s in SHIP)( x[s] + ship_len[s] <= length /\ y[s] + ship_wid[s] <= width )
  /\
  
  %%%% symmetry constraints %%%%
  % x axis flip
  let { array[SHIP] of var LENGTH: s_len;} in
      forall(i in SHIP)(s_len[i] = length-x[i]-ship_len[i]) /\
      lex_lesseq(x, s_len)
  /\
  
   % y axis flip
   let { array[SHIP] of var WIDTH: s_wid;} in
      forall(i in SHIP)(s_wid[i] = width-y[i]-ship_wid[i]) /\
      lex_lesseq(y, s_wid)
  %/\

);

%%% STAGE B



solve minimize budget;