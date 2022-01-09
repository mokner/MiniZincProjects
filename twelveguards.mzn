%Twelve Guards

%write description here

array[1..12] of var 0..5 : placements;

constraint sum(placements) = 12;

constraint placements[1] + placements[2] + placements[3] + placements[4] = 5;
constraint placements[4] + placements[5] + placements[6] + placements[7] = 5;
constraint placements[7] + placements[8] + placements[9] + placements[10] = 5;
constraint placements[10] + placements[11] + placements[12] + placements[1] = 5;

solve satisfy;