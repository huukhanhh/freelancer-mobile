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

Implemented commands: signIn/readSession/signOut. AuthenticationViewModel performs
required/email-format validation, reports invalid credentials/unavailability,
prevents repeated submissions, supports retry and ignores stale/disposed results.
Mock latency and unavailable controls enable deterministic loading/error tests.
Logout invalidates an in-flight mock login. Defaults are immediate and offline.

## Current UI limits

These accounts are executable through repository/ViewModel tests. They are **not
yet usable from an app login screen**: product UI still requires Figma design
context/assets, and /bootstrap remains the technical host. No auth/home route,
role shell, Google sign-in, signup, OTP or recovery UI is claimed as complete.

Do not interpret mock authentication as authorization or store real passwords.
In-memory state resets on restart; no persistence or production Firebase exists.
