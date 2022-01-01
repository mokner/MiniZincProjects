int: area = 16;
int: cost = 1;

var 0..100: l;
var 0..100: w;
var 0..100: total_cost;

constraint area = l*w;
constraint total_cost = (2*w + 2*l)*cost;

solve minimize total_cost;