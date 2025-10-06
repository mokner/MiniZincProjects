include "disjunctive.mzn";
include "globals.mzn";

% scheduling suitors
enum SUITOR;
SUITOR: LiuBei; % which suitor is LiuBei
int: n; % number of meetings
set of int: MEETING = 1..n;
array[MEETING] of SUITOR: suitor;

enum ROOM = { Red, Gold, Blue };
array[SUITOR,ROOM] of int: mintime;
array[SUITOR,ROOM] of int: maxtime;
constraint forall(s in SUITOR, r in ROOM)
                 (assert(mintime[s,r] >= 1 /\ maxtime[s,r] >= mintime[s,r],
                  "error in mintime/maxtime at [\(s),\(r)]\n"));

array[ROOM,ROOM] of int: move;
constraint forall(r in ROOM)(assert(move[r,r] = 0,"move[\(r),\(r)] != 0\n"));

int: ndays; % number of days
set of int: DAY = 1..ndays;
int: earliest; % time for earliest meeting start
int: latest;  % time for end of latest meeting

int: lessontime; % time for kung fu lesson;
int: minsep;     % minimum time between consecutive kung fu lessons

array[ROOM] of int: usedstart;  % time others use each room each day
array[ROOM] of int: useddur;    % durations of others use

enum STAGE = {A,B,C};
STAGE: stage;

set of int: TIME = 0..24*ndays;

array[MEETING] of var TIME: start;
array[MEETING] of var TIME: dur;    % duration in false schedule
array[MEETING] of var ROOM: room;
set of int: KUNGFU = 1..n;
array[KUNGFU] of var int: kungfu;  % start time for each lesson
   % unused lessons have start times after 24*ndays


array[MEETING] of var MEETING: start_index; % index of start times in chronological order

%%%%% STAGE A %%%%%

% Setting kungfu lessons out of range for stage A
constraint forall(i in KUNGFU)(kungfu[i] > 24*ndays);

% Ensures meeting start times and durations don't overlap with each other

constraint disjunctive(start, dur);

% mintime and maxtime spent for suitors in meetings constraint
constraint forall(m in MEETING)(dur[m] in mintime[suitor[m], room[m]]..maxtime[suitor[m],room[m]]);

% Rooms reserved constraint (usedtime and useddur)
constraint forall(m in MEETING)(
let {var ROOM: r = room[m];} in
disjunctive([start[m] mod 24, usedstart[r]], [dur[m], useddur[r]])
);

% Earliest and latest meeting times constraints
constraint forall(m in MEETING)(
start[m] mod 24 >= earliest
 /\ (start[m] + dur[m]) mod 24 > earliest
 /\ start[m] mod 24 < latest
 /\ (start[m]+dur[m]) mod 24 <= latest
);

%%%%% STAGE B CONSTRAINTS START HERE

%%constraint (stage = B) ->
%%%(  %%% mind these brackets

% Start index constraint
constraint arg_sort(start, start_index);

% Movement between rooms constraint

%constraint forall(m in 2..n-1)(start[start_index[m]] = start[start_index[m]] + move[room[start_index[m]], room[start_index[m+1]]]);

% constraint forall(m in 1..n-1)(
% let {var MEETING: index = start_index[m];} in
% start[index+1] = start[index] + move[room[index-1], room[index]]
% );

constraint forall(m in 1..n-1)(
let {var ROOM: r = room[start_index[m]];
     var ROOM: next_r = room[start_index[m+1]];
     var TIME: move_dur = move[r, next_r];
     array[MEETING] of var TIME: full_dur = [dur[start_index[m]] + move_dur];
     } in
     
     disjunctive(start, full_dur)
);

%%%);


% Objective function
solve maximize sum(s in MEETING where suitor[s] = LiuBei)(dur[s]);

%output["arg_sort (indices of sorted list): \(arg_sort([1, 2, 5, 4, 6, 3]))" ];
%output["start: \(start), \narg_sort (indices of sorted list): \(arg_sort(start))" ];
%output["start: \(start), \n start_index: \(start_index)" ];
%output["start: \(start), \n start_index: \(start_index), \n sorted index: \(sort(start_index))" ];