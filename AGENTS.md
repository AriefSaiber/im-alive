# AGENTS.md

## Project Name

I'm Alive

## Project Goal

I'm Alive is a simple mobile application that helps users notify selected contacts that they are still alive.

The app is designed especially to be easy for elderly users, so the experience must be simple, playful, clear, and low-friction.

## Core App Concept

The user receives a daily notification asking them to confirm that they are alive.

The user can confirm by:

1. Tapping the daily notification.
2. Opening the app and pressing the large "I'm Alive" button on the homepage.

If the user does not confirm for 2 days, their selected contacts should be notified on their respective phones.

## Target Users

- Elderly users
- People living alone
- Family members who want peace of mind
- Caregivers
- Close friends or emergency contacts

## Main Features

### 1. Login

The app should include login.

Preferred options:

- Google/Gmail login
- Email login if needed

The login flow should be simple and not overwhelming.

### 2. Home Page

The homepage should be extremely simple.

Main element:

- One large button saying: "I'm Alive"

Button behavior:

- If the user has not confirmed today, the button is enabled.
- When pressed, it confirms the user is alive for the day.
- After pressing, the button becomes disabled/unpressable.
- Disabled state should look greyed out but still friendly.
- The button should feel responsive, animated, sleek, and satisfying to press.

Design direction:

- Minimal UI
- Playful animation
- Few buttons
- Easy for elderly users
- Clear text
- Large touch targets
- Avoid clutter

### 3. Daily Notification

The user should receive a daily notification.

Notification purpose:

- Remind user to confirm they are alive.

User can confirm by:

- Clicking the notification.
- Opening the app and pressing the homepage button.

### 4. Missed Confirmation Logic

If the user does not press the button for 2 days, selected contacts should be notified.

Important behavior:

- The system should track the user's last confirmed alive date/time.
- If no confirmation is received for 2 days, notify selected contacts.
- Contacts should receive a phone notification if they have the app installed.
- Avoid false alarms where possible.

### 5. Contact Configuration Page

The app must include a page where users can configure contacts they want to notify.

Contact features:

- Add contact
- Remove contact
- View selected contacts
- Send invite code
- Accept invite code from another user
- Show contact status clearly

### 6. Invite Code

Users can invite other contacts using an invite code.

Invite code use case:

- User A invites User B.
- User B enters the invite code.
- User B becomes part of User A's trusted contact list, depending on confirmation flow.

The invite system should be simple, clear, and safe.

### 7. Settings

The settings page should include:

- Dark mode toggle
- Notification preferences
- Account/login information
- Basic app information

### 8. Theme and Visual Style

Theme direction:

- Minimal
- Friendly
- Calm
- Playful but not childish
- Easy for elderly users

Main colors:

- White
- Blue
- Soft matching accent colors chosen by the UI/UX Designer

Dark mode:

- Must be supported.
- Dark mode should keep strong contrast and readability.

Inspiration:

- Withly app style
- Smooth, interactive, modern, minimal animations
- Clean card layouts
- Friendly rounded UI

## Design Requirements

- Large readable text
- Large buttons
- Minimal number of actions per screen
- Clear navigation
- Avoid hidden or confusing gestures
- Avoid tiny icons without labels
- Use animation to guide and delight, not distract
- Make the "I'm Alive" button the emotional center of the app

## Technical Assumptions

Unless stated otherwise:

- Mobile app is built with Flutter.
- Backend may use Firebase or a REST API.
- Authentication may use Firebase Auth with Google sign-in.
- Notifications may use Firebase Cloud Messaging.
- Local reminders may use local notifications.
- Data should support user profile, trusted contacts, invite codes, and alive confirmation logs.

## Suggested Data Concepts

Potential entities:

- User
- TrustedContact
- InviteCode
- AliveCheckIn
- NotificationPreference

Potential user fields:

- id
- displayName
- email
- photoUrl
- lastAliveAt
- dailyReminderTime
- darkModeEnabled

Potential trusted contact fields:

- id
- ownerUserId
- contactUserId
- contactName
- contactEmail
- inviteStatus
- createdAt

Potential invite code fields:

- code
- createdByUserId
- expiresAt
- usedByUserId
- status

Potential alive check-in fields:

- userId
- checkedInAt
- source: notification | homepage

## Agent Team Workflow

When asked to work as a team, use these agents:

1. BA Agent
2. Project Manager Agent
3. Developer Agent
4. QA Agent
5. UI/UX Designer Agent

