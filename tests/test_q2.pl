% Tests for P2 (code/34_q2.pl).
% Run from the repository root:
%   swipl -q -f tests/test_q2.pl -g run_tests -t halt

:- use_module(library(plunit)).
:- use_module(library(lists)).

% Load the solution file relative to this test file.
:- prolog_load_context(directory, Dir),
   atom_concat(Dir, '/../code/34_q2.pl', File),
   consult(File).

:- begin_tests(p2).

% --- Canonical to_string/2 examples ----------------------------------------

test(canonical_add_mul) :-
    to_string((4+2)*3, S),
    S == "(4+2)*3".

test(canonical_mul_add) :-
    to_string(4+2*3, S),
    S == "4+2*3".

test(canonical_div_mul_left) :-
    to_string(8/4*2, S),
    S == "8/4*2".

test(canonical_div_mul_right) :-
    to_string(8/(4*2), S),
    S == "8/(4*2)".

test(canonical_sub_left) :-
    to_string(1-2-3, S),
    S == "1-2-3".

test(canonical_sub_right) :-
    to_string(1-(2-3), S),
    S == "1-(2-3)".

test(canonical_add_right) :-
    to_string(1+(2+3), S),
    S == "1+(2+3)".

test(canonical_add_left) :-
    to_string(1+2+3, S),
    S == "1+2+3".

% --- Assignment examples ---------------------------------------------------

test(generate_equation_assignment_example, [nondet]) :-
    generate_equation([4,2,5,3], Eq),
    memberchk(Eq, ["4*2-5=3", "4*2=5+3", "4-2=5-3", "4/2=5-3",
                   "4=2*(5-3)", "4=2+(5-3)", "4=2+5-3"]).

test(all_equations_assignment_example) :-
    all_equations([4,2,5,3], Es),
    Es == ["4*2-5=3", "4*2=5+3", "4-2=5-3", "4/2=5-3",
           "4=2*(5-3)", "4=2+(5-3)", "4=2+5-3"].

test(count_equations_assignment_example) :-
    count_equations([4,2,5,3], 7).

test(generate_equation_fails_for_2_3_4, [fail]) :-
    generate_equation([2,3,4], _).

test(all_equations_empty_for_2_3_4) :-
    all_equations([2,3,4], Es),
    Es == [].

test(count_equations_zero_for_2_3_4) :-
    count_equations([2,3,4], 0).

test(all_equations_for_2_4_8) :-
    all_equations([2,4,8], ["2*4=8"]).

test(count_equations_for_2_4_8) :-
    count_equations([2,4,8], 1).

% --- Edge cases: empty list and single-element list ------------------------

test(generate_equation_empty_list, [fail]) :-
    generate_equation([], _).

test(generate_equation_single_element, [fail]) :-
    generate_equation([5], _).

test(all_equations_empty_list) :-
    all_equations([], []).

test(all_equations_single_element) :-
    all_equations([5], []).

test(count_equations_empty_list) :-
    count_equations([], 0).

test(count_equations_single_element) :-
    count_equations([5], 0).

% --- Edge cases: [3,3] and [0,0] -------------------------------------------

test(two_elements_3_3) :-
    all_equations([3,3], ["3=3"]),
    count_equations([3,3], 1).

test(two_elements_0_0) :-
    all_equations([0,0], ["0=0"]),
    count_equations([0,0], 1).

% --- Output type: results are SWI-Prolog strings ---------------------------

test(result_is_string, [nondet]) :-
    generate_equation([4,2,5,3], Eq),
    string(Eq),
    all_equations([4,2,5,3], Es),
    forall(member(E, Es), string(E)).

% --- Division by zero & inexact division -----------------------------------

test(division_by_zero_never_raises, [fail]) :-
    expr([4, 0], _ / _, _).

test(division_by_zero_in_equation_search_never_raises) :-
    % Evaluating lists containing zeros must not raise zero_divisor error
    all_equations([3, 0, 5], _).

test(inexact_division_rejected, [fail]) :-
    expr([5, 2], _ / _, _).

test(inexact_division_not_in_equations) :-
    all_equations([5, 2, 2], Es),
    \+ memberchk("5/2=2", Es).

% --- Negative intermediate values ------------------------------------------

test(negative_intermediate_values, [nondet]) :-
    expr([3, 5, 4], (3 - 5) * 4, -8).

% --- Sorting & uniqueness --------------------------------------------------

test(results_sorted_and_no_duplicates) :-
    all_equations([4,2,5,3], Es),
    sort(Es, Sorted),
    Es == Sorted,
    findall(E, generate_equation([4,2,5,3], E), Raw),
    sort(Raw, Deduplicated),
    Es == Deduplicated.

:- end_tests(p2).
