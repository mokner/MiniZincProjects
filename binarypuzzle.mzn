% BINARY PUZZLE %

int: SIZE; % dimension of puzzle (row size = column size)

set of int: INIT = -1..1; % possible starting config of initial puzzle (-1 represents empty space)
set of int: MOVES = 0..1; % possible moves can be 0 or 1, blank spaces must be filled with 0 or 1
set of int: ROWS = 1..SIZE;
set of int: COLUMNS = 1..SIZE;

array[ROWS, COLUMNS] of INIT: puzzle;

array[ROWS, COLUMNS] of var MOVES: solution;

% CONSTRAINTS %

% starting numbers in initial puzzle must be the same in the solution %
constraint forall(i in ROWS, j in COLUMNS where puzzle[i, j] >= 0)(puzzle[i, j] = solution[i, j]);

% can't have the same number appear more than twice in a row or column


% each row and column must have an equal number of 0s and 1s


% each row and column must be unique


solve satisfy;