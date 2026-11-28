# Parallel Development Working Agreement Checkpoint — 2026-11-28

## Purpose
Record the Project Owner's approval of the parallel development collaboration model for AJ SOFTWARE LABS.

## Agreed team roles
- **ChatGPT — Lead Developer / Architect:** prepares task briefs, architecture, API contracts, integration boundaries, security review, test plans, code review, regression checks, and integration recommendations.
- **Gemini — Assistant Developer:** completes explicitly scoped, independent modules, tests, research, and documentation; returns complete source files and test evidence.
- **Project Owner — Final authority:** shares task briefs and source/repository access with Gemini, reviews product behavior, decides priorities, and explicitly approves integration, merge, and deployment.

## Parallel work model
The team may work on independent tasks at the same time, for example:
- AJ AI text-chat reliability / conversation module.
- AJ AI voice-chat module.
- AJ AI Hub module.
- AJ AI standalone messaging module (WhatsApp-like UX; actual WhatsApp integration is a separate scope and requires its own authorization and API review).

The exact allocation must be confirmed per task after reviewing the current repository architecture. Avoid assigning two developers to overlapping files or shared interfaces without an agreed contract.

## Required workflow for every Gemini task
1. ChatGPT prepares a task brief with goals, non-goals, exact allowed files, interface/API contract, acceptance criteria, and tests.
2. Gemini inspects the existing repository and reports the relevant current architecture before editing.
3. Gemini works only in the agreed isolated branch/files and returns complete changed files, tests, and a concise change report.
4. ChatGPT independently reviews correctness, security, privacy, performance, compatibility, and regression risks; runs or requests reproducible tests.
5. Any defects are sent back to Gemini for revision.
6. No code is integrated into the main system, merged, or deployed until the Project Owner gives explicit approval.

## Safety and repository rules
- Zero-cost-first policy remains in force. No paid services, APIs, subscriptions, credits, hosting, or chargeable infrastructure without prior explicit approval of the exact service and expected cost.
- Before repository code/config/document changes, create and verify a pre-change backup/checkpoint. If backup verification fails, stop.
- Keep experimental work isolated from `main`.
- Do not overwrite or revert unrelated user changes.
- Do not expose secrets, API keys, tokens, or private user data in prompts, commits, logs, or test fixtures.
- No production deployment, permission changes, or irreversible actions without explicit Project Owner approval.
- Record test commands, environment, pass/fail results, and unresolved issues. Never claim tests passed unless run evidence exists.

## Current status at checkpoint
- Existing review branch: `feature/research-evidence-validator-review-20261128`.
- Its only commit ahead of `main` adds the earlier Research Evidence Validator checkpoint report; no validator source code has been integrated.
- New backup branch created for this agreement: `backup/parallel-development-agreement-20261128`.
- This checkpoint records the collaboration process only; it does not change application source code, workflows, backend behavior, APK, or deployment.
- The first Gemini task brief will be prepared separately after reviewing the current AJ AI chat/voice architecture and confirming non-overlapping file boundaries.

## Approval record
The Project Owner explicitly agreed to the process: ChatGPT prepares the brief and contracts; the Project Owner provides the task to Gemini and shares the resulting code/branch; ChatGPT reviews and tests; integration/merge/deployment waits for the Project Owner's explicit approval.
