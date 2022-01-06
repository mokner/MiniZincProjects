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


%-------VARIABLES-----------------------
var 0..floor(total_price/rioja_price): rioja_bought;
var 0..floor(total_price/malbec_price): malbec_bought;

var int: rioja_drunk;
var int: malbec_drunk;
%-------CONSTRAINTS----------------------
constraint rioja_bought*rioja_price + malbec_bought*malbec_price = total_price;

constraint rioja_drunk = rioja_bought - rioja_num;
constraint rioja_drunk >= 0;
constraint malbec_drunk = malbec_bought - malbec_num /\ malbec_drunk >= 0;
%output ["Rioja drunk:", rioja_bought - rioja_num];

solve satisfy;