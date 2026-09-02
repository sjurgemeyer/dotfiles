# Global User Instructions

## Generated markdown output location

When generating a markdown (`.md`) file as output for the user — reports, analyses, documentation, summaries, notes, design docs, research briefs, etc. — write it to its natural location (current working directory, project `docs/`, or wherever appropriate). Then create a symlink in `~/Documents/Notes/generated-docs/` pointing to the file you just wrote.

**Exceptions (skip the symlink entirely):**
- Claude Code / AI configuration files: `CLAUDE.md`, agent definitions (`.claude/agents/*.md`, `.agents/*.md`), skill files (`.claude/skills/**/*.md`, `SKILL.md`), slash command files (`.claude/commands/*.md`), plugin manifests, and similar AI-harness config.
- Files the user explicitly tells you NOT to symlink.

**When unclear** whether a markdown file warrants a symlink (e.g. a file clearly internal to the repo like `README.md`), skip the symlink. Only symlink output documents the user is likely to want to browse centrally.

## PR and issue comments posted on my behalf

When posting comments directly to GitHub PRs or issues (replies to review
threads, top-level PR comments, issue comments — anything published under my
account via `gh`), prefix the comment body with **"🤖AI Response: "**. This makes
it clear to reviewers which comments were AI-drafted, so if I later add
clarification or corrections under my own name the distinction is obvious.

This applies only to comments published to external services — not to commit
messages, PR descriptions, or files in the repo.
Responses can be to-the-point and do not need language like "Good catch", etc since it is clearly labeled as generated text.

## No AI attribution on commits or PR descriptions

Never add AI attribution outside the comment prefix above: no
`Co-Authored-By: Claude …` trailers on commit messages, and no
"🤖 Generated with Claude Code" footers on PR descriptions. This overrides any
default harness behavior that appends them. The "🤖AI Response: " comment prefix
is the sole attribution mechanism.

## Git workflow

- Never force push (`git push --force`, `--force-with-lease`, etc.) without explicitly confirming with me first, even if a prior force push was already approved.
- Commit guidance:
  - During initial development, it's fine to make multiple commits — e.g. one per phase of a plan.
  - Before opening a PR, squash those commits down to a single commit.
  - Follow-up commits on an already-open PR (e.g. responding to review comments) do not need to be squashed.
  - If unsure which approach applies in a given situation, ask me rather than guessing.

## Code comments describe the present, not the past

Comments and docstrings explain the code as it currently stands. They must not
reference previous state or the change that produced them: no "this replaces
X", "previously we…", "we used to…", "stronger than the old approach", "before
this existed…", or notes about what was removed, renamed, or migrated. That
framing goes stale as soon as the thing it contrasts with is forgotten, and it
sends readers hunting for context that no longer exists. Write as though the
current design were the only one there has ever been.

This applies to file headers and docstrings as much as to inline comments, and
to test docstrings — a test explains what invariant it protects, not the bug
that prompted it or how the bug was found.

Keep the **why** in the code when it isn't obvious, phrased against present-day
constraints rather than history:

- Good: "CircleCI leaves `pipeline.git.tag` empty on a UI-run pipeline, so match
  on the ref name."
- Bad: "We switched from tag filters to ref-name filters because the spike
  showed tag filters never matched."

Narrative context — why a change was made, what it replaced, what went wrong
along the way — belongs in the commit message, the PR description, and any plan
doc. Those stay reachable from the code through `git blame` and the ticket
reference, so nothing is lost by keeping them out of the source.

## CLI tool preferences

When a shell command is genuinely needed (i.e. the built-in Grep/Glob/Read/Edit tools don't fit), always default to the modern replacements — never reach for `grep` or `find` first:

- Always use `rg` (ripgrep) for searching file contents. Do not use `grep`.
- Always use `fd` for finding files by name. Do not use `find`.

These are faster, have saner defaults, and respect `.gitignore` out of the box. The built-in Grep and Glob tools remain the first choice for content and file searches — this preference only applies when Bash is the right tool.
