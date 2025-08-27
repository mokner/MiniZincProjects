% assignment 2
% select a set of raiding warrior
include "alldifferent.mzn";

enum WARRIOR;
WARRIOR: dummy;
enum CLAN; % the clan they belong too

int: l; % minimum raid party size
int: u; % maximum raid party size
int: m; % limit of hatreds

array[WARRIOR] of int: strength;
array[WARRIOR] of CLAN: clan;

array[CLAN,CLAN] of 0..1: hates;

array[1..u] of var WARRIOR: party; % our raid party

constraint alldifferent(party);

constraint sum(i,j in raid where i < j)(hates[clan[i], clan[j]]) <= m;

var int: obj = sum(s in party)(strength[s]);

solve maximize obj;

var set of WARRIOR: raid;

%constraint array2set(party) = raid;

constraint forall(p in party) (
  (p != dummy) -> (p in raid)
);


constraint not(dummy in raid);

constraint card(raid) in l..u;

output ["Strength = \(obj);\nRaid Party = \(raid);\n" ];
