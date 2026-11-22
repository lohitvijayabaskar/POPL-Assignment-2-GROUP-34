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

% clue(+N, +S)
% clue(N, S) holds when clue number N is true in the fully ground solution S.
% Every clause is deterministic: "the friend who ..." clues use forall/2,
% and clues about a named friend use memberchk/2 (each name occurs once),
% so no clause can succeed more than once for the same S.

% CLUE 1: The friend who prefers the AI project does not work in research
% and is not Dana.
clue(1, S) :-
    forall(member(p(Name, Dept, _, 'AI'), S),
           ( Dept \== research, Name \== 'Dana' )).

% CLUE 2: Alex does not work in development and does not prefer C++.
clue(2, S) :-
    memberchk(p('Alex', Dept, Lang, _), S),
    Dept \== development,
    Lang \== 'c++'.

% CLUE 3: The friend working in the testing department likes Python.
clue(3, S) :-
    forall(member(p(_, testing, Lang, _), S),
           Lang == python).

% CLUE 4: Ben prefers web projects and does not work in testing.
clue(4, S) :-
    memberchk(p('Ben', Dept, _, Project), S),
    Project == web,
    Dept \== testing.

% CLUE 5: The friend whose favorite language is Java works in the design
% department.
clue(5, S) :-
    forall(member(p(_, Dept, java, _), S),
           Dept == design).

% CLUE 6: Carla's project preference is not embedded, and her department is
% not development.
clue(6, S) :-
    memberchk(p('Carla', Dept, _, Project), S),
    Project \== embedded,
    Dept \== development.

% CLUE 7: Dana's favorite language is not Java, and she works in research or
% testing.
clue(7, S) :-
    memberchk(p('Dana', Dept, Lang, _), S),
    Lang \== java,
    memberchk(Dept, [research, testing]).

% CLUE 8: The friend who prefers data projects works in research and does not
% use JavaScript.
clue(8, S) :-
    forall(member(p(_, Dept, Lang, data), S),
           ( Dept == research, Lang \== javascript )).

% satisfies(+Active, +S)
% satisfies(Active, S) holds when clue(N, S) holds for every clue number N
% in the list Active. An empty Active list is satisfied by every S.
% forall/2 succeeds at most once and leaves no choice points, so S is
% counted at most once when this is used inside findall/3 or aggregate_all/3.
satisfies(Active, S) :-
    forall(member(N, Active), clue(N, S)).

% main
% main succeeds after printing the first generated assignment that
% satisfies clues 1 to 8, one line per friend, in the order Alex, Ben,
% Carla, Dana. The cut keeps only the first solution, so exactly one
% solution is printed.
main :-
    candidate(S),
    satisfies([1, 2, 3, 4, 5, 6, 7, 8], S),
    !,
    print_solution(S).

% print_solution(+S)
% print_solution(S) prints each p(Name, Dept, Lang, Project) of S on its own
% line as "Name = [Dept, Lang, Project]". ~w prints atoms without quotes,
% so 'AI' appears as AI and 'c++' as c++.
print_solution(S) :-
    forall(member(p(Name, Dept, Lang, Project), S),
           format("~w = [~w, ~w, ~w]~n", [Name, Dept, Lang, Project])).
