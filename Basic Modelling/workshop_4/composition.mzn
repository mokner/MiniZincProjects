include "globals.mzn";
include "alldifferent.mzn";

% int: n;
% set of int: order = 1..n;
% set of int: differences = 1..n-1;

% array[differences] of int: diffarray;

% constraint alldifferent(differences);

% constraint forall(i in 1..n-1)(differences[i] = abs(order[i]-order[i-1]));

% solve satisfy;

int: n;
set of int: NOTE = 1..n;
set of int: ORDER = 1..n;

set of int: NOTEDIFFS = 1..n-1;
set of int: ORDERDIFFS = 1..n-1;

array[ORDER] of var NOTE: order;
array[ORDERDIFFS] of var NOTEDIFFS: diffs;

constraint forall (i in ORDERDIFFS)(diffs[i] = abs(order[i]-order[i+1]));

constraint alldifferent(order);
constraint alldifferent(diffs);

solve satisfy;

int: d = ceil(ln(n+1) / ln(10.0));
string: spaces = concat([ " " | i in 1..d ]);
output [ show_int(d, order[i]) ++ spaces
        | i in ORDER ]
        ++ ["\n", spaces] ++
         [ show_int(d, diffs[i]) ++ spaces
         | i in ORDERDIFFS ];