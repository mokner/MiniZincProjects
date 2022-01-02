%Bottles

%Problem: Eva recently discovered a shelf full of bottles of wine in the cellar. She counted 24 bottles of Rioja and 17 bottles of Malbec. She also noticed the price labels on the bottles: The price of one bottle of Rioja was $25 and one bottle of Malbec costs $49 . Suddenly, she realized that her husband had spent $2000 a week ago for just this wine. How many bottles did the husband already drink?

%24 bottles of Rioja and 17 bottles of Malbec found and $2000 known to be spent, find how many bottles already drank

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

%find how many bottles already drank
var 0..40: bottles_drunk;
var 0..20: rioja_drunk;
var 0..20: malbec_drunk;

constraint rioja_drunk*rioja_price + malbec_drunk*malbec_price = bottles_missing_cost;
constraint bottles_drunk = malbec_drunk + rioja_drunk;

solve satisfy;