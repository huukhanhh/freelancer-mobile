# Offline demo data — implementation progress

## Authentication data layer

Synthetic accounts (public demo inputs, not real credentials):

| Role | Email | Demo password |
|---|---|---|
| Client | client@workly.example | WorklyDemo123! |
| Freelancer | freelancer@workly.example | WorklyDemo123! |

The .example domain is intentional; no email, Google/Firebase request or network
connection is made. IDs stay mock-client-001 and mock-freelancer-001 so future
project/contract fixtures can reference consistent owners.

AuthenticationRepository extends the existing read-only SessionRepository;
MockSessionRepository implements both on one in-memory store. AppDependencies
injects that same store. A future Firebase adapter can implement this boundary
without placing Firebase calls in views or changing backend/ in this task.

Implemented commands now include registration/verification/resend, local Google
continuation, role/profile setup, password recovery and signIn/readSession/signOut.
AccountSetupRepository extends the existing boundary on the same store.
AuthenticationViewModel performs
required/email-format validation, reports invalid credentials/unavailability,
prevents repeated submissions, supports retry and ignores stale/disposed results.
Mock latency and unavailable controls enable deterministic loading/error tests.
Logout invalidates an in-flight mock login. Defaults are immediate and offline.

## Current UI limits

Start the app, skip or finish onboarding, then sign in using either table account.
Both seeded accounts already have complete profiles and reach their role home.
Register with any unused synthetic .example address and an 8+ character password
containing uppercase/lowercase/digits. Use public demo OTP **482916**, then choose
first login, select a role and finish the profile. Google continuation is a local
Minh Anh Demo fixture; it makes no Google request. Company logo is a mock toggle.
OTP and recovery grants expire after five minutes; resend renews OTP.

## Job discovery demo

Use freelancer@workly.example with WorklyDemo123! to reach the Freelancer home.
Search/quick filter/categories/skills/banner and Find work open the source discovery
views. Search Flutter/React/Figma for matching fixtures; Python shows the source
empty screen. Suggested keywords or Explore recover from empty. Clear recent
history, toggle ♡/♥, reset filters and apply budget/category/technology/billing/
remote/verified restrictions. Counts come from the matching fixture data.
The seed contains 24 jobs; source-default filter choices currently match 3.
Saved IDs persist across navigation in this process, not across restarts/viewers.
Job card details, saved-list screen, Client talent/project flows and remaining
tabs are pending, as listed in discovery-handoff.md. No sorting menu is invented.

Recovery changes the local fixture password for the current process. No message
is sent. All accounts/profiles/onboarding state reset on restart. Homes currently
show source UI, fixtures and carousel. Freelancer search/filter/categories/explore
are connected; details/other tabs and Client discovery are still inactive.
Logout command is tested, but its settings/profile UI is not
implemented yet. The overall frontend is unfinished.

Do not interpret mock authentication as authorization or store real passwords.
In-memory state resets on restart; no persistence or production Firebase exists.
