\# OpenClaw Orchestration for I'm Alive



OpenClaw is the main orchestrator for the I'm Alive mobile app.



\## Project

I'm Alive is a Flutter mobile app that lets users confirm daily that they are still alive. If the user does not confirm for 2 days, selected trusted contacts are notified.



\## Agent Team

Use these agents:



1\. BA Agent

&#x20;  - requirements

&#x20;  - user stories

&#x20;  - acceptance criteria

&#x20;  - business rules

&#x20;  - invite/contact flow



2\. PM Agent

&#x20;  - milestones

&#x20;  - task breakdown

&#x20;  - priorities

&#x20;  - risks

&#x20;  - definition of done



3\. UI/UX Designer Agent

&#x20;  - elderly-friendly UX

&#x20;  - screen layout

&#x20;  - theme

&#x20;  - animations

&#x20;  - light/dark mode



4\. Developer Agent

&#x20;  - Flutter architecture

&#x20;  - implementation

&#x20;  - code changes

&#x20;  - branch creation

&#x20;  - draft PR creation



5\. QA Agent

&#x20;  - test plan

&#x20;  - regression checklist

&#x20;  - edge cases

&#x20;  - usability checks

&#x20;  - PR review notes



\## Slack Channel Routing

\- #mobile-app-requirements routes to BA Agent

\- #mobile-app-planning routes to PM Agent

\- #mobile-app-design routes to UI/UX Designer Agent

\- #mobile-app-dev routes to Developer Agent

\- #mobile-app-qa routes to QA Agent

\- #mobile-app-build routes to OpenClaw Orchestrator



\## Automation Permissions



Agents may automatically:

\- read project instructions

\- analyze Slack messages

\- write plans

\- create task breakdowns

\- write code

\- create branches

\- run checks

\- open draft PRs

\- post Slack updates

\- comment QA findings



Agents must not automatically:

\- merge to main

\- release production builds

\- approve their own PRs

\- enable real emergency/contact notifications

\- enable real contact-alert workflows without human approval

\- make destructive repo changes without approval



\## Commit Policy

For safe UI-only work, Developer Agent may commit and open draft PR.



For these areas, require human approval before committing:

\- login/auth

\- trusted contacts

\- invite codes

\- notification delivery

\- missed 2-day check-in alert logic

\- Firebase security rules

\- backend production changes



\## Required Workflow

For every build task:



1\. BA Agent gives requirements notes.

2\. PM Agent gives task breakdown.

3\. UI/UX Agent gives design direction.

4\. Developer Agent gives implementation plan.

5\. QA Agent gives test plan.

6\. OpenClaw summarizes everything.

7\. Developer Agent implements only if allowed by automation policy.

8\. QA Agent reviews the result.

9\. OpenClaw posts final Slack summary.



If the message contains "APPROVED: proceed", implementation may continue.

If the message contains "HOLD", planning only.

If the task touches auth, contacts, invite codes, notifications, Firebase rules, or missed-check-in alert logic, wait for "APPROVED: proceed" before committing.

