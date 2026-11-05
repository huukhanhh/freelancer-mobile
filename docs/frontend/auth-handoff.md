# Auth implementation handoff — 2026-11-05

Source: file LdYars6BFgIu9VdgWeP9dT, page 579:228 only. Live MCP session
d55a9ce6-791f-44a4-b656-a079860e0d9f successfully read high-fidelity contexts,
screenshots, source hotspot actions and motion. No draft page was used or edited.

| Frame | Registered route | Flutter view |
|---|---|---|
| 584:259 F01 | /auth/splash | SplashView |
| 585:4121 F02 | /auth/onboarding/0 | OnboardingView |
| 599:3985 F02b | /auth/onboarding/1 | OnboardingView |
| 599:4000 F02c | /auth/onboarding/2 | OnboardingView |
| 585:4161 F03 | /auth/role | RoleSelectionView |
| 585:4204 F04 | /auth/register | EmailAuthView |
| 585:4234 F05 | /auth/profile, Freelancer role | ProfileSetupView |
| 876:6976 F05C | /auth/profile, Client role | ProfileSetupView |
| 585:4268 F06 | /auth/verification | VerificationView |
| 585:4320 F07 | /auth/login | EmailAuthView |
| 585:4357 F08 | /auth/google | GoogleAuthView |
| 585:4406 F09 | /auth/recovery | RecoveryView |
| 585:4440 F10 | /auth/recovered | RecoverySuccessView |

Hidden state contexts read separately: verified registration 880:7738,
recovery sent 880:7956, new password 880:7967, company details 879:7399.
Source F09 CTA changes directly to the new-password state; the unused sent-email
state is not inserted as an invented extra navigation step.

## Commands and source guards

- Splash timeout 1.6 seconds; anonymous users enter onboarding, existing sessions
  enter their role destination. Next advances three slides; skip finishes onboarding.
- Registration requires consent and source password strength (8 characters,
  uppercase, lowercase, digit). It creates a pending account, not a session.
- OTP 482916 is the public offline fixture. It expires after 5 minutes; resend
  renews it. Verification displays success, then the first-login CTA opens login.
- First login enters role selection/profile setup; complete profiles enter their
  role home. Unverified login returns to OTP. Home deep links check session/role.
- Freelancer setup stores name/specialty/technology selection. Client setup stores
  independent/company affiliation; website is optional and logo is a mock toggle.
- Google continuation uses one local fixture, not OAuth or a provider SDK.
- Recovery updates the in-memory account password; no email/link request is sent.
  A missing account has the same response; recovery grants expire and are consumed.

## Visual sources and reuse

AuthPage/header/form/button/brand/illustration/feedback/scroll primitives are reused.
Auth Material component instances are 52px high, radius 12, 13 Medium, solid
Emerald dark. They are distinct from the previously implemented 593:4119 gradient
button (radius 18 / 15 Bold). Emerald/Profile token collections retain provenance.
390x844 is the visual reference, with adaptable scrolling and form heights.
Native OS bars are used at runtime; AuthDesignPreview adds source chrome only for QA.

All local asset paths, source URLs, hashes, nonempty sizes and root dimensions
are recorded in [assets.json](assets.json). Temporary asset URLs are absent from
runtime code. Some endpoint URLs end in .png but supply JPEG bytes; Flutter decodes
the original image content, and metadata records the actual supplied format.
MCP does not supply photo/trademark license documents; no ownership claim is made.
Existing font OFL remains in assets/fonts/OFL.txt.

The React instance exports returned a Figma logo despite the screenshot and
component override identifying React. The exact referenced source component
670:4711 was read separately; its group SVG is used with 1.09% horizontal and
6.33% vertical insets. The incorrect instance export is excluded.

Motion uses the source 2000ms shared loop, CSS ease-out/ease-in-out, entrance
opacity/translation and splash logo/halo scale. Hidden stale editorial/illustration
motion nodes are excluded after checking effective visibility. Reduced-motion
settings freeze the final state. Onboarding transition is 280ms move-in from right.

## Downstream home boundary

F11 585:4476 and F12 585:4563 have source-based compositions, role fixtures and
offline assets. They are **partial**, not completed discovery modules. Search,
filter, categories, listing details and other tab destinations are not connected.
Optional callbacks are left inactive until those source screens are implemented;
there are no fabricated destination screens or simulated successful navigation.
Carousel source timing is 3000ms hold / 720ms slide; repeated first slide holds
900ms before reset. All list content is scrollable and uses repository fixtures.

Android Pixel_3 launch and the rendered login screen are now verified with a
device screenshot. Full device role flows, keyboard, selected states and carousel
timing remain open. Widget previews alone do not certify pixel-perfect equivalence.
