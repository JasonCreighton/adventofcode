puzzle_input([1, 2, 3, 5, 7, 13, 17, 19, 23, 29, 31, 37, 41, 43, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113]).

% Except for 1, they are all prime numbers for some reason?
%
% These numbers sum to 1536, so each group weighs 1536 / 3 = 512.
%
% We need the fewest possible packages in group 1. Since the weights are all
% odd, the number of packages will be even, in order to sum to an even
% number (512). 4 packages is clearly not enough, so it must be 6.
%
% Intuitively it seems like we should pick large numbers to minimize the
% product. So could it be that the first group is just this?
%
%     113 + 109 + 107 + 103 + 79 + 1 = 512
%
% This assumes that there is some way to divide the remaining numbers among the
% other groups.
%
% And indeed this is the correct answer.
%
% For part two, there are 4 groups. Maybe we can get lucky again?
%
% Each group weighs 1536 / 4 = 384. Again, we need to produce an even number,
% so we expect four packages in the first group.
%
% So how about?
%
%     113 + 109 + 103 + 59 = 384
%
% And this works as well.

part1_hand_solution([113,109,107,103,79,1]).
part2_hand_solution([113,109,103,59]).

product_(A, B, P) :- P is A*B.
list_product(Ls, P) :- foldl(product_, Ls, 1, P).

part1_answer(X) :- part1_hand_solution(Sol), list_product(Sol, X).
part2_answer(X) :- part2_hand_solution(Sol), list_product(Sol, X).
