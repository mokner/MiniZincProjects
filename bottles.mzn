%Bottles

%Problem: Eva recently discovered a shelf full of bottles of wine in the cellar. She counted 24 bottles of Rioja and 17 bottles of Malbec. 
%She also noticed the price labels on the bottles: The price of one bottle of Rioja was $25 and one bottle of Malbec costs $49. 
%Suddenly, she realized that her husband had spent $2000 a week ago for just this wine. 
%How many bottles did the husband already drink?

%24 bottles of Rioja and 17 bottles of Malbec found and $2000 known to be spent, find how many bottles already drank


%----INPUTS------------------

%number of bottles
int: rioja_num; 
int: malbec_num;

%price of each bottle
int: rioja_price;
int: malbec_price;

%total spent that week
int: total_price;

%money spent of bottles found
int: bottles_found_cost = rioja_price*rioja_num + malbec_price*malbec_num;

%money spent of missing bottles
int: bottles_missing_cost = total_price - bottles_found_cost;

%number of missing rioja and malbec bottles (rounded down to integer)
int: rioja_missing = floor(bottles_missing_cost/rioja_price);
int: malbec_missing = floor(bottles_missing_cost/malbec_price);

%-------VARIABLES-----------------------
%find how many bottles already drank
var min(rioja_missing, malbec_missing)..max(rioja_missing, malbec_missing): bottles_drunk;
var 0..floor(bottles_missing_cost/rioja_price): rioja_drunk;
var 0..floor(bottles_missing_cost/malbec_price): malbec_drunk;

%-------CONSTRAINTS----------------------
constraint rioja_drunk*rioja_price + malbec_drunk*malbec_price = bottles_missing_cost;
constraint bottles_drunk = malbec_drunk + rioja_drunk;



solve satisfy;