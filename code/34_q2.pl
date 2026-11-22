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
