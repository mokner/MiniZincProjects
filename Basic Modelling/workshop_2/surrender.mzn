% workshop 2
% select a set of trade negotiation party
enum NEGOTIATOR;
NEGOTIATOR: dummy; 

int: l; % minimum party size
int: u; % maximum party size
int: m; % minimum joint ability

array[NEGOTIATOR] of int: honor;
array[NEGOTIATOR,NEGOTIATOR] of int: joint;

array[1..u] of var NEGOTIATOR: party;

constraint forall(i in 1..u-1)(party[i] >= party[i+1]
                               + (party[i] != dummy));

constraint forall(i in 1..l)(party[i] != dummy);

constraint sum(i,j in 1..u where i < j)(joint[party[i], party[j]]) >= m;

solve maximize obj;

var int: obj;

constraint obj = min(i in 1..u)(honor[party[i]] + (party[i] = dummy) * (max(honor) + 1));

%var set of NEGOTIATOR: x;
%
%constraint not(dummy in x);
%constraint card(x) >= l;
%constraint card(x) <= u;
%
%constraint sum(i,j in x where i < j)(joint[i,j]) >= m;5
%
%var int: minhonor;
%constraint minhonor = min([honor[i] | i in NEGOTIATOR where i in x]);
%
%solve maximize minhonor;
%
%output ["party = \(x);\nobj = \(minhonor);\n"]