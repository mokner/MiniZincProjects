%Bottles
%A bunch of bottles found and $2000 known to be spent, find how many bottles already drank

%number of bottles
int: rioja_num = 24; 
int: malbec_num = 17;
%price of each bottle
int: rioja_price = 25;
int: malbec_price = 49;
%total spent that week
int: total_spent = 2000;
%money spent of bottles found
int: bottles_found_cost = rioja_price*rioja_num + malbec_price*malbec_num;
%money spent of missing bottles
int: bottles_missing_cost = total_spent - bottles_found_cost;

%find how many he drank
var 0..200: bottles_drunk;
var 0..100: malbec_drunk;
var 0..100: rioja_drunk;

constraint rioja_drunk*rioja_price + malbec_drunk*malbec_price = bottles_missing_cost;
constraint bottles_drunk = malbec_drunk + rioja_drunk;

solve minimize bottles_drunk;