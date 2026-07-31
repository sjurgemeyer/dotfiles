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

## CLI tool preferences

When a shell command is genuinely needed (i.e. the built-in Grep/Glob/Read/Edit tools don't fit), always default to the modern replacements — never reach for `grep` or `find` first:

- Always use `rg` (ripgrep) for searching file contents. Do not use `grep`.
- Always use `fd` for finding files by name. Do not use `find`.

These are faster, have saner defaults, and respect `.gitignore` out of the box. The built-in Grep and Glob tools remain the first choice for content and file searches — this preference only applies when Bash is the right tool.
