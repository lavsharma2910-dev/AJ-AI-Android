# AJ AI — Master App Blueprint & Roadmap
**Checkpoint date:** 28 November 2026  
**Repository:** `lavsharma2910-dev/AJ-AI-Android`  
**Development branch at checkpoint:** `feature/intelligence-execution-core`  
**Checkpoint commit:** `9d1a423b424a57cec459d08ba4fb744d99c179b9`  
**Status:** Planning baseline / approved direction; most future modules described here are not yet implemented.

---

## 1. Product direction

AJ AI is one evolving Android application by **AJ SOFTWARE LABS** — “Build. Innovate. Automate.”

The long-term product brings together:
1. A capable AI assistant (ChatGPT/Gemini-style conversational experience).
2. WhatsApp-like personal and group messaging.
3. AI Hub for connecting authorized AJ SOFTWARE LABS products and external services.
4. AI for Project / Team Workspace for people and multiple AI agents to collaborate on shared projects.
5. Code Studio, memory, files/storage, voice and future tools.

These are modules inside one AJ AI app, not a decision to start multiple unrelated apps. Keep the modules logically separated in code, APIs, data boundaries and permissions.

**Current priority rule:** The Main App and core AI Assistant come first. Do not begin parallel feature coding across modules in a way that mixes shared backend/database changes. Future modules stay in the blueprint until their scheduled phase.

## 2. Product principles and constraints

- Zero-cost-first: free tiers and open-source tools initially.
- No paid API, hosting, subscription, credit, upgrade or chargeable infrastructure without explaining the exact service, reason and expected charge and receiving explicit approval.
- Preserve the user's intellectual property and future licensing/sale rights.
- Do not claim a feature is live until code, tests and practical evidence confirm it.
- Avoid feature sprawl; complete and verify one phase before activating the next.
- Android-first usability, with simple Hindi/English experiences and support for more languages later.
- Protect user data, chat history, project data, files, credentials and organization boundaries.
- Keep future design decisions flexible; revise this blueprint when real testing, user needs or design evidence justify a change.

## 3. App information architecture

### 3.1 Account entry
- Sign up with Google.
- Sign up with email and email verification code.
- Sign up with mobile number and OTP, once a secure and cost-reviewed provider/flow is available.
- Login and logout.
- Account linking and duplicate-account protection so one person does not accidentally create disconnected identities through Google/email/mobile.
- Secure session management and recovery.

### 3.2 Main dashboard
Recommended five-item bottom navigation:
- **Home** — main dashboard and overview.
- **AI** — assistant/chat.
- **Messages** — personal and group messaging.
- **Workspace** — projects and collaborative work.
- **Settings** — account, preferences, support and controls.

Keep Logout inside Profile/Settings, not as a permanent primary navigation item. Put Feedback and Help & Support in Settings. Keep the dashboard visually clear, with the holographic AI Core/infinity visual and clear module cards.

Dashboard module cards:
- AI Assistant
- Messaging
- AI Hub
- AI for Project
- Code Studio
- Files & Storage

A module may be visible as “Coming Soon” only if it is clearly marked as not yet available. Do not present a nonfunctional control as working.

### 3.3 Settings
- Language: Hindi, English and add more languages over time.
- Help & Support.
- Account and security.
- Privacy and memory controls.
- Notifications.
- Storage management.
- Feedback.
- Logout.

### 3.4 Main product modules
1. AI Assistant
2. Voice AI / voice chat
3. Messaging (WhatsApp-like)
4. AI Hub / software connectors
5. AI for Project / Team Workspace (separate from AI Hub)
6. Code Studio
7. Memory (consent-based and user-controllable)
8. Files & Storage
9. Explore / What's New for future capabilities.

## 4. Main App and AI Assistant — highest priority

Do not move to feature expansion until the core experience meets agreed quality gates.

### Work areas
- Correct, complete, useful answers, especially in Hindi and English.
- Research Adapter and evidence/source validation.
- Independent answer verification and calibrated uncertainty.
- Hindi/English quality benchmark covering static knowledge, current facts, multi-step reasoning, ambiguous requests, and high-impact/commercial questions.
- Response speed, timeout handling, bounded retries, fallback and clear failure messages.
- Preserve chat history and offline queue behavior.
- Improve user experience and dashboard only in a controlled, tested sequence.

