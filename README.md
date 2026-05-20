# I'm Alive

I'm Alive is a local-first mobile safety check-in app. The MVP focuses on a clear habit loop: confirm you are okay, see when the next check-in is due, and keep trusted contacts ready for future escalation workflows.

## Current Status

This repository now contains the MVP plan and the first Flutter implementation slice:

- Flutter app shell and Material theme.
- Safety profile, trusted contact, and check-in record models.
- Pure check-in status service for safe, due-soon, and overdue states.
- Home screen with status, countdown, trusted contact preview, and one-tap check-in.
- Unit tests for the status service.

## Run Locally

```bash
flutter pub get
flutter test
flutter run
```

## Product Plan

See [MVP_PLAN.md](MVP_PLAN.md) for the consolidated product, UX, technical, development, QA, and risk plan.

## Next Implementation Tasks

1. Add local persistence for profile, contacts, and check-in history.
2. Add contact management screens.
3. Add notification permission flow and local reminder scheduling.
4. Replace placeholder profile/contact data with onboarding.
