# CI workflows

flutter.yml runs the existing real Flutter quality gate for pull requests into
develop/main and pushes to those branches. It reads .flutter-version, resolves
the committed dependency lockfile and runs scripts/check.ps1 on Windows.

There is no backend CI job yet because there is no executable backend runtime.
Add a separate backend workflow/job with its actual install/lint/test commands
when the framework is selected. Do not replace backend checks with an always-green
placeholder job. This workflow does not deploy or merge pull requests.

Actions sources: https://github.com/actions/checkout and
https://github.com/subosito/flutter-action. Revalidate pinned revisions when
updating them.
