# Workly development rules

- Figma is authoritative: file LdYars6BFgIu9VdgWeP9dT, page 579:228 (ALL SCREENS • Client & Freelancer). Other pages are drafts. Read docs/design-handoff.md first.
- Monorepo structure was approved on 2026-11-05: Flutter stays at root, backend lives in backend/, shared API contracts in docs/api/. This task covers structure/docs/CI only; product screens and backend runtime need a scoped implementation task.
- Read high-fidelity get_design_context plus screenshot for each implementation batch. Re-read prototype guards/actions from source hotspots; the saved navigation graph omits conditions.
- Never change UI/UX to fill missing requirements. Flag missing sources; do not follow navigation to draft pages.
- Use feature-first MVVM: views -> view models -> repository interfaces. Data implementations depend on interfaces; domain does not import widgets. Inject repositories at app/app_dependencies.dart.
- Use ChangeNotifier/ListenableBuilder for state, go_router for routing. Add a package only for a concrete need. Never put business logic or API calls in a view.
- Use feature-qualified route names; Fxx labels are not unique. Implement role-aware guards/tab stacks with the corresponding module.
- Reuse core/theme and core/widgets. Preserve Figma token collection provenance. Download exact assets into assets with licenses; never use temporary Figma URLs at runtime.
- Use synthetic deterministic fixtures only. No real accounts, credentials, banking details or secrets. Backend scaffolding is authorized; no framework/database/runtime is selected yet. Follow backend/AGENTS.md within that directory.
- Before changing files, inspect git status and existing contents. Preserve pre-existing untracked Figma artifacts. Stage explicit paths, never git add . in this mixed workspace.
- Start each module from current develop in its own codex/feat/<module> branch; use codex/chore/<scope> for structural work. Do not create all feature branches ahead of time. Keep FE and BE dependency manifests and checks independent.
- Run dart format, flutter analyze, flutter test successfully before every commit/push. Use scripts/check.ps1. Recheck staged diff, whitespace, secrets and ignored files.
- Use Conventional Commits and real, cohesive changes. No force push, history rewrite, empty commits, fabricated authorship/dates or invented reviews/check results to inflate activity.
- The user explicitly authorizes creating PRs and merging them without further manual approval after affected checks pass. Use work branch -> PR into develop -> PR develop into main when publishing an approved update. Inspect the actual diff and CI; merge the tested head SHA, preserve history with a merge commit, and respect branch protection. Do not bypass failed/pending checks or submit a fake self-approval.
- Keep docs/implementation-plan.md and docs/verification.md current. Report checks that cannot run. Do not claim Android readiness while cmdline-tools/licenses/device checks are incomplete.
