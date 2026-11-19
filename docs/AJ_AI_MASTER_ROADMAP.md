# AJ AI / AJ SOFTWARE LABS — Master Roadmap & Work Register

Last updated: 2026-11-19
Active product: AJ AI
Company: AJ SOFTWARE LABS
Tagline: Build. Innovate. Automate.
Brand line: Beyond Limits. Built Together.

## 1. Working agreement (mandatory)
- Develop step by step, collaboratively: inspect → plan → implement → test → review → approve.
- Do not mark any feature complete until its automated tests and relevant device/manual tests pass.
- Maintain daily and weekly work registers with decisions, commits, test evidence, blockers, and next actions.
- No production Cloudflare Worker changes/deployments without explicit user approval.
- Do not merge protected PR #2 or PR #3 without explicit user approval.
- No public launch until the user and assistant have reviewed the system and approved release.
- Never claim 100% secure, unhackable, or bug-free; use defense-in-depth and continuous verification.
- Preserve Update 31 working features and run regression tests for every Update 32 change.

## 2. Current verified baseline (2026-11-19)
- Repository: lavsharma2910-dev/AJ-AI-Android
- Active branch: feature/update-32-foundation
- Compared with feature/update-31-chat-actions: 5 commits ahead, 0 behind at the last inspection.
- Update 32 branch changes verified in comparison: documentation only:
  - docs/UPDATE_32_BLUEPRINT.md
  - docs/UPDATE_32_AUTH_SECURITY_PLAN.md
- No Update 32 feature implementation or APK has been verified yet.
- Update 31 APK had previously been installed and user reported it opened without crashing; chat, local history, and pending-message persistence worked in the reported checks.
- Existing app uses Flutter; pubspec currently includes http, share_plus, shared_preferences; Firebase Auth and Google Sign-In dependencies are not present in the inspected pubspec.
- GitHub Android workflow injects GOOGLE_SERVICES_JSON and adds Google Services Gradle plugin during CI. This alone does not prove Firebase Authentication is enabled or initialized.
- Android workflow currently triggers on main and feature/update-31-chat-actions, plus manual dispatch; add Update 32 branch trigger before relying on automatic builds.
- Inspected Worker source has /chat and health route, GEMINI_API_KEY server-side, wildcard CORS, no visible bearer-token verification, no visible per-user authorization, and no visible rate limiting. This is repository source evidence, not a full audit of deployed Cloudflare configuration.
- Production Worker remains unchanged and must remain unchanged without explicit approval.

## 3. Product direction and agreed design
### Account / welcome
- No Guest Mode or guest accounts.
- Verified signup/login required before entering the AJ AI platform.
- Signup methods: mobile OTP, email verification, Google Sign-In.
- One AJ AI identity may link all three methods, only after verifying ownership of each; safe duplicate detection, recovery, re-authentication, and session revocation required.
- Welcome page: AJ SOFTWARE LABS, tagline, AJ AI intro, development story, accurate ChatGPT assistance credit and independent-product disclaimer, privacy/security-conscious note, Signup and Explore Preview.
- Do not claim Firebase Auth is configured until console/provider settings and app initialization are verified.

### Home / modules / navigation
- Holographic AI Core; no human avatar. User-editable Core name is the same as the user's chosen display name.
- Three primary modules: AI Chat, Message, AI Hub.
- Additional modules: Profile, Code Studio, File, Memory, Evolving.
- Bottom navigation: Home, Login, Logout, Feedback; auth state must control which action is active.

### Voice
- Integrated in AI Chat, Message, and AI Hub, not a separate top-level module.
- Male and female voice options accepted.
- AI Chat: voice input/output, language, speed/volume, stop/mute.
- Message: voice recording and playback controls; calling is future scope.
- AI Hub: per-agent mute/unmute and Command Centre coordination; avoid overlapping voices with serialized queue initially.

### AI Hub
- Maximum 10 agents including one Main Centre AI.
- Main Centre may appoint up to 3 Admins; Admins cannot appoint Admins.
- Remaining agents are Sub-AIs.
- Work should continue if one or more Admins are unavailable; Main Centre-only privileges are not inherited.
- Permission matrix and detailed scopes remain open for joint design; do not assume permissions.

### Free launch / monetization
- Launch direction is Free First / Growth First for verified users.
- Gather feedback, measure performance/cost/abuse, fix defects and improve quality.
- Free does not mean unlimited: measured fair-use, rate limits, abuse controls, transparent notices.
- Do not set numeric quotas or prices without measurements and user approval.
- Gradual paid advanced services only after stability and readiness review; preserve useful free tier.

## 4. Authentication architecture recommendation (not yet approved as final implementation)
Preferred candidate for evaluation: Firebase Authentication for identity verification + Cloudflare Worker for API token verification, authorization, rate limiting, and AI service access.
- First perform Firebase Readiness Audit: confirm Firebase project, Android package ID, app initialization, enabled providers, billing/quotas and required configuration metadata. Never reveal secret values.
- Existing google-services.json workflow configuration is not proof Firebase Auth is enabled.
- Compare managed Firebase Auth against alternatives before final selection if readiness/requirements reveal blockers.
- Worker must verify token signature, issuer, audience, expiry and required claims server-side.
- Enforce per-user authorization on every private endpoint; fail closed.
- Test account linking, OTP throttling/replay, expired/revoked tokens, recovery, duplicate identities, and cross-user data isolation.
- Implement in a non-production/testing environment first. Production deploy only with explicit approval.

