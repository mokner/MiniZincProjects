include "disjunctive.mzn";

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

%%%%% STAGE A %%%%%

% Setting kungfu lessons out of range for stage A
constraint forall(i in KUNGFU)(kungfu[i] > 24*ndays);

% Ensures meeting start times and durations don't overlap with each other

constraint disjunctive(start, dur);

% mintime and maxtime spent for suitors in meetings constraint
constraint forall(m in MEETING)(dur[m] in mintime[suitor[m], room[m]]..maxtime[suitor[m],room[m]]);

% Rooms reserved constraint (usedtime and useddur)

% constraint forall(r in room) (if room[r] = Red then not(start[r] in usedstart[Red]-useddur[Red]..usedstart[Red]+useddur[Red])
%                  elseif room[r] = Gold then not(start[r] in usedstart[Gold]-useddur[Gold]..usedstart[Gold]+useddur[Red])
%                    else not(start[r] in usedstart[Blue]-useddur[Blue]..usedstart[Blue]+useddur[Blue]) endif);

% constraint forall(r in room) (if room[r] = Red then not(usedstart[Red] in start[r]-useddur[Red]..start[r]+useddur[Red])
%                  elseif room[r] = Gold then not(usedstart[Gold] in start[r]-useddur[Gold]..start[r]+useddur[Gold])
%                    else not(usedstart[Blue] in start[r]-useddur[Blue]..start[r]+useddur[Blue]) endif);

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

%constraint forall(m in MEETING)((start[m]+dur[m]) mod 24 <= latest);

% Objective function
solve maximize sum(s in MEETING where suitor[s] = LiuBei)(dur[s]);
