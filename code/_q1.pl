% P1: Department Assignment Puzzle, Reloaded
%
% A solution is a list of four terms p(Name, Dept, Lang, Project),
% in the order 'Alex', 'Ben', 'Carla', 'Dana'.

:- use_module(library(lists)).

% candidate(-S)
% candidate(S) holds when S is a filled-in assignment for the four friends
% in which each department, each language and each project is used exactly
% once. On backtracking it generates all 24 * 24 * 24 = 13824 assignments.
candidate([p('Alex',  D1, L1, P1),
           p('Ben',   D2, L2, P2),
           p('Carla', D3, L3, P3),
           p('Dana',  D4, L4, P4)]) :-
    permutation([research, development, design, testing], [D1, D2, D3, D4]),
    permutation([python, java, 'c++', javascript],        [L1, L2, L3, L4]),
    permutation(['AI', web, embedded, data],              [P1, P2, P3, P4]).
