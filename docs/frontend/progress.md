# Flutter FE checkpoint — 2026-11-05

Branch develop, baseline 294b0e9. Active master task uses checked cohesive direct
commits to origin/develop; no per-screen PR or main merge. backend/ and CI unchanged.
The 157 pre-existing untracked Figma artifacts are preserved; never stage them.

## Implemented in this batch

- Live Figma MCP works. Read all 13 auth frame contexts/screenshots, hidden
  confirmation/new-password/company states, source actions/guards and motion.
- Actual splash, three onboarding pages, signup, login, verification/success,
  Google demo, role selection, both profile setup variants and recovery/success.
- Startup opens /auth/splash instead of the technical /bootstrap host.
- Editable forms, validation, consent, OTP paste/focus/resend/expiry, mock recovery,
  local Google continuation, role guards and profile completion are connected.
- AccountSetupRepository extends the existing auth/session boundary; one in-memory
  mock owns accounts/session/profiles. AppDependencies is the future Firebase
  adapter boundary. MarketplaceRepository supplies synthetic home listings.
- Two source-based role home compositions and auto-slide banners are present.
  Their downstream actions/tabs remain inactive until discovery modules are built.
- flutter_svg is needed for exact Figma SVGs. No Firebase/provider SDK, backend
  change, runtime asset URL or persistent system configuration change.
- 108 exact local exports with hashes/metadata. Source React component corrects
  an MCP instance-export mismatch. See auth-handoff.md and assets.json.

## Scope accounting

143 product frames: **13 auth frames implemented and connected**, **2 home frames
partially implemented**, **128 frames not implemented**. Device acceptance and
fine typography remain open; the whole FE is unfinished. Parameterized views
cover onboarding/forms/role-specific profiles without duplicate screens.
No draft or hidden archive screen is counted. Actual routes: screen-inventory.md.

## Validation

- Final scripts/check.ps1 passed: 43 formatted files/0 changes, analyze no issues
  (29.1s), all 28 tests passed (15s), including Google→Freelancer setup.
- Rendered 13 auth references and two homes at 390x844, then inspected registration
  success, new-password and company states. Reference OS chrome is QA-only.
- Responsive widget coverage: 390x844 / 320x568, 250px keyboard inset, scrolling.
  Fixed a wrapped identity-caption overflow; responsive checks then passed.
- Widget flows cover both demo roles, wrong-role/unauthenticated deep links,
  registration→OTP→first login→Client/company setup and recovery/login.
- Final Android debug APK built (42.5s; 186190272 bytes). No physical phone test.
  Pixel_3 initially opened black/offline. Cold boot/software GPU and the user's
  Allow USB debugging approval restored connectivity. Flutter run installed and
  launched the app on Android 16/API 36; an actual screenshot confirms login UI.
  Full Android interaction/keyboard/role-flow acceptance remains open.
- Computer-use initialization failed with a kernel-assets path error; no emulator
  UI interaction has been verified through that tool.

## Continue next

1. Inspect explicit staged paths/diff/secrets, commit real work and push develop.
   Android launch/login rendering is verified; no physical phone was tested.
2. Complete section 02 discovery: F13 585:4648, search 585:4731, filter 585:4812,
   results 585:4873, details 585:4950; Client talent 585:5196/profile 585:8006.
   Read fresh high-fidelity contexts/screenshots and source guards/actions first.
3. Wire categories/skills/listings/search/banners to these actual views. Implement
   role tab stacks with their modules; do not route tabs to one fake placeholder.
4. Continue profile/projects/proposals/contracts/finance/delivery/chat/settings
   in docs/implementation-plan.md order. Substantial FE work remains.

Local ignored evidence: .local/figma/*.json, 18 preview PNGs, auth_preview_test.dart
and Pixel_3 logs. Do not commit these caches, APKs or old design artifacts.
