# Backend scope

Follow root AGENTS.md. Backend is approved inside backend/ in this monorepo.
Current change is framework-neutral scaffolding, not a runnable service.

- Do not choose a backend framework/database implicitly or generate fake API handlers.
- Keep backend dependencies, manifest and lockfile in backend/, independent of pubspec.yaml.
- Business modules use controller/service/repository/DTO/domain boundaries as appropriate
  to the selected framework. Do not create layers without a real responsibility.
- Keep AI provider calls, credentials, authorization and database access server-side.
- Use synthetic fixtures; mock mode is not authentication, payment settlement or KYC.
- Document API contracts in docs/api/ before connecting Flutter repositories.
- Add executable backend checks and a dedicated CI job when a runtime exists.
  Until then report backend tests as not applicable, never as passing.
- Respect the root PR/merge authorization and run all affected checks before merge.
