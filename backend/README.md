# Workly backend

Backend lives in this monorepo alongside Flutter, with its own dependencies,
configuration, tests and deployment lifecycle. Current status: **structure and
architecture documentation only; no runnable API or database yet**.
The backend framework, language and database have not been selected.

## Layout

```text
backend/
  src/
    modules/       business modules; see the module map
      ai/          future server-side AI boundary
    common/        shared technical utilities
    config/        environment parsing and validation
    database/      connection and persistence adapters
  migrations/      ordered schema/data migrations
  tests/           backend unit/integration tests when runtime exists
  .env.example     sample names and synthetic development defaults only
  AGENTS.md
```

The planned modules are auth, users, profiles, projects, proposals, contracts,
milestones, payments, messaging, notifications and ai. They are not implemented
by these directories. Create each module when starting its actual scoped work.

Use controller -> service -> repository -> database boundaries. A module owns its
business rules and persistence interfaces; transport DTOs do not become database
models automatically. Flutter calls API contracts, never database adapters.
API contracts belong in [docs/api](../docs/api/README.md).

No backend install/start/test command is advertised until a runtime is selected
and implemented. Do not treat the Flutter test result as backend validation.
The next backend task must decide the framework/database, add its dependency
manifest and lockfile here, then implement a minimal runnable foundation and its
own quality checks before business modules.

Copy .env.example to an ignored .env only when runtime configuration is added.
These sample values are not currently consumed by any application.
Never commit AI credentials, banking credentials or database passwords.
All fixtures must be clearly synthetic and deterministic.
