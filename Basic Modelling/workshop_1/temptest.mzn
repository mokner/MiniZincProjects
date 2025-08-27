array[int] of int: readings;
int: start;
int: n = length(readings);
set of int: HOUR = 1..n;
set of int: HOUR0 = 0..n;



array[HOUR0] of var 25..30: temp;
array[HOUR] of var 25..30: temp_output;
array[HOUR] of var CHOICE: tempchoice;

constraint forall(h in HOUR)(temp_output[h] = temp[h]); %FOR OUTPUT

enum CHOICE = {heat, strongly_heat, cool, strongly_cool, do_nothing};
array[CHOICE] of int: change_temp = [1, 4, -2, -5, 0];
array[CHOICE] of int: choice_cost = [1, 5, 3, 9, 0];

constraint temp[0] = start;

constraint forall(h in HOUR)
                 (temp[h] = (temp[h-1] + readings[h]) div 2 + change_temp[tempchoice[h]]);
           
var int: cost = sum(h in HOUR)(choice_cost[tempchoice[h]]);  
                 
solve minimize cost;

output ["temp = \(temp);\n choice = \(tempchoice);\n cost = \(cost);\n"];