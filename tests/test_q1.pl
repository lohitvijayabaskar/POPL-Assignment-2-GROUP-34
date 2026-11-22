% Tests for P1 (code/_q1.pl).
% Run from the repository root:
%   swipl -q -f tests/test_q1.pl -g run_tests -t halt

:- use_module(library(plunit)).
:- use_module(library(lists)).
:- use_module(library(apply)).

% Load the solution file relative to this test file.
:- prolog_load_context(directory, Dir),
   atom_concat(Dir, '/../code/_q1.pl', File),
   consult(File).

% main_lines(-Lines)
% Lines is the list of non-empty lines that main/0 prints.
main_lines(Lines) :-
    with_output_to(string(Out), main),
    split_string(Out, "\n", "\r", Parts),
    exclude(==(""), Parts, Lines).

% solution_text(+S, -Text)
% Text is exactly what print_solution/1 prints for S.
solution_text(S, Text) :-
    with_output_to(string(Text), print_solution(S)).

:- begin_tests(p1).

% --- P1.a: main/0 -----------------------------------------------------------

test(main_prints_four_lines) :-
    main_lines(Lines),
    length(Lines, 4).

test(main_order_and_format) :-
    main_lines([A, B, C, D]),
    line_ok(A, "Alex"),
    line_ok(B, "Ben"),
    line_ok(C, "Carla"),
    line_ok(D, "Dana").

% The text main prints is exactly the printout of some solution of clues 1-8.
test(main_solution_satisfies_clues_1_to_8) :-
    with_output_to(string(Out), main),
    findall(T, ( candidate(S),
                 satisfies([1,2,3,4,5,6,7,8], S),
                 solution_text(S, T) ), Texts),
    memberchk(Out, Texts).

% Atoms are printed without quotes.
test(main_prints_no_quotes) :-
    with_output_to(string(Out), main),
    \+ sub_string(Out, _, _, _, "'").

% --- P1.b: count_solutions/2 ------------------------------------------------

test(count_clues_1_to_8) :-
    count_solutions([1,2,3,4,5,6,7,8], N),
    N =:= 3.

test(count_clues_1_to_9) :-
    count_solutions([1,2,3,4,5,6,7,8,9], N),
    N =:= 1.

test(count_no_clues) :-
    count_solutions([], N),
    N =:= 13824.

test(count_order_does_not_matter) :-
    count_solutions([1,2,3,4,5,6,7,8], N1),
    count_solutions([8,7,6,5,4,3,2,1], N2),
    count_solutions([5,1,8,3,7,2,6,4], N3),
    N1 =:= N2, N2 =:= N3.

test(count_repeated_clue_counts_once) :-
    count_solutions([1], N1),
    count_solutions([1,1,1], N2),
    N1 =:= N2.

% --- P1.c: clue 9 ------------------------------------------------------------

test(clue9_keeps_exactly_one_solution) :-
    findall(S, ( candidate(S),
                 satisfies([1,2,3,4,5,6,7,8], S),
                 clue(9, S) ), Kept),
    length(Kept, 1).

test(clue9_rejects_the_other_two) :-
    findall(S, ( candidate(S),
                 satisfies([1,2,3,4,5,6,7,8], S),
                 \+ clue(9, S) ), Rejected),
    length(Rejected, 2).

test(clue9_kept_solution) :-
    findall(S, ( candidate(S),
                 satisfies([1,2,3,4,5,6,7,8,9], S) ), [Sol]),
    Sol == [p('Alex', design, java, embedded),
            p('Ben', development, javascript, web),
            p('Carla', testing, python, 'AI'),
            p('Dana', research, 'c++', data)].

:- end_tests(p1).

% line_ok(+Line, +Name)
% Line has the form "Name = [Dept, Lang, Project]" for the given Name.
line_ok(Line, Name) :-
    string_concat(Name, Rest, Line),
    string_concat(" = [", Inner0, Rest),
    string_concat(Inner, "]", Inner0),
    split_string(Inner, ",", " ", Fields),
    length(Fields, 3),
    \+ memberchk("", Fields).