Each agent should work from their own role, then Codex should consolidate all outputs into one final plan.

## BA Agent Responsibilities

The BA Agent is responsible for:

- Requirements analysis
- User stories
- Acceptance criteria
- Business rules
- Edge cases
- Elderly-user usability concerns
- Contact notification flow
- Invite code flow
- Login flow

BA Agent output:

- Requirement summary
- User stories
- Acceptance criteria
- Business rules
- Edge cases
- Open questions

## Project Manager Agent Responsibilities

The PM Agent is responsible for:

- Milestone planning
- Sprint/task breakdown
- Prioritization
- Delivery risks
- Dependencies
- Definition of done

PM Agent output:

- Milestones
- Prioritized task list
- Dependencies
- Risks/blockers
- Definition of done
- Suggested MVP scope

## Developer Agent Responsibilities

The Developer Agent is responsible for:

- Codebase analysis
- Technical architecture
- Flutter implementation
- Authentication implementation
- Notification implementation
- Data model implementation
- Invite code implementation
- Clean, maintainable code

Developer Agent output:

- Technical plan
- Architecture recommendation
- Files to create/change
- Implementation notes
- Commands to run
- Known risks
- PR summary

## QA Agent Responsibilities

The QA Agent is responsible for:

- Test plan
- Manual test cases
- Regression checklist
- Edge case testing
- Notification logic testing
- Invite code testing
- Elderly usability testing

QA Agent output:

- Test scenarios
- Expected results
- Edge cases
- Regression checklist
- Bugs or risks found
- QA sign-off recommendation

## UI/UX Designer Agent Responsibilities

The UI/UX Designer Agent is responsible for:

- App flow
- Screen layout
- Design system
- Button interaction
- Animation behavior
- Accessibility
- Elderly-friendly UX
- Light/dark mode theme

UI/UX Designer output:

- UX flow
- Screen-by-screen design notes
- Color/theme recommendation
- Button animation behavior
- Accessibility notes
- UI component recommendations

## MVP Scope

The first version should focus on:

1. Login with Google/Gmail
2. Homepage with large "I'm Alive" button
3. Daily notification reminder
4. Store alive confirmation timestamp
5. Contact configuration page
6. Invite code flow
7. Notify contacts if user has not confirmed for 2 days
8. Settings with dark mode
9. Minimal animated UI

## Out of Scope for MVP

Avoid these unless specifically requested:

- Complex social feed
- Chat system
- Video call
- Location tracking
- Medical records
- Too many settings
- Emergency services integration
- Complicated caregiver dashboard

## General Development Rules

- Keep the app simple.
- Prioritize elderly usability.
- Use large touch targets.
- Avoid clutter.
- Keep copywriting friendly and reassuring.
- Do not add complex features without explaining why.
- Do not introduce new dependencies unless necessary.
- Always explain implementation decisions.
- Always consider failure cases for notifications.
- Always consider privacy and consent when notifying contacts.

## Recommended App Tone

Friendly, calm, reassuring, and slightly playful.

Example text:

- "Glad you're here today."
- "You're checked in for today."
- "We'll let your trusted contacts know you're okay."
- "You already checked in today."
- "Add someone you trust."

## OpenClaw / Slack Automation Rules

This project uses Slack channel routing.

Channel mapping:

- #im-alive-requirements routes to BA Agent
- #im-alive-planning routes to PM Agent
- #im-alive-design routes to UI/UX Designer Agent
- #im-alive-dev routes to Developer Agent
- #im-alive-qa routes to QA Agent
- #im-alive-build routes to Orchestrator

Agents may automatically:

- analyze Slack messages
- create plans
- propose GitHub issues
- write implementation notes
- create branches
- make code changes for approved-safe tasks
- run tests
- open draft PRs
- post Slack updates

Agents must not automatically:

- merge into main
- deploy production builds
- enable real emergency/contact notifications
- auto-approve their own PRs
- modify authentication, contact alert, invite code, or safety logic without a clear review summary

For UI foundation tasks only, auto-development is allowed.
For auth, contacts, invite code, notification delivery, or missed-check-in logic, create a plan first and require human approval before code changes.

## Flutter/Codex Environment

Flutter SDK is expected at:

~/development/flutter

Before running Flutter commands, use:

export PATH="$HOME/development/flutter/bin:$PATH"

Standard validation commands:

flutter pub get
flutter analyze
flutter test

Codex should not rely on an Android emulator. Prefer static analysis, tests, and code review unless APK build is explicitly requested.
