array[int] of int: readings;
int: start;
int: n = length(readings);
set of int: HOUR = 1..n;
set of int: HOUR0 = 0..n;

var int: cost = sum(h in HOUR0)(choice_cost[tempchoice[h]]);

enum CHOICE = {heat, strongly_heat, cool, strongly_cool, do_nothing};
array[CHOICE] of int: choice_cost = [1, 5, 3, 9, 0];
array[CHOICE] of int: change_temp = [1, 4, -2, -5, 0];

array[HOUR0] of var 25..30: temp;
array[HOUR] of var CHOICE: tempchoice;

constraint temp[0] = start;

constraint forall(h in HOUR)
                 (temp[h] = (temp[h-1] + readings[h]) div 2 + change_temp[tempchoice[h]]);
             
solve minimize cost;



output ["temp = \(temp);\n"];
%output ["choice = \(tempchoice_out);\n"];
%output ["cost = \(cost);\n"];