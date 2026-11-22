---
name: scheme-dev
description: Allowed built-ins, conventions, run/test commands, a self-review checklist and known AI failure modes for writing restricted Racket 8.x (#lang racket/base) code in this assignment.
---

# Scheme development (Racket 8.x, `#lang racket/base`)

Apply everything in this file whenever you write, change or review Scheme code for this repository.

## 1. Language and environment
- Target: **Racket 8.x**. Every solution file starts with exactly `#lang racket/base`.
- Solution files live in `code/`, tests in `tests/`.
- A solution file contains **only definitions**: no top-level calls, no test expressions, and
  nothing printed when the file is loaded. The grader appends its own calls to the end of the
  file and runs `racket <file>.rkt`.
- No `provide`, `require` or `module` forms are needed or wanted.

## 2. Allowed built-ins (the ONLY ones)
| Kind | Allowed |
|------|---------|
| Definitions and binding | `define`, `lambda`, `let`, `let*`, `letrec`, named `let` |
| Control | `if`, `cond` (with `else`), `and`, `or`, `not`, `begin` |
| Data | `quote` (`'`), `cons`, `car`, `cdr`, `list` |
| c[ad]r compositions | up to four letters: `caar`, `cadr`, `cdar`, `cddr`, `caddr`, `cdddr`, `cadddr`, `cddddr`, ... |
| Predicates | `null?`, `pair?`, `eq?` |
| Association lists | `assq`, `assoc` |
| Arithmetic and comparison | `+`, `-`, `*`, `<`, `>`, `<=`, `>=`, `=`, `max` |
| Output | `display`, `newline` |
| Input | `read` (problem S2 only) |

**Everything else is forbidden**, even if it is in `racket/base`. In particular:
- Mutation: `set!`, `set-car!`, `set-cdr!`, boxes.
- Vectors, hash tables, strings, characters, `string-append`, `number->string`.
- Loops: `do`, `for`, `for/list` and all other `for` forms.
- List library: `length`, `append`, `reverse`, `map`, `filter`, `member`, `memq`, `list-ref`,
  `list-tail`, `foldl`, `foldr`, `apply`, `build-list`, `first`, `rest`, `last`, `empty?`.
- Other forms: `when`, `unless`, `case`, `match`, `define-values`, `let-values`, `else` outside
  `cond`, `displayln`, `printf`, `write`, `equal?`, `null`, `empty`, `/`, `quotient`, `abs`, `min`.

If one of these is needed, write a helper from the allowed built-ins (`my-length`,
`my-reverse`, `my-map`, `my-append`, ...).

## 3. Coding conventions
- Names in `kebab-case`; predicates end in `?` (`list-value?`); helpers are named for what
  they return (`inorder-acc`, `my-length`).
- Above every function, a comment giving its **recursive reading**: the base case, and how the
  result is built from the recursive call(s).
  ```racket
  ;; (my-length lst): number of top-level elements of lst.
  ;; Base: () has length 0. Step: walk the cdr, adding 1 to the counter each time.
  (define (my-length lst)
    (let loop ((l lst) (n 0))
      (if (null? l)
          n
          (loop (cdr l) (+ n 1)))))
  ```
- No mutation: all state is passed through arguments. Use an **accumulator** argument instead
  of a variable that changes.
- Prefer **tail recursion** (a named `let loop` or a helper with an accumulator) for walking
  lists, so 10,000-element lists are safe. If the order comes out reversed, reverse once at the
  end with `my-reverse`.
- Build lists by consing onto an accumulator, never with repeated `append`.
- Printing functions print with `display`, and end their output with `(newline)`.
- One unit of work per answer: one function (with at most small helpers it needs), one test
  file, or one review. Do not write functions that were not asked for.

## 4. Running code
```powershell
racket code/<file>.rkt
```
On its own this must print nothing. To try a function the way the grader does, copy the file,
append calls at the end, and run the copy:
```powershell
Copy-Item code/<file>.rkt try.rkt
Add-Content try.rkt "(print-inorder '(2 (1 () ()) (3 () ())))"
racket try.rkt
```
For a function that reads standard input:
```powershell
"42 ((1 2) (3 4 5) (6) ()) 3" | racket try.rkt
```

## 5. Testing
- One test file per problem: `tests/test_qN.rkt`, using `rackunit`. Test files may use full
  `#lang racket`; the restrictions apply to solution files only.
- The solution file has no `provide`, so the test file loads it into a namespace:
  ```racket
  #lang racket
  (require rackunit racket/runtime-path)
  (define-runtime-path SRC "../code/<file>.rkt")
  (define mns
    (parameterize ([current-namespace (make-base-namespace)])
      (dynamic-require SRC #f)
      (module->namespace SRC)))
  (define (out expr) (with-output-to-string (lambda () (eval expr mns))))
  (check-equal? (out '(print-inorder '())) "()\n")
  ```
  Use `with-input-from-string` to feed standard input to functions that call `read`.
- Run: `racket tests/test_qN.rkt`. `rackunit` prints nothing for passing checks, so silence (or
  a final "done" line) means everything passed.
- Tests include every example from the assignment, plus edge cases: the empty list/tree, a
  single element, deep nesting (depth 100), long lists (10,000 elements), and a check that
  loading the file prints nothing.

## 6. Self-review checklist (apply before every answer)
Go through each item and fix the code before answering:
1. **First line** is exactly `#lang racket/base`.
2. **Every identifier** used is either in the allowed table above or defined in the file.
   Check the code word by word, not from memory.
3. **No top-level calls** and nothing printed on load.
4. **No mutation** and no loops; all state is in arguments.
5. **Empty input handled:** `()` as a tree, as a top-level list and as a sublist.
6. **`()` versus pair:** a sublist test uses both `null?` and `pair?` where `()` counts as a list.
7. **Output exact:** the list printed with `display`, one line each, ending with a newline.
8. **Scales:** long lists are walked tail-recursively; deep nesting only recurses as deep as
   the nesting.
9. **Comments:** each function has its recursive-reading comment.
10. **Tested:** the assignment examples have been run (or the exact commands are given).

## 7. Known failure modes of AI tools in restricted Racket
Watch for these mistakes in your own output:
- Using "standard" functions that are forbidden here: `length`, `append`, `map`, `reverse`,
  `filter`, `foldl`, `member`, `list-ref`, `displayln`, `when`, `unless`, `equal?`, `empty?`.
- Writing `#lang racket` instead of `#lang racket/base`, or adding `(provide ...)` /
  `(require ...)` lines.
- Leaving example calls or `(module+ test ...)` blocks at the top level, so the file prints on
  load.
- Building traversals with `append`, which is forbidden and quadratic, instead of an
  accumulator.
- Treating `()` as an atom: `pair?` is false for `()`, so a "sublist" test with `pair?` alone
  skips empty lists.
- Measuring a list's length after changing it, instead of on the original list.
- Off-by-one in tree height (empty tree is 0, single node is 1) or counting `()` as a leaf.
- Non-tail-recursive helpers with a huge pending stack on 10,000-element inputs, or reversing
  the result twice (or not at all).
- Using `else` in an `if`, or a one-armed `if` where both branches are needed.
- Printing extra text (prompts, labels, quotes) or forgetting the final newline.
- Claiming code works without running it.
