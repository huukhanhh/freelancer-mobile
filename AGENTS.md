# Workly development rules

- Figma is authoritative: file LdYars6BFgIu9VdgWeP9dT, page 579:228 (ALL SCREENS • Client & Freelancer). Other pages are drafts. Read docs/design-handoff.md first.
- Stop after the foundation until the user reviews project structure. Do not implement product screens in bulk.
- Read high-fidelity get_design_context plus screenshot for each implementation batch. Re-read prototype guards/actions from source hotspots; the saved navigation graph omits conditions.
- Never change UI/UX to fill missing requirements. Flag missing sources; do not follow navigation to draft pages.
- Use feature-first MVVM: views -> view models -> repository interfaces. Data implementations depend on interfaces; domain does not import widgets. Inject repositories at app/app_dependencies.dart.
- Use ChangeNotifier/ListenableBuilder for state, go_router for routing. Add a package only for a concrete need. Never put business logic or API calls in a view.
- Use feature-qualified route names; Fxx labels are not unique. Implement role-aware guards/tab stacks with the corresponding module.
- Reuse core/theme and core/widgets. Preserve Figma token collection provenance. Download exact assets into assets with licenses; never use temporary Figma URLs at runtime.
- Use synthetic deterministic fixtures only. No real accounts, credentials, banking details, backend or secrets.
- Before changing files, inspect git status and existing contents. Preserve pre-existing untracked Figma artifacts. Stage explicit paths, never git add . in this mixed workspace.
- Start each module from develop in its own codex/feat/<module> branch. Foundation lives on codex/chore/flutter-foundation. Do not create all feature branches ahead of time.
- Run dart format, flutter analyze, flutter test successfully before every commit/push. Use scripts/check.ps1. Recheck staged diff, whitespace, secrets and ignored files.
- Use Conventional Commits. No force push, history rewrite or automatic merge into main. Review foundation before integration into develop.
- Keep docs/implementation-plan.md and docs/verification.md current. Report checks that cannot run. Do not claim Android readiness while cmdline-tools/licenses/device checks are incomplete.
