# AJ AI — Daily Development, Parallel Workstreams & Quality Gate Rules
**Decision date:** 28 November 2026  
**Repository:** `lavsharma2910-dev/AJ-AI-Android`  
**Development branch:** `feature/intelligence-execution-core`  
**Pre-change baseline:** `1708d075071fc483642d98e1b942ac63e3b5b891`  
**Pre-change backup:** `backup/checkpoint-20261128-daily-audit-rule-pre`

This document supplements (and does not replace) the AJ AI Master App Blueprint & Roadmap.

## 1. Development model: three coordinated workstreams

Run up to three workstreams in parallel to reduce idle time. Parallel planning, documentation, test design, UI prototyping and independent review are encouraged. Workstreams must coordinate before touching shared files, APIs, database schemas, authentication, permissions or backend contracts.

### Workstream A — Core AI & Intelligence (highest priority)
- Research Adapter implementation planning and development.
- Evidence/source validation and answer verification.
- Hindi/English knowledge benchmark.
- Answer quality, completeness, uncertainty and factual accuracy.
- Latency, timeout, bounded retry and fallback improvements.
- Preserve chat history and offline queue behavior.

### Workstream B — UI, UX & App Experience
- Dashboard/navigation design preparation.
- UI prototypes and screen specifications for future modules.
- Button/action inventory and interaction test cases.
- Accessibility, Hindi/English presentation and device usability checks.
- UI implementation only after shared interfaces/contracts are agreed and reviewed.

### Workstream C — Architecture, Security, QA & Documentation
- Backend/API architecture review and documentation.
- Authentication, authorization, privacy and tenant/project isolation design.
- Threat review, secret/key handling, rate-limit and audit-log requirements.
- Unit/integration/regression test plans and benchmark datasets.
- GitHub documentation, checkpoint records and backup verification.

**Coordination rule:** Workstreams may progress independently where changes do not conflict. Shared backend/database/API changes are serialized: one reviewed change at a time, with explicit interface agreement before integration. Do not create competing implementations of the same contract.

## 2. One-hour work-and-check cycle

For each focused work session, target approximately one hour:
1. **15 minutes — review:** inspect the previous checkpoint, changed files, commits and backup status.
2. **15 minutes — test:** run relevant analyzer, unit/integration tests, API checks or practical device tests where available.
3. **15 minutes — diagnose and fix:** identify defects, determine root cause, fix within the approved scope and rerun affected tests.
4. **15 minutes — checkpoint and next step:** record evidence, unresolved issues, next task and backup status.

The one-hour block is a working target, not a deadline to ignore difficult defects. If a serious issue cannot be safely fixed within the session, stop dependent work, document it and continue diagnosis in the next session.

## 3. Defect handling and quality gates

Use this loop: **implement → inspect → test → identify defect → fix → retest → regression check → checkpoint → continue**.

- Fix defects as soon as their cause is understood and the fix is safe.
- Do not mark work complete merely because code was written or a build started.
- A task is **Complete** only when the agreed scope is implemented and reviewed.
- A task is **Tested** only when the relevant test or practical evidence passed.
- Keep unresolved bugs visible with severity, impact and next action.
- Critical security, data-loss, authentication/authorization or release-blocking defects stop dependent progression.
- After each fix, rerun the directly affected tests and relevant regression tests.
- Never hide, silently downgrade or describe a failed test as passed.

## 4. GitHub backup and change-control rules

Before every logical code, configuration or documentation change:
1. Identify the exact latest development-branch commit.
2. Create a uniquely named pre-change backup branch from that exact SHA.
3. Verify that the backup branch exists and points to the intended source commit.
4. If creation or verification fails, stop before changing files.

After the change:
1. Commit only the intended, reviewed scope to the development branch.
2. Create a post-change backup branch from the resulting commit.
3. Verify the post-change backup branch and commit.
4. Record both backup names and SHAs in the checkpoint report.

Never edit a backup branch as the working branch. Do not deploy, publish, merge to a release branch, change credentials/policies, or perform irreversible actions without explicit user approval.

## 5. Daily status report

Whenever the user returns for a progress check, report from the latest available verified evidence:
- Completed work.
- Tested work and the exact evidence/result.
- Pending work and unresolved bugs.
- Workstream A/B/C status.
- Pre-change and post-change backup status.
- Next exact development step.

Do not claim background or autonomous progress. No work happens between conversations unless an explicitly configured tool/workflow has actually performed it. If no new repository/build/test evidence exists, say so plainly.

## 6. Daily and weekly review

- Target one focused one-hour review/work cycle per day when the user and assistant are actively working together.
- At the end of each active session, record a concise checkpoint.
- Every Sunday remains the broader Weekly Review & Audit Day: code, tests, bugs, security/privacy, documentation, GitHub backups, business progress and next priorities.
- The daily cycle supplements, and does not replace, the Sunday review.

## 7. Safety, cost and ownership

- Maintain the zero-cost-first policy.
- No paid API, hosting, subscription, credit, upgrade or chargeable infrastructure without first explaining the exact service, reason and expected charge and receiving explicit approval.
- Keep repository, cloud and product ownership under the user's control.
- Never put secrets, API keys, passwords or private credentials in source code or documentation.
- Preserve app data; do not uninstall or overwrite the user's installed app without an explicit safe plan and signing-compatibility check.
- Treat independent security audit and release-readiness testing as required before a broad commercial launch.

## 8. Relationship to the Master Blueprint

The Master Blueprint's product scope and module order remain in force. This addendum updates the execution method: three coordinated workstreams may run in parallel, while shared backend/database/API changes remain serialized and reviewed. Future modules must not be falsely presented as implemented until code, tests and practical evidence confirm them.

**Approved working principle:** Faster progress through parallel preparation and disciplined one-hour quality cycles — without sacrificing correctness, security, backups or user control.
