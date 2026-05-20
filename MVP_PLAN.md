# I'm Alive MVP Plan

## 1. Product Requirement Summary

I'm Alive is a mobile safety check-in app for people who live alone, travel independently, or want a simple accountability loop with trusted contacts. The core promise is simple: the user periodically confirms they are okay, and the app makes it obvious when their next check-in is due.

The MVP should prove the habit loop before adding complex emergency automation. It should help a user configure their check-in cadence, see their current safety status, check in quickly, and understand what will happen if they miss a check-in.

Primary user goals:

- Set up a lightweight personal safety profile.
- Add trusted emergency contacts.
- Confirm "I'm alive" with one clear action.
- See the next check-in deadline.
- Receive reminders before a missed check-in.
- Keep a local history of check-ins for reassurance and debugging.

Key product assumptions to validate early:

- Default check-in interval is 2 days unless changed by the user.
- Timezone handling should follow the user's device timezone.
- MVP can begin with reminder-first behavior and defer automated outbound SMS/calls until platform, consent, and compliance details are confirmed.

## 2. MVP Scope

### In Scope

- Mobile app shell with onboarding.
- Safety dashboard showing current state: safe, due soon, overdue.
- One-tap check-in action.
- Configurable check-in interval, starting with a 2-day default.
- Trusted contacts list with name, relationship, and phone number.
- Local notification reminders before the due time and when overdue.
- Local check-in history.
- Settings for interval, reminder timing, and contacts.
- Clear empty states and first-run guidance.

### Out of Scope For MVP

- Server-side monitoring.
- Automated SMS, WhatsApp, phone calls, or email escalation.
- Location tracking or live location sharing.
- Wearable integrations.
- Multi-user family dashboards.
- Subscription, payments, or identity verification.
- Medical emergency workflows.

## 3. UI/UX Direction

The product should feel calm, direct, and trustworthy. It is not a social app or a gamified habit tracker. The home screen should answer three questions immediately:

- Am I currently marked safe?
- When is my next check-in due?
- What action do I take now?

Recommended navigation:

- Home: status, countdown, primary check-in button, recent history.
- Contacts: trusted contacts management.
- Settings: interval, reminders, privacy, about.

UX principles:

- Use plain language and avoid alarmist copy.
- Make the primary check-in action large and reachable.
- Show overdue states clearly without panic styling.
- Require confirmation before deleting contacts or resetting history.
- Keep onboarding short: explain purpose, set interval, add first contact, enable notifications.

Visual direction:

- Light, high-contrast interface.
- Green for safe, amber for due soon, red only for overdue.
- Large countdown/status typography on the dashboard.
- Minimal cards; prioritize operational clarity over decorative UI.

## 4. Technical Architecture

Recommended MVP stack: Flutter.

Rationale:

- Fast cross-platform mobile delivery.
- Good fit for local-first state, notifications, and device APIs.
- Existing owner repository history suggests Flutter familiarity.

Suggested architecture:

- `lib/main.dart`: app bootstrap and theme.
- `lib/src/app.dart`: routing and top-level app state wiring.
- `lib/src/features/check_in`: status dashboard, check-in action, check-in history.
- `lib/src/features/contacts`: trusted contacts CRUD.
- `lib/src/features/settings`: cadence and reminder settings.
- `lib/src/domain`: entities such as `SafetyProfile`, `TrustedContact`, `CheckInRecord`.
- `lib/src/services`: persistence, notification scheduling, time/status calculations.

Data approach for MVP:

- Local persistence first using a simple storage adapter.
- Domain services should be isolated so storage can later move to SQLite, secure storage, or a backend.
- Notification scheduling should sit behind an interface for easier testing and future platform-specific changes.

Core status calculation:

- `lastCheckInAt + checkInInterval = nextDueAt`.
- `now < nextDueAt - reminderWindow`: safe.
- `nextDueAt - reminderWindow <= now < nextDueAt`: due soon.
- `now >= nextDueAt`: overdue.

## 5. Development Task Breakdown

1. Initialize Flutter app structure and baseline theme.
2. Add domain models for safety profile, trusted contact, and check-in record.
3. Implement check-in status calculation with unit tests.
4. Build home dashboard with status, countdown, and check-in button.
5. Add local check-in history state.
6. Build settings screen for check-in interval and reminder timing.
7. Build contacts screen for trusted contact CRUD.
8. Add local persistence adapter.
9. Add notification permission flow and local reminder scheduling.
10. Add onboarding flow.
11. Add QA test fixtures and manual test checklist.
12. Prepare release notes and MVP acceptance checklist.

## 6. QA Test Plan

Functional tests:

- First launch shows onboarding or empty configured state.
- User can complete onboarding with default 2-day interval.
- User can check in and see updated last check-in and next due time.
- Status changes correctly between safe, due soon, and overdue.
- User can add, edit, and delete trusted contacts.
- User can change check-in interval and reminder timing.
- Check-in history records each successful check-in.

Edge cases:

- Device timezone changes.
- App reopened after multiple days.
- No trusted contacts configured.
- Notification permission denied.
- Very short interval used during testing.
- User edits interval after already checking in.

Non-functional tests:

- App launches quickly on a clean install.
- Dashboard remains readable on small mobile screens.
- State persists across app restarts.
- No sensitive contact data appears in logs.

Manual QA scenarios:

- Happy path onboarding to first check-in.
- Missed check-in simulation.
- Notification permission denied path.
- Contact deletion confirmation.
- Offline use.

## 7. Risks / Blockers

- The exact missed-check-in escalation behavior is not yet confirmed.
- Automated outbound alerts may require platform-specific APIs, backend services, consent language, and abuse prevention.
- Local notifications are not reliable enough for life-critical guarantees; copy must avoid implying emergency-service reliability.
- Timezone and daylight-saving behavior need explicit acceptance criteria.
- Contact data privacy expectations should be documented before beta release.
- If the app later needs server escalation, the local-first MVP should not hard-code assumptions that block migration.

## 8. Recommended First Implementation Task

Start with the local Flutter app scaffold and check-in domain model. Specifically:

- Create the Flutter project structure.
- Add `SafetyProfile`, `TrustedContact`, and `CheckInRecord` models.
- Add a pure `CheckInStatusService` that calculates safe, due soon, and overdue states.
- Build a simple Home screen that renders a default profile and one-tap check-in action.

This gives the team a working spine for product, engineering, UI, and QA discussion before platform notifications and persistence add complexity.

## Open Product Decisions

- Should overdue status trigger only in-app reminders for MVP, or should it notify contacts?
- If contacts are notified, what channel is allowed first: SMS, WhatsApp, call, or email?
- What exact reminder schedule should happen before and after a missed check-in?
- Should users be able to snooze a check-in?
- Is the default 2-day rule measured as exactly 48 hours or by calendar day?
- What privacy copy is required for storing emergency contacts?
