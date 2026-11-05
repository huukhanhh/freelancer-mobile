# Workly development rules

- Figma is authoritative: file LdYars6BFgIu9VdgWeP9dT, page 579:228 (ALL SCREENS • Client & Freelancer). Other pages are drafts. Read docs/design-handoff.md first.
- Monorepo structure was approved on 2026-11-05: Flutter stays at root, backend lives in backend/, shared API contracts in docs/api/. The current master task authorizes full mock Flutter FE implementation in small verified batches. Do not edit backend/ or connect a real backend/Firebase in this task.
- Read high-fidelity get_design_context plus screenshot for each implementation batch. Re-read prototype guards/actions from source hotspots; the saved navigation graph omits conditions.
- Never change UI/UX to fill missing requirements. Flag missing sources; do not follow navigation to draft pages.
- Use feature-first MVVM: views -> view models -> repository interfaces. Data implementations depend on interfaces; domain does not import widgets. Inject repositories at app/app_dependencies.dart.
- Use ChangeNotifier/ListenableBuilder for state, go_router for routing. Add a package only for a concrete need. Never put business logic or API calls in a view.
- Use feature-qualified route names; Fxx labels are not unique. Implement role-aware guards/tab stacks with the corresponding module.
- Reuse core/theme and core/widgets. Preserve Figma token collection provenance. Download exact assets into assets with licenses; never use temporary Figma URLs at runtime.
- Use synthetic deterministic fixtures only. No real accounts, credentials, banking details or secrets. Backend scaffolding is authorized; no framework/database/runtime is selected yet. Follow backend/AGENTS.md within that directory.
- Before changing files, inspect git status and existing contents. Preserve pre-existing untracked Figma artifacts. Stage explicit paths, never git add . in this mixed workspace.
- Current master-task override: continue frontend work on develop, make cohesive local commits and push origin/develop at large milestones. Do not wait on unrelated CI; preserve existing CI/tests/protection. No per-screen PR or tiny branch. Do not merge main. Keep FE/BE dependencies and checks independent.
- Rapid UI override (2026-11-05): work only in D:/DANENTANG/freelancer-mobile using existing .tools/flutter; keep flutter run resident and prefer Hot Reload/Restart. Implementation-only override: do not add or run automated tests, automate ADB interactions, repeatedly capture emulator screenshots, or expand edge-case checks. Preserve existing tests. Format changed files; analyze/build/run only as needed for compile/runtime blockers. The user performs phone acceptance. Recheck staged diff, whitespace, secrets and ignored files.
- Use Conventional Commits and real, cohesive changes. No force push, history rewrite, empty commits, fabricated authorship/dates or invented reviews/check results to inflate activity.
- Earlier PR/auto-merge authorization is superseded for the active FE master task: direct checked commits to develop, no merge into main. Respect branch protection if direct push is rejected; never bypass failed/pending checks or submit fake self-approval.
- Keep docs/implementation-plan.md and docs/verification.md current. Report checks that cannot run. Do not claim Android readiness while cmdline-tools/licenses/device checks are incomplete.
