---
name: prolog-dev
description: Conventions, allowed libraries, run/test commands, a self-review checklist and known AI failure modes for writing SWI-Prolog 9.x code in this assignment.
---

# Prolog development (SWI-Prolog 9.x)

Apply everything in this file whenever you write, change or review Prolog code for this repository.

## 1. Language and environment
- Target: **SWI-Prolog 9.x**.
- Solution files live in `code/`, tests in `tests/`.
- A solution file contains only directives that load allowed libraries, plus clauses (definitions).

## 2. Allowed and forbidden
**Allowed libraries (only these):**
```prolog
:- use_module(library(lists)).
:- use_module(library(apply)).
:- use_module(library(yall)).
:- use_module(library(aggregate)).
```
Built-in predicates that need no library (`format/2`, `forall/2`, `findall/3`, `sort/2`,
`number_string/2`, `between/3`, ...) are fine.

**Forbidden in solution files:**
- `assert/1`, `asserta/1`, `assertz/1`, `retract/1`, `retractall/1`.
- Global variables: `b_setval/2`, `b_getval/2`, `nb_setval/2`, `nb_getval/2`.
- `halt/0` or `halt/1` anywhere in the file (the grader adds `-t halt`).
- Any `:- initialization(...)` directive.
- Printing anything that the task does not ask for: no debug output, no `print_message`,
  no stray `write/1`. Only the predicate that is specified to print (e.g. `main/0`) prints.
- Any other library (`clpfd`, `dcg/basics`, `strings`, `apply_macros`, ...).

## 3. Coding conventions
- Predicate and atom names in `snake_case`; variables in `CamelCase`; `_` or `_Name` for unused
  variables (no singleton warnings).
- Above every predicate, a comment with:
  1. a **mode line** giving each argument as `+In`, `-Out` or `?Either`, and
  2. a **declarative reading**: "`p(X, Y)` holds when ...".

  ```prolog
  % count_items(+List, -N)
  % count_items(List, N) holds when N is the number of elements of List.
  ```
- Keep all clauses of one predicate together (no discontiguous warnings).
- Prefer pure, relational code. Use a cut `!` only when needed, with a comment saying why
  (for example "first solution only").
- Compare ground terms with `==` / `\==`; compare numbers with `=:=`, `=\=`, `<`, `>=` ...;
  use `=` only when unification is really meant.
- Integer division: check exactness with `mod` first, then use `//` (never `/`, which may give
  a float or rational).
- Quote atoms that need quotes: `'Alex'`, `'AI'`, `'c++'`.
- SWI-Prolog strings (`"abc"`) are not atoms or code lists. Build them with
  `format(string(S), Fmt, Args)`, `number_string/2` or `string_concat/3`.
- Do one unit of work per answer: one predicate (with at most small helpers it needs), one test
  file, or one review. Do not write predicates that were not asked for.

## 4. Running code
From the folder that holds the file:
```powershell
swipl -q -f code/<file>.pl -g main -t halt
swipl -q -f code/<file>.pl -g "<goal>" -t halt
```
Example: `swipl -q -f code/G_q1.pl -g "count_solutions([1,2,3],N), print(N), nl" -t halt`.
A goal that fails prints a warning and exits with a non-zero status; that is expected for
"must fail" cases.

## 5. Testing
- One test file per problem: `tests/test_qN.pl`, written with `plunit`.
- The test file loads the solution relative to its own location:
  ```prolog
  :- use_module(library(plunit)).
  :- prolog_load_context(directory, Dir),
     atom_concat(Dir, '/../code/<file>.pl', F),
     consult(F).

  :- begin_tests(qN).
  test(example) :- my_pred([1,2], 3).
  test(no_answer, [fail]) :- my_pred([], _).
  test(several, [nondet]) :- my_pred(_, _).
  :- end_tests(qN).
  ```
- Run: `swipl -q -f tests/test_qN.pl -g run_tests -t halt`.
- Tests include every example from the assignment, plus edge cases: empty list, one element,
  zeros, negative intermediate values, division by zero, cases that must fail, and duplicate
  answers.
- `plunit` is allowed in test files only, never in solution files.

## 6. Self-review checklist (apply before every answer)
Go through each item and fix the code before answering:
1. **Loads cleanly:** no syntax errors, no singleton-variable or discontiguous warnings.
2. **Only allowed things:** only the four libraries; no assert/retract, global variables,
   `halt`, or `initialization`.
3. **No extra output:** nothing is printed except what the task specifies, in exactly the
   specified format (spaces, brackets, commas, newlines, no quotes around atoms).
4. **Terminates:** no left recursion; every recursive call works on a smaller input; generators
   are finite.
5. **Fails, not errors:** cases that must fail actually fail, and do not raise errors such as
   unbound arguments to `is/2` or division by zero.
6. **No duplicate solutions:** a goal used inside `findall/3` or `aggregate_all/3` succeeds at
   most once per answer (`memberchk/2` or `forall/2` where `member/2` would leave choice points).
7. **Right types:** strings where strings are required, atoms where atoms are required.
8. **Not hard-coded:** answers are derived by the program, not written into it.
9. **Comments:** each predicate has its mode line and declarative reading.
10. **Tested:** the assignment examples have been run (or the exact commands to run them are
    given).

## 7. Known failure modes of AI tools in Prolog
Watch for these mistakes in your own output:
- Inventing built-ins or using libraries that are not allowed (`string_join/3`, `format_atom/3`,
  `clpfd` constraints such as `#=`).
- Using `=` where `==` or `=:=` is needed, or comparing before the variables are bound.
- Putting `\+` (negation as failure) in front of a goal with unbound variables, which changes
  its meaning.
- Leaving choice points with `member/2`, so `findall`/`aggregate_all` counts an answer twice.
- Using `/` for integer division and getting `2.5` or `5r2` instead of failing or an integer.
- Returning an atom or a code list where an SWI string is required, or the reverse.
- Printing with `print/1` or `writeq/1`, which adds quotes (`'AI'`) where `~w` would not.
- Adding `:- initialization(main).` or `halt.` out of habit.
- Writing infinite generators (unbounded `length/2`, left-recursive grammar rules) that loop
  instead of failing.
- Writing a cut that removes valid answers when the predicate is called with arguments bound.
- Answering with code that was never run, and claiming it works.