### Next technical milestone
Research Adapter + Evidence Validation + Knowledge Benchmark. This is planned work, not yet implemented at this checkpoint. Do not claim live web research or independent verification until implemented and tested.

## 5. AI Hub — separate from AI for Project

AI Hub is the **Intelligent Integration & Automation Center**. Its purpose is to connect AJ AI to authorized AJ SOFTWARE LABS products and supported external services.

Potential connector examples:
- AJ School Manager.
- AJ Property CRM.
- Other AJ SOFTWARE LABS products when separately approved and ready.
- External services only where a safe, supported and authorized integration exists.

Core capabilities:
- Connector registry and connection status.
- Authentication/credential handling without exposing secrets.
- Role- and organization-scoped permissions.
- Read-only access by default where practical.
- Explicit approval for sensitive write/delete actions.
- Audit logs, revocation, rate limits and error visibility.
- AI can query only the data the signed-in user is authorized to access.
- Strict tenant separation: school data must not leak to business tenants or unrelated users.

A connector is not the same as a complete School Manager or Property CRM product. Building those products from scratch would require separate scope and additional time. No new standalone product is being started under this decision.

## 6. AI for Project / Team Workspace — separate future module

This is a distinct collaboration system, not part of AI Hub. It allows students or company staff and multiple AI agents to collaborate on one shared project.

### AI capacity
- Minimum 2 connected AI agents are required for a project workspace.
- Maximum 10 connected AI agents.
- Human member/coordinator count is set according to the project's needs; it is separate from the AI-agent count.
- Provider availability, cost, usage limits and data-sharing permission must be checked before connecting agents. The zero-cost-first rule applies.

### Roles and authority
- One Main Admin.
- Up to two Sub Admins.
- Coordinators / team members as required by the project.

**Main Admin vs Sub Admin distinction:** Both have the same ordinary project-operational powers as defined by the workspace policy. The only reserved difference is that only Main Admin can appoint, replace or remove Sub Admins. A Sub Admin cannot appoint/remove/replace another Sub Admin or change the Main Admin.

Ordinary project-operational powers may include managing project tasks, assigning work, monitoring progress, coordinating members and using permitted AI agents. Coordinator-management permissions should be configured explicitly and audited.

### Handover and continuity
- Main Admin may delegate operational work to either Sub Admin.
- If one Sub Admin is unavailable, the other may take over delegated work.
- If both are unavailable, work remains queued or is reassigned to an authorized coordinator by the Main Admin's configured policy; do not silently elevate permissions.
- Keep assignment history, handover notes, deadlines and audit records.
- Smart Work Distribution may suggest who/which AI should handle a task, but must respect role permissions and must not silently change privileged roles.

### Multi-AI collaboration
- Shared project context and task board.
- Task assignment and status tracking.
- AI-to-AI handoff of task results with provenance.
- Review/verification agent.
- Shared files with per-project access controls.
- Human approval for sensitive actions.
- Clear usage/cost limits and logs.
- Separate workspace data for every project and organization.

## 7. Messaging

Future module with:
- Personal chat and group chat.
- School teacher-parent and school groups.
- Company staff and customer conversations.
- Message delivery/read status, sync, notifications and search.
- Media/file sharing with safe upload validation.
- Block/report and privacy controls.
- Correct recipient and group-membership authorization.
- Data retention and backup policy.
- Do not claim end-to-end encryption until genuinely implemented and independently checked.

## 8. Voice, Memory, Files and Code Studio

### Voice AI
- Voice input and spoken responses.
- Clear permission controls and microphone indicators.
- Graceful fallback when speech services are unavailable.
- Cost and privacy review before any paid or external voice provider.

### Memory
- Consent-based, user-controllable memory.
- Clear view/edit/disable controls where supported.
- Do not store secrets or sensitive information unnecessarily.
- Explain what is remembered and how it is used.

