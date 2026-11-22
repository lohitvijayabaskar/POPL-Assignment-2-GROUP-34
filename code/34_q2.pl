% P2: Expression trees with exact division

:- use_module(library(lists)).

% expr(+Nums, -Tree, -Value)
% expr(Nums, Tree, Value) holds when Tree is an arithmetic expression tree
% that uses every integer of the non-empty list Nums exactly once and in
% order, and Value is its exact integer value.
expr([X], X, X).
expr([X, Y | Rest], Tree, Value) :-
    append([L|Ls], [R|Rs], [X, Y | Rest]),
    expr([L|Ls], LTree, LVal),
    expr([R|Rs], RTree, RVal),
    eval_op(LTree, LVal, RTree, RVal, Tree, Value).

% eval_op(+LTree, +LVal, +RTree, +RVal, -Tree, -Value)
% eval_op(LTree, LVal, RTree, RVal, Tree, Value) holds when Tree is the compound
% expression combining LTree and RTree with one of +, -, *, /, and Value is its
% resulting integer value. Division is allowed only if the divisor is non-zero
% and the division is exact.
eval_op(LTree, LVal, RTree, RVal, LTree + RTree, Value) :-
    Value is LVal + RVal.
eval_op(LTree, LVal, RTree, RVal, LTree - RTree, Value) :-
    Value is LVal - RVal.
eval_op(LTree, LVal, RTree, RVal, LTree * RTree, Value) :-
    Value is LVal * RVal.
eval_op(LTree, LVal, RTree, RVal, LTree / RTree, Value) :-
    RVal =\= 0,
    LVal mod RVal =:= 0,
    Value is LVal // RVal.

% to_string(+Tree, -String)
% to_string(Tree, String) holds when String is the canonical SWI-Prolog string
% representation of the arithmetic expression tree Tree with no spaces.
to_string(Tree, String) :-
    number(Tree),
    !,
    number_string(Tree, String).
to_string(Tree, String) :-
    Tree =.. [Op, Left, Right],
    op_prec(Op, Prec),
    left_to_string(Left, Prec, LStr),
    right_to_string(Right, Prec, RStr),
    format(string(String), "~w~w~w", [LStr, Op, RStr]).

% left_to_string(+Tree, +ParentPrec, -String)
% left_to_string(Tree, ParentPrec, String) converts the left child Tree to a
% string, enclosing it in parentheses only if Tree is a compound expression
% whose top operator has strictly lower precedence than ParentPrec.
left_to_string(Tree, ParentPrec, String) :-
    compound(Tree),
    Tree =.. [Op, _, _],
    op_prec(Op, Prec),
    Prec < ParentPrec,
    !,
    to_string(Tree, Inner),
    format(string(String), "(~w)", [Inner]).
left_to_string(Tree, _ParentPrec, String) :-
    to_string(Tree, String).

% right_to_string(+Tree, +ParentPrec, -String)
% right_to_string(Tree, ParentPrec, String) converts the right child Tree to a
% string, enclosing it in parentheses if Tree is a compound expression whose
% top operator has equal or lower precedence than ParentPrec.
right_to_string(Tree, ParentPrec, String) :-
    compound(Tree),
    Tree =.. [Op, _, _],
    op_prec(Op, Prec),
    Prec =< ParentPrec,
    !,
    to_string(Tree, Inner),
    format(string(String), "(~w)", [Inner]).
right_to_string(Tree, _ParentPrec, String) :-
    to_string(Tree, String).

% op_prec(+Op, -Prec)
% op_prec(Op, Prec) defines the operator precedence: * and / bind tighter (2)
% than + and - (1).
op_prec(+, 1).
op_prec(-, 1).
op_prec(*, 2).
op_prec(/, 2).

% generate_equation(+List, -Equation)
% generate_equation(List, Equation) holds when Equation is a string "L=R"
% where L is an expression over a non-empty prefix of List and R is an
% expression over the remaining non-empty suffix, both evaluating to the
% same integer value, formatted with to_string/2.
generate_equation(List, Equation) :-
    append([L|Ls], [R|Rs], List),
    findall(r(RTree, Val), expr([R|Rs], RTree, Val), Rights),
    Rights \== [],
    expr([L|Ls], LTree, Val),
    member(r(RTree, Val), Rights),
    to_string(LTree, LStr),
    to_string(RTree, RStr),
    format(string(Equation), "~w=~w", [LStr, RStr]).

% all_equations(+List, -Equations)
% all_equations(List, Equations) holds when Equations is the list of all
% unique valid equations for List, sorted in standard order via sort/2,
% or [] if no valid equations exist.
all_equations(List, Equations) :-
    findall(Eq, generate_equation(List, Eq), Raw),
    sort(Raw, Equations).
