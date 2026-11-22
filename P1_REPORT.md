# Logic Programming Assignment: P1 Report

---

## Part P1.b: Analysis of Solutions for Clues 1 to 8

### 1. Initial Solver Query and Results

When we query the Prolog knowledge base using only the first eight clues (clues 1 through 8), the program finds that there are **3 valid solutions**:

```prolog
?- count_solutions([1,2,3,4,5,6,7,8], N).
N = 3.
```

The three valid solution structures, mapping each friend (**Alex**, **Ben**, **Carla**, and **Dana**) to their corresponding **`[Department, Language, Project]`** attributes, are detailed in the table below:

| Solution ID | Alex | Ben | Carla | Dana |
| :---: | :--- | :--- | :--- | :--- |
| **Solution A** | `[design, java, AI]` | `[development, javascript, web]` | `[research, c++, data]` | `[testing, python, embedded]` |
| **Solution B** | `[design, java, embedded]` | `[development, javascript, web]` | `[testing, python, AI]` | `[research, c++, data]` |
| **Solution C** | `[testing, python, embedded]` | `[development, javascript, web]` | `[design, java, AI]` | `[research, c++, data]` |

---

### 2. Deep Dive: What This Result Tells Us

#### A. The System is Under-Constrained
A standard logic puzzle is designed to yield exactly **one unique solution**. When a set of rules allows for multiple valid outcomes (in our case, 3 distinct solutions), the system is said to be **under-constrained**. This means clues 1 to 8 provide insufficient rules or constraints to eliminate all but one possibility.

#### B. Forced Facts (Invariants Across All Solutions)
Even though the puzzle as a whole is under-constrained, certain attribute combinations are **forced**—meaning they remain strictly identical across all 3 valid solutions:
* **Ben's Profile:** In Solutions A, B, and C, Ben is always assigned to `development`, uses `javascript`, and works on the `web` project (`[development, javascript, web]`).
* **The Research Profile:** In all three solutions, whichever friend is in the `research` department always uses `c++` as their language and prefers the `data` project (`[research, c++, data]`).

#### C. Why a Name-Free Ninth Clue Cannot Single Out Solution A or Solution C
The requirements for task **P1.c** specify that the ninth clue must be **name-free**. A name-free clue refers only to **attribute values** (departments, programming languages, and project preferences) rather than explicit names (Alex, Ben, Carla, or Dana).

To understand why a name-free clue cannot pick out Solution A or Solution C, we must examine the set of 3-tuples `(Department, Language, Project)` present in each solution:

1. **Tuples present in Solution A:**
   * `(design, java, AI)`
   * `(development, javascript, web)`
   * `(research, c++, data)`
   * `(testing, python, embedded)`

2. **Tuples present in Solution C:**
   * `(design, java, AI)`
   * `(development, javascript, web)`
   * `(research, c++, data)`
   * `(testing, python, embedded)`

Notice that **Solution A and Solution C contain the exact same four attribute triples**. The *only* difference between Solution A and Solution C is the assignment of those triples to specific names:
* In Solution A, **Alex** gets `(design, java, AI)` and **Dana** gets `(testing, python, embedded)`.
* In Solution C, **Alex** gets `(testing, python, embedded)` and **Carla** gets `(design, java, AI)`.

Because a name-free clue cannot inspect the name associated with any tuple, it sees Solutions A and C as completely identical sets of attribute combinations. Consequently:
* Any name-free statement that is **true** for Solution A will automatically be **true** for Solution C.
* Any name-free statement that is **false** for Solution A will automatically be **false** for Solution C.

Therefore, it is logically impossible for a name-free clue to isolate Solution A or Solution C as a single unique answer.

#### D. Why Solution B is the Only Isolatable Solution
In contrast, **Solution B** contains a unique grouping of attribute values that does not appear in Solutions A or C:
* `(design, java, embedded)`
* `(testing, python, AI)`

Because these specific combinations of language and project exist **only in Solution B**, a name-free clue can target these unique attribute pairs to eliminate Solutions A and C while keeping Solution B valid.

---

## Part P1.c: Puzzle Repair via Clue 9

### 1. Defining the Repair Clue

To repair the under-constrained puzzle and reduce the number of valid solutions from 3 to 1, we introduce a ninth clue that is name-free and targets the unique attribute structure of Solution B.

```prolog
% CLUE 9: The friend whose favorite language is Python prefers the AI project.
clue(9, S) :-
    forall(member(p(_, _, python, Project), S),
           Project == 'AI').
```

---

### 2. Detailed Breakdown of the Prolog Implementation

Let us dissect how this Prolog rule operates line by line:

1. **`clue(9, S)`**: Declares the ninth clue rule operating on the list of friends `S`.
2. **`member(p(_, _, python, P), S)`**:
   * Scans the solution list `S` for any element matching the structure `p(Name, Department, Language, Project)`.
   * We use anonymous variables (`_`) for `Name` and `Department` to ensure the clue remains strictly **name-free** and department-agnostic.
   * It matches any individual whose language is `'python'` and binds their project preference to variable `Project`.
3. **`forall(Condition, Action)`**:
   * Evaluates `Condition` (`member(...)`) and ensures that for every matching instance, the `Action` (`Project == 'AI'`) holds true.
   * If any friend who uses Python has a project other than `'AI'`, `forall/2` fails.

---

### 3. Step-by-Step Evaluation Against All Solutions

We now test Clue 9 against each of the three candidate solutions from Part P1.b:

* **Evaluating Solution A:**
  * Friend using Python: **Dana** (`[testing, python, embedded]`).
  * Dana's preferred project is `embedded`.
  * Check: Does `embedded == 'AI'`? **No (False)**.
  * **Result:** Solution A is **eliminated**.

* **Evaluating Solution C:**
  * Friend using Python: **Alex** (`[testing, python, embedded]`).
  * Alex's preferred project is `embedded`.
  * Check: Does `embedded == 'AI'`? **No (False)**.
  * **Result:** Solution C is **eliminated**.

* **Evaluating Solution B:**
  * Friend using Python: **Carla** (`[testing, python, AI]`).
  * Carla's preferred project is `AI`.
  * Check: Does `AI == 'AI'`? **Yes (True)**.
  * **Result:** Solution B **passes**.

---

### 4. Verification of Unique Solution

With Clue 9 added to the puzzle constraint set, we re-run the Prolog solver query across all nine clues:

```prolog
?- count_solutions([1,2,3,4,5,6,7,8,9], N).
N = 1.
```

### Conclusion
By adding the name-free ninth clue, the puzzle is successfully **repaired**. It is no longer under-constrained, and **Solution B** is successfully isolated as the single unique solution to the logic puzzle.