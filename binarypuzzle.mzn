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
constraint forall(i in 1..SIZE-2)
              (forall(j in 1..SIZE-2)
                (if solution[i, j] = solution[i, j+1] then solution[i, j+2] != solution[i, j+1] endif));

constraint forall(j in 1..SIZE-2)
              (forall(i in 1..SIZE-2)
                (if solution[i, j] = solution[i+1, j] then solution[i+2, j] != solution[i+1, j] endif));


% each row and column must have an equal number of 0s and 1s
constraint forall(i in ROWS)
              (sum(j in COLUMNS where solution[i,j] = 0)(1) = sum(j in COLUMNS where solution[i,j] = 1)(1));
              
constraint forall(j in COLUMNS)
              (sum(i in ROWS where solution[i,j] = 0)(1) = sum(i in ROWS where solution[i,j] = 1)(1));
               

% each row and column must be unique


solve satisfy;