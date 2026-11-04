# Backend documentation

- [Backend scope and layout](../../backend/README.md)
- [Planned module boundaries](../../backend/src/modules/README.md)
- [AI boundary](../../backend/src/modules/ai/README.md)
- [Shared API contracts](../api/README.md)

Architecture: modular monolith under backend/ initially. Backend has independent
dependencies/configuration/test/deployment commands. Framework/database remain
undecided; no runtime or API is claimed by this structure update.
