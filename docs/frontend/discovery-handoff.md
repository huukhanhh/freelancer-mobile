# Job discovery batch — 2026-11-05

Approved page 579:228 only. High-fidelity live get_design_context and screenshot
read for each frame; click actions read directly from source hotspots. No draft
or invented destination UI. Full product/module completion is not claimed.

| Frame | Actual route | Status |
|---|---|---|
| F13 585:4648 | /discovery/jobs | UI/search/categories/save connected; card detail pending |
| F14 585:4731 | /discovery/search | Editable search, recent history, clear and trend shortcuts connected |
| F15 585:4812 | /discovery/filter | Draft controls, budget, reset/apply and count connected |
| F16 585:4873 | /discovery/results | Real results/chip removal/newest/save connected; card detail pending |
| F20 585:5144 | /discovery/empty | Source photo/copy/suggestions/explore/back connected |

The two homes and F13/F16 remain partial until job details and the remaining tab
modules exist. F14/F15/F20 join the 13 auth frames as connected batches: 16
connected frames, 4 partial, 123 unimplemented = 143. This is progress accounting,
not full frontend/device acceptance.

## Source navigation

Home Freelancer search → F14, quick filter → F15, explore/banner → F13,
category/technology → results (or source empty state when fixtures do not match).
F13 search → F14, filter → F15, categories → F16, back → Freelancer home.
F14 search/recent/React/Flutter/Figma → F16; source Python → F20.
F15 backdrop → BACK; apply → F16 (empty results use F20).
F16 search/back → F14, filter → F15. F20 back → F14, suggestions → F16,
explore → F13. Source dissolve transitions use 200ms ease-out on these routes.
The global source reset VariableID:918:236 is not an additional product feature.

Original card hotspots target F17 585:4950. That view is not implemented yet;
card-body callbacks remain inactive, with favorite controls operating separately.
No blank fabricated detail page is substituted. Only Home/Find work navigation
is connected for Freelancer; Client talent/project navigation and other tabs
remain pending. Role guards prevent Client access to Freelancer discovery.

## Mock semantics and boundaries

JobRepository.fetchJobs is asynchronous and injected at AppDependencies;
MockJobRepository supplies 24 deterministic synthetic IDs. Six source example
titles repeat with explicit Demo suffixes; no real accounts are used. Home jobs
reference the corresponding discovery IDs (GreenPay 4, React 5, Landing 6).
DiscoveryViewModel owns query/history/saved IDs and draft/applied filters for the
process. These reset for another viewer/restart and are not persistent storage.
Firebase integration and durable saved/history repositories remain future work.

The prototype supplies static filter controls and a sample count, not backend
query rules. The offline implementation uses one category/technology/billing
choice, optional remote/verified constraints and inclusive budget bounds.
Query matches any supplied word against title/skills/category, ignoring case.
Counters display actual matching fixture counts: the source-default Web/Flutter/
remote/verified/fixed-price combination matches 3 fixtures, rather than displaying
an inaccurate fixed 24. Reset clears restrictions; Python has no fixture match.
Only the displayed newest ordering is supported; no invented sorting menu.
Budget presentation uses source-position knots 20%=2m and 85%=30m, with currency
amounts kept separate from fractions; this is mock UI mapping, not an API contract.

## UI and assets

RoleBottomBar is shared with home, preserving the exact source icon slots for
selected/unselected roots. Other destinations remain visibly present but inactive.
DiscoveryScaffold/SearchBar/Chip/JobCard are reused, with source colors and local
photo/SVG files. WorklyButton gained configurable source height/label size for
the 57px filter CTA and 56px/14 Bold empty-state CTA; previous defaults remain.

46 exact source slots extend the manifest to 154 exports in assets.json. All
nonempty files and hashes are verified. Status assets are QA-only; runtime uses
native OS bars. Noto Sans Symbols 2 (OFL, assets/fonts) renders source Unicode
♡/♥ where Plus Jakarta Sans lacks the glyph. Saved source text 622:3627 and
622:3634 in F19 confirms the filled-heart character; F19 itself is unimplemented.

Five source-sized widget previews inspected at 390x844 with decoded photos,
local fonts and shadows. Narrow/keyboard checks cover 320x568 and 250px insets,
including scrolled content. Final device/CI evidence is in docs/verification.md.
