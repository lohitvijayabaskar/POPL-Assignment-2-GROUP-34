# Skill file prompts

Tool: Claude Code (Claude Opus 5.5), desktop app

Note: the wording of these prompts was drafted earlier in the same Claude session.

## Prompt 1 (commit: Add prolog-dev skill file)

Create skills/prolog-dev/SKILL.md. It is a skill file for an AI assistant: a YAML header with name: prolog-dev and a one-line description, followed by instructions. Cover: SWI-Prolog 9.x; allowed libraries only lists, apply, yall, aggregate; forbidden assert, retract, b_setval, nb_setval, halt/0 in files, initialization directives, and printing anything not asked for; coding conventions (snake_case, a mode line and a declarative reading comment above each predicate); how to run code (swipl -q -f file.pl -g main -t halt) and tests (plunit files in tests/); a self-review checklist the AI must apply before answering; and a list of known failure modes of AI tools when writing Prolog. Write only this file.
