# Git workflow

Repository: https://github.com/huukhanhh/freelancer-mobile

## Branches and integration

- main: checked updates published through PRs.
- develop: integration branch; start each scoped change here.
- codex/feat/<module> or codex/chore/<scope>: one cohesive work branch per feature/task.
- Work branch -> PR into develop -> integration checks -> merge.
- To publish an approved update, develop -> PR into main -> checks -> merge.
- After publishing, fast-forward develop to main when possible to retain release
  merge ancestry. This synchronization creates no extra commit.
- Keep useful work branches for traceability; do not delete or rewrite existing
  remote history without an explicit reason.

The user authorized creating and merging PRs without waiting for manual acceptance
on 2026-11-05. This allows merging after checks, not skipping checks or branch rules.
Use merge commits to preserve real scoped commits and PR history. Check the actual
PR diff/CI and merge the tested head SHA. Do not submit a fake self-approval or
claim an independent reviewer participated.

## Validation and truthful history

Run scripts/check.ps1 for the Flutter application before commit/push. CI repeats
that gate on PRs and main/develop pushes. Backend checks remain not applicable
until a backend runtime is implemented; add its real install/lint/test workflow then.
Do not merge failed/pending checks, bypass protection, force push, create empty
commits or fabricate authors, dates, review activity or validation results.

Stage explicit paths. Review whitespace, secrets and generated outputs.
Use Conventional Commits grouped by actual changes, not a target commit count.
PR bodies describe resulting behavior, actual validation and remaining limitations.

## Existing history

Initial baseline was 1a9ab82. Flutter foundation 667f6fd was merged into main
through PR #1 (f7c1105); develop was synchronized by fast-forward before monorepo
work began. The old untracked Figma scripts/images/snapshots remain intact locally
and are not application assets or included in these commits.

GitHub operations can use the connected GitHub plugin; Git HTTPS uses existing
local authentication. Never persist tokens in source or PR bodies.
