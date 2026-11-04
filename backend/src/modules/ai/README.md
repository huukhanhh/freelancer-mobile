# AI boundary — reserved, not implemented

Flutter renders feature-specific AI UI under lib/features/. Backend owns AI
requests, provider credentials, authorization and data filtering. Route a
supported use case through a backend service; do not call paid providers or
place provider keys in Flutter.

No provider, model, endpoint, prompt, embedding database or AI product feature
is selected by this scaffold. Use synthetic responses while developing an
approved AI feature. Add provider adapters and timeouts/usage controls when
that feature is specified. Split a worker/service only when actual processing
or deployment requirements justify it.
