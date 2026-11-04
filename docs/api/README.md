# API contracts shared by FE and BE

No API contract or endpoint exists yet. The contract should be agreed here
before Flutter mock repositories are replaced with API implementations.

For each implemented use case, document request/response fields, validation,
authentication/authorization, error semantics and synthetic examples. Select
OpenAPI or the appropriate format with the backend transport/framework; do not
add speculative endpoints, financial rules or real personal data.

Flutter maps transport DTOs to frontend domain models in feature data/.
Backend DTO/domain/persistence models remain server-side. Sharing this folder
does not mean sharing framework-specific implementation code.
