# Frontend documentation

Flutter remains at the repository root. Existing handoff paths are preserved:

- [Architecture](../architecture.md)
- [Design handoff](../design-handoff.md)
- [Module plan](../implementation-plan.md)
- [Environment](../environment-report.md)
- [Verification](../verification.md)
- [Figma evidence](../figma/screen-inventory.json)
- [Per-screen FE inventory](screen-inventory.md)
- [Master-task progress and continuation](progress.md)
- [Offline demo data and current limits](demo.md)
- [Auth routes, guards and design handoff](auth-handoff.md)
- [Asset provenance and hashes](assets.json)

All product UI uses only Figma page 579:228. The master task now authorizes full
FE implementation. Live Figma reads now work: 13 auth frames are implemented and
connected; two role homes are partial, and 128 frames remain unimplemented.
Startup uses /auth/splash. Android/device acceptance and downstream home navigation
remain open; widget/asset verification does not mean the whole FE is complete.
