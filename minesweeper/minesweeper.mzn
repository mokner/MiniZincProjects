% Minesweeper (based on Hakan's model - https://www.hakank.org/minizinc/minesweeper.mzn)

int: r; % rows
int: c; % column
int: X = -1; % the unknowns

% encoding: -1 for unknown, >= 0 for number of mines in the neighbourhood
array[1..r, 1..c] of -1..8: game;  % any given cell can have up to 8 mines surrounding it
array[1..r, 1..c] of var 0..1: mines; % a cell without/with a mine is represented by 0/1

% surrounding mines constraint
constraint
    forall(i in 1..r, j in 1..c) (
       % if game[i,j] >= 0, then it is a numbered tile
       if game[i,j] >= 0 then
       % sum of mines in surrounding area must be equal to value of numbered tile game[i,j] 
            game[i,j] = sum(a,b in {-1,0,1} where % a,b are coords of mines in neighbourhood of game[i,j]
               % accounts for out of bounds of board (mines cannot be placed outside of dimensions r,c)  
               i+a > 0  /\ j+b > 0 /\
               i+a <= r /\ j+b <= c    
            ) (mines[i+a,j+b]) % surrounding mines
       else
          true
       endif
      /\ (game[i,j] > X -> mines[i,j] = 0) % no mines on tiles that indicate surrounding mines (numbered tiles)
      % /\ (game[i,j] = X <- mines[i,j] = 1) 
    )
;

% solve satisfy;
solve :: int_search([mines[i,j] | i in 1..r, j in 1..c], first_fail, indomain_min, complete) satisfy;
