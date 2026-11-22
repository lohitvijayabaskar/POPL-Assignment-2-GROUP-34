# Skill file prompts

Tool: Claude Code (Claude Opus 5.5), desktop app

Note: the wording of these prompts was drafted in an earlier part of the same Claude session,
which had also produced a reference solution to the assignment. The opening prompt of that
session is copied word for word at the end of this file.

## Commit: "Add prolog-dev skill file"

Create skills/prolog-dev/SKILL.md. It is a skill file for an AI assistant: a YAML header with name: prolog-dev and a one-line description, followed by instructions. Cover: SWI-Prolog 9.x; allowed libraries only lists, apply, yall, aggregate; forbidden assert, retract, b_setval, nb_setval, halt/0 in files, initialization directives, and printing anything not asked for; coding conventions (snake_case, a mode line and a declarative reading comment above each predicate); how to run code (swipl -q -f file.pl -g main -t halt) and tests (plunit files in tests/); a self-review checklist the AI must apply before answering; and a list of known failure modes of AI tools when writing Prolog. Write only this file.

---

## Opening prompt of the session (word for word)

@"C:\Users\Lohit Vijayabaskar\Downloads\PPL_Assignment_2_Final.pdf"
Assignment-2 will be uploaded tomorrow (22nd Nov) at 1Pm and you will have 12 hours for the submission.It is your responsibility to make yourself available for these 12 hrours for the submission.
You will submit a single GitHub repository (If you have not learnt how do it do it pls learn by tomorrow 1 Pm) Everything must be in the repository, and your commit history must be preserved. For each problem, the prompts you gave the AI, copied word for word should alos be submitted. No extension will be given hence do not email me about the extension.
You will be given 2 Scheme and 2 prologs programs to solve and you are free to use any Generative AI tools.

Please solve the following first and then tell me how to go about making these commits and also give me the prompts to submit
