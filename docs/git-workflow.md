# Git workflow

Repository: https://github.com/huukhanhh/freelancer-mobile

Workspace initially had an unborn master branch, no commit or remote, and
pre-existing untracked Figma scripts/images/snapshots. No history was overwritten.
Only explicit application/documentation paths are staged. The old Figma artifacts
remain untracked and intact locally; they are not runtime assets.

Branch roles:

- main: minimal initial baseline (.gitignore and recorded Flutter version).
- develop: same initial baseline; receives foundation only after structure review.
- codex/chore/flutter-foundation: reviewable Flutter source, handoff and module plan.
- codex/feat/<module>: create individually from integrated develop when starting
  a module; see implementation-plan.md. Planned branches do not exist yet.

Conventional Commits, no force push, no automatic merge into main. Run the quality
gate and inspect staged diff/secrets/build artifacts before committing/pushing.
Git HTTPS uses the existing credential manager; gh is not required. No tokens or
identity configuration are written into the project. Push success and final remote
refs must be confirmed in the task report; this document defines branch roles.