### Files & Storage
- Private user/project storage.
- Upload type/size limits, malware/content safety checks where feasible.
- Access controls, download/export and deletion policy.
- Do not expose one user's files to another without explicit authorization.

### Code Studio
- Code editor/workspace, project files and AI coding help.
- Sandboxed execution only; never run untrusted code directly on the host/server.
- Resource/time limits, network restrictions and secret isolation.
- Versioning and export/backup.

## 9. Recommended development order

This order is intentionally sequential at the module level to avoid mixing work. Independent documentation/design planning may happen alongside, but shared backend/database changes must be serialized and reviewed.

| Phase | Work | Exit gate |
|---|---|---|
| 1 | Main App foundation and AI Assistant | Stable chat, history, clear error handling |
| 2 | AI intelligence: research adapter, evidence validation, benchmark | Repeatable quality benchmark and validated sources |
| 3 | Reliability: speed, retry, fallback, timeout | Measured latency and retry/failure tests |
| 4 | Voice, Memory, Files & Storage | Permission, privacy and device tests |
| 5 | Messaging | Correct delivery, sync, groups and access tests |
| 6 | AI Hub framework | Connector auth, tenant isolation, audit and approvals |
| 7 | AI for Project / Team Workspace | Role enforcement, 2–10 AI policy, task handover and audit |
| 8 | Code Studio | Sandboxed execution and security tests |
| 9 | Integration and controlled pilot | End-to-end, regression, backup/recovery and limited-user validation |
| 10 | Commercial readiness and expansion | Operational support, documentation, security and scale review |

Planning estimates previously discussed:
- Working demo: approximately 30–50 days (limited functional scope, not the complete platform).
- Controlled live pilot: approximately 5–7 months for the selected School + Business connector pilot, subject to actual scope and available resources.
- Commercial Version 1: approximately 9–15 months.
These are planning estimates, not delivery guarantees. Full School Manager and Property CRM products built from scratch would increase scope and timeline.

## 10. Quality and release gates

Before marking a module complete:
- Code review and maintainability check.
- Unit/integration/regression tests.
- Android build and install/open/crash checks.
- Practical device/user test for the relevant workflow.
- Security, privacy, authentication, authorization and input validation.
- API-key/secret protection and rate limiting.
- Tenant and project data isolation.
- Backup and recovery verification.
- Documentation and unresolved-bug list.
- No production deployment, release, public launch, credential/policy changes or irreversible actions without explicit approval.

## 11. GitHub workflow and checkpoint rules

- Before every logical code/config/docs change, create a new backup branch from the exact latest development commit and verify its SHA.
- If pre-change backup creation or verification fails, stop.
- Make the change on the intended development branch, not on a backup branch.
- After the change, create and verify a post-change backup.
- Do not mix unrelated modules in one change.
- Do not advise installing over the existing app until signing-certificate compatibility is checked.
- Do not uninstall the existing app or risk local chat data.
- Only report builds/tests as complete when the relevant GitHub workflow and practical evidence verify them.

## 12. Checkpoint snapshot — 28 November 2026

- Development branch: `feature/intelligence-execution-core`.
- Verified development commit at checkpoint: `9d1a423b424a57cec459d08ba4fb744d99c179b9`.
- New backup branch created and verified: `backup/checkpoint-20261128-1149`.
- Backup branch points to the same verified commit SHA above.
- Last known build #110: CI succeeded for commit `9d1a423...`; artifact details are recorded in the project continuity notes.
- Build #110 included composer improvements; it did not include the Research Adapter or independent verifier.
- User tested Select All and whole-message selection and accepted the behavior.
- User reported a slight perceived response-time improvement; no measured latency result is available.
- No new application code or APK build was produced by this planning checkpoint.
- Next implementation milestone remains Research Adapter + Evidence Validation + Knowledge Benchmark, after a fresh pre-change backup is created and verified.

---

**Change policy:** This is the approved planning baseline as of 28 November 2026, not an unchangeable contract. Future changes may be made when justified by actual requirements, user feedback, test results or design decisions. Update this document and create a checkpoint whenever a material decision changes.