## 5. Phased roadmap
### Phase 0 — Project control and baseline
- [x] Establish Update 32 branch and record approved product direction in docs.
- [x] Inspect current pubspec, Android workflow, Worker source, and current auth/security plan.
- [ ] Add Update 32 branch to Android CI trigger.
- [ ] Create/maintain daily and weekly work register with evidence.

### Phase 1 — Firebase Readiness Audit (next)
- [ ] Verify Firebase project association and Android package ID.
- [ ] Verify Firebase initialization and actual Auth SDK status.
- [ ] Check enabled Email/Password or Email Link, Phone, Google providers in Firebase Console (requires authorized console visibility).
- [ ] Check SHA fingerprints / OAuth client configuration where applicable.
- [ ] Check quota, billing, SMS region policy, authorized domains and app restrictions.
- [ ] Record findings without exposing credentials.
- Exit gate: written readiness report and chosen provider architecture approved.

### Phase 2 — App foundation and modularization
- [ ] Preserve Update 31 chat/history/queue behavior with regression tests.
- [ ] Introduce modular Flutter feature structure incrementally; avoid risky full rewrite.
- [ ] Add typed auth states: signedOut, verificationPending, authenticated, expired, error.
- [ ] Add robust loading, retry, timeout, offline and error states.
- [ ] Update CI workflow branch trigger and verify build on Update 32.

### Phase 3 — Authentication UI and integration
- [ ] Welcome / Explore Preview.
- [ ] Mobile OTP, email verification, Google Sign-In.
- [ ] Login/logout, session refresh/revocation, recovery.
- [ ] Safe linking of verified methods and duplicate identity handling.
- [ ] Secure token storage; no provider secrets in APK.
- [ ] No mock auth represented as production authentication.

### Phase 4 — Backend security and user isolation
- [ ] Verify Firebase/OIDC tokens at Worker.
- [ ] Server-side authorization for every private route.
- [ ] Per-user data ownership and isolation.
- [ ] Rate limiting, abuse controls, safe CORS policy, payload limits.
- [ ] Redacted security logs, monitoring and alerting.
- [ ] Negative tests: missing/invalid/expired/revoked/wrong-audience token and cross-user access.
- [ ] Test in staging; production changes require explicit approval.

### Phase 5 — Chat quality and performance
- [ ] Measure baseline p50/p95 response latency and error rate.
- [ ] Evaluate streaming protocol and model fallback policy.
- [ ] Optimize timeout/retry strategy and request payload size.
- [ ] Hindi Devanagari consistency and AJ identity/app-awareness tests.
- [ ] Verify chat history, delete, share, copy, offline queue and restore.

### Phase 6 — Voice and messaging
- [ ] AI Chat voice input/output MVP, male/female options.
- [ ] Message voice note recording/playback.
- [ ] Permission and privacy review.
- [ ] AI Hub voice queue and per-agent mute controls after permission matrix approval.

### Phase 7 — AI Hub and remaining modules
- [ ] Finalize Admin/Sub-AI permission matrix with user.
- [ ] Agent coordination, task ownership, status, handover and conflict prevention.
- [ ] Code Studio, Files, Memory, Profile and Evolving module foundations.
- [ ] Notification Center, Universal Search and Personalization Center future design.

### Phase 8 — Free public beta readiness
- [ ] Feedback and bug-reporting flows.
- [ ] Crash, latency, API cost, abuse and security monitoring.
- [ ] Load, backup/restore, privacy, deletion/export and incident-response checks.
- [ ] Critical/high severity issues resolved.
- [ ] User reviews and explicitly approves beta/live release.

### Phase 9 — Gradual scale and paid services
- [ ] Analyze actual usage and operating costs.
- [ ] Preserve useful free tier.
- [ ] Introduce advanced paid services only after readiness review and user approval.
- [ ] Scale infrastructure based on measured demand.

## 6. Definition of Done
A feature is complete only when:
1. Code is committed to the correct feature branch.
2. Flutter analyze passes.
3. Relevant automated tests pass.
4. Security and negative tests pass where applicable.
5. GitHub Actions build succeeds and artifact is verified.
6. User installs/tests the APK on Android for relevant UI flows.
7. Results, known limitations and next actions are recorded.
8. No production deployment is implied unless explicitly approved and verified.

## 7. Daily / weekly register template
For each work session record:
- Date and phase
- Goal
- Files/commits changed
- Tests run and exact result
- APK/build artifact status
- Decisions made
- Risks/blockers
- Next action
- User approval needed (yes/no)

Weekly review:
- Completed with evidence
- In progress
- Failed tests / defects
- Security and performance observations
- Next week's priorities
- Release readiness (not ready / internal test / beta candidate / approved live)

## 8. Current next action
Begin Phase 1: Firebase Readiness Audit. Inspect repository metadata and available configuration without exposing secrets; then request or use authorized Firebase Console visibility to verify enabled providers. No production changes.
