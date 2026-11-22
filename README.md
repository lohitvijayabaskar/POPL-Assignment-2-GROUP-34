# CS F301 PPL Assignment 2

Group: 34
Members:
Lohit Vijayabaskar (2023B5A70778H)
Tarun Pradeep Krishnamurthy (2023B3A70398H)
Aryaman Srivastava (2023B5A70764H)

## Layout
- `code/34_q1.pl`, `code/34_q2.pl`: Prolog solutions (P1 puzzle, P2 equations).
- `code/34_q3.rkt`, `code/34_q4.rkt`: Racket solutions (S1 tree traversals, S2 conditional insert).
- `tests/`: one test file per problem.
- `skills/`: `prolog-dev/SKILL.md` and `scheme-dev/SKILL.md`.
- `prompts/`: prompts given to the AI, word for word (`P1.md`, `P2.md`, `S1.md`, `S2.md`, `skills.md`).
- `P1_REPORT.md`: value of N for P1.b and what it says about the puzzle.

## Run
```
swipl -q -f code/34_q1.pl -g main -t halt
swipl -q -f code/34_q2.pl -g "all_equations([4,2,5,3], Es), writeln(Es)" -t halt
racket code/34_q3.rkt
```

## Tests
```
swipl -q -f tests/test_q1.pl -g run_tests -t halt
swipl -q -f tests/test_q2.pl -g run_tests -t halt
racket tests/test_q3.rkt
racket tests/test_q4.rkt
```
