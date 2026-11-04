# Business module map

This is a roadmap, not a list of implemented APIs. Create modules as actual
features start; do not generate empty controllers or claim placeholder tests pass.

| Module | Responsibility |
|---|---|
| auth | Session/authentication and authorization boundaries |
| users | Accounts and user roles |
| profiles | Freelancer/Client identity, portfolio and company association |
| projects | Project posting, discovery and recruitment positions |
| proposals | Applications, invitations, offers and negotiation |
| contracts | Agreements, ownership and contract lifecycle |
| milestones | Milestone allocation, progress and delivery references |
| payments | Wallet/escrow/withdrawal records and transaction boundaries |
| messaging | Conversations, messages and attachments |
| notifications | Notification records and delivery adapters |
| ai | Provider adapters and AI-assisted use cases; disabled initially |

These responsibilities reflect the approved product scope, not an inferred API
contract or database schema. Resolve rules from the approved design and future
API contract before implementing them. Keep payment/delivery/contract state
changes consistent; do not infer financial rules from a prototype animation.

A module may have controller, service, repository, dto and domain files once
a framework is selected. Avoid importing another module's internal repository;
use an explicit application/service boundary instead.
