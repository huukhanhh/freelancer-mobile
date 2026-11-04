# Verification — 05/11/2026

Toolchain: Flutter 3.47.9 / Dart 3.13.7, Windows 11. Run from repository root.

| Check | Result |
|---|---|
| flutter pub get | Passed; go_router 18.1.3 locked in pubspec.lock |
| dart format --output=none --set-exit-if-changed lib test | Passed, 15 files, 0 changes on final gate |
| flutter analyze --no-pub | Passed, No issues found (42.7s final run) |
| flutter test --no-pub | Passed, 6 tests (19s final run) |
| flutter build web --no-pub | Passed, built build/web in 162.2s; Wasm dry run succeeded; font warning detailed below |
| Shared button visual inspection | Exported isolated render at source geometry; checked font, label, radius, four variants and gradient against Figma screenshot |
| gitignore | SDK/cache/build/.env/local.properties/signing files excluded |
| Secret pattern scan | No private key/GitHub token/Google API key/AWS access-key patterns found in new source/docs/assets/scripts; only explicit new project paths are staged |
| Android APK build/run | Not run: cmdline-tools absent, license status unknown, no connected Android device |
| Product-screen visual/golden/E2E | Not run: screens intentionally deferred for structure review |
| iOS / Windows desktop build | Not in this Android/Web scaffold; iOS needs macOS/Xcode; Windows C++ toolchain absent |

Tests cover anonymous/Client/Freelancer fixtures; session failure/retry, stale response suppression, completion after disposal; dependency injection/router/bootstrap lifecycle; all four shared button variants invoking a Vietnamese action.

The first analyzer run found prefer_initializing_formals in the mock constructor; it was fixed before the final successful gate. Initial sandboxed Flutter check could not update a tool telemetry/cache timestamp in the user profile; the same gate was rerun with approved access and passed.

The one-off ignored .local/button_preview_test.dart exported the preview successfully but its test runner did not terminate; it was interrupted after manual image inspection. It is not counted among the 6 passing committed tests. Initial preview had an extra trailing gap in the QA sheet and an offset-dependent gradient; both were corrected, then the final source passed the full gate above. Preview files are not application assets or committed tests.

pub get reports four newer transitive versions outside current constraints; no failed resolution. Dependencies were kept at the tested lockfile rather than upgraded without a need.

Web build warning: compiler expected packages/cupertino_icons/CupertinoIcons but only found MaterialIcons. go_router brings cupertino_ui transitively; the foundation does not render Cupertino icons. No Figma icon was substituted with CupertinoIcons. If a verified module needs that font, add/package it then; otherwise keep using exact Figma assets. The warning remains open and must be reevaluated when product navigation is implemented. MaterialIcons tree-shaking is informational.

No claim of Android readiness or full Figma screen fidelity is made by this foundation verification. Only the reusable button has been rendered for visual inspection; product flows and assets await per-module work.
