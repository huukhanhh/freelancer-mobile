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
- [Discovery routes, mock semantics and remaining limits](discovery-handoff.md)

All product UI uses only Figma page 579:228. The master task now authorizes full
FE implementation. Live Figma reads work: 16 frames are connected (auth + search/filter/empty);
four frames are partial (two homes + browse/results), and 123 are unimplemented.
Startup uses /auth/splash. Android/device acceptance and downstream home navigation
remain open; widget/asset verification does not mean the whole FE is complete.
