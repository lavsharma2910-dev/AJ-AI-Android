# AJ AI — Update 32 Development Blueprint

Company: AJ SOFTWARE LABS
Product: AJ AI
Tagline: Build. Innovate. Automate.
Brand line: Beyond Limits. Built Together.
Status: Development plan recorded; implementation and verification are pending.

## 1. Update 32 goals
- Improve response latency without reducing answer quality.
- Add streaming responses only if the existing backend protocol supports it safely.
- Improve Hindi consistency and app-aware responses.
- Correct product identity: AJ is the AI of AJ SOFTWARE LABS; never claim Google created AJ.
- Improve chat history, queue recovery, and user-facing guidance.
- Redesign the home experience around a customizable holographic AI Core (no human/avatar illustration).
- Add Welcome / Explore preview, signup and login foundations, subject to an authentication design review.
- Add integrated voice entry points in AI Chat, Message, and AI Hub, with feasibility and provider review before implementation.

## 2. Welcome, account authentication, home and navigation
- Welcome page: company name, tagline, AJ AI introduction, development story, accurate ChatGPT development-assistance credit, signup entry, and Explore preview.
- Signup methods planned: email, mobile number, and Google sign-in. Email/mobile OTP and Google authentication require a secure provider/backend design.
- Guest accounts and Guest Mode are removed from the product direction. Signup and verified Login are required before entering the AJ AI platform.
- One AJ AI identity can link Mobile OTP, Email verification code, and Google Sign-In; each login method must be verified before linking. Duplicate-account detection and safe account linking are required.
- Registration completes only after verification. After signup, the user signs in to the same account. Recovery, session expiry/revocation, device/session visibility, and account deletion/export flows require design.
- The first public phase is Free First / Growth First: core platform features are free while we collect feedback, test real usage, fix defects, and stabilize quality. No paid conversion date or pricing is assumed.
- Later monetization may gradually add paid advanced services or extra capacity only after product-quality review. Preserve a useful free tier as a product goal.
- Free does not mean unlimited or unprotected: introduce fair-use controls, abuse/spam defenses, per-account and per-IP/device rate limits where appropriate, quotas, cost monitoring, and transparent usage notices. Do not finalize numeric quotas without measured capacity and user approval.
- Home dashboard: central holographic Core with a user-editable Core name; the user's chosen display name and Core name are the same.
- Main modules: AI Chat, Message, AI Hub.
- Additional modules: Profile, Code Studio, File, Memory, Evolving.
- Bottom navigation: Home, Login, Logout, Feedback. Auth state must determine which auth action is available; do not show a misleading active Login and Logout action simultaneously.
- Account data must be isolated per user; sessions, recovery, OTP expiry/retry, and authorization must be designed before enabling private cloud data.

## 3. Integrated voice design
### AI Chat
- Voice input and spoken AI responses.
- User-selectable male/female voice, Hindi/English language preference, speed/volume, stop, and mute controls.
### Message
- Record, send, receive, play/pause, cancel and delete voice messages.
- Voice/video calling are future scope, not assumed to be part of the first MVP.
### AI Hub
- Voice interaction with connected agents.
- Per-agent mute/unmute controls.
- Command Centre coordination and serialized speech output initially; queue other agents to avoid overlapping audio.
- Group voice mode may be considered later.

## 4. AI Hub team model (design finalized except permissions)
- Maximum 10 AI in one Hub, including the Main Centre AI.
- One Main Centre AI.
- Up to three Admin AI appointed only by the Main Centre AI.
- Remaining connected AIs are Sub-AI.
- Admins cannot appoint other Admins.
- Main Centre AI coordinates agents and can appoint/remove Admins.
- Work must continue when one or more Admins are unavailable; if all Admins are unavailable, Main Centre AI works directly with Sub-AIs.
- When Main Centre AI is unavailable, Admins may continue within their already granted rights; they do not inherit Main Centre-only powers.
- Task assignment, status tracking, locking, and handover records are planned to prevent duplicate or conflicting work.
- Permission matrix, Admin scopes, voice/message rights, and emergency delegation remain OPEN for joint design. Do not implement assumed permission rules before approval.

## 5. Free launch, feedback, and staged roadmap
1. **Foundation and internal testing:** inspect existing app/backend architecture, map risks, preserve Update 31 chat behavior, and add regression tests.
2. **Account and security foundation:** design verified signup/login and account linking; do not ship mock authentication as real security. Keep provider secrets server-side and enforce authorization on the server for every private resource.
3. **Free public launch readiness:** core features free for verified accounts; add in-app feedback, bug reports, privacy information, service status, and usage transparency.
4. **Observe and improve:** measure crash-free sessions, latency, queue reliability, voice quality, abuse signals, API cost, and user feedback; prioritize critical security and data-loss issues.
5. **Stability gate:** resolve critical/high-severity defects, verify account isolation and recovery, conduct security review and load tests, and validate restore/backup procedures.
6. **Gradual monetization:** only after product readiness review, introduce paid advanced services/extra capacity in stages; communicate changes clearly and retain a useful free experience.

## 6. Security engineering baseline
- No software can honestly be guaranteed bug-free or impossible to hack. Target defense-in-depth, least privilege, secure defaults, and continuous testing.
- Threat-model authentication, account linking, private data, AI prompts/tool use, file uploads, messaging, AI Hub agent permissions, and API abuse before enabling them.
- Never embed API/provider secrets in the APK or repository; use server-side secret storage and rotation.
- Enforce authentication and per-user authorization server-side on every private API/resource; client-side UI gating is not security.
- Use short-lived access tokens, secure refresh/session rotation and revocation, OTP expiry/attempt limits, replay protection, and anti-enumeration responses.
- Apply input validation, output encoding, transport encryption, secure storage, dependency scanning, secret scanning, and minimal Android permissions.
- Add rate limits, abuse detection, audit/security logs with sensitive data redacted, monitoring/alerts, backups, and incident-response procedures.
- Protect file handling against oversized files, malicious content, path traversal, and unsafe parsing. Apply AI tool permissions and prompt-injection boundaries.
- Review applicable privacy, data retention, consent, and deletion requirements before public launch.

## 7. Safety and implementation boundaries
- Do not deploy or modify the production Cloudflare Worker without explicit user approval.
- Keep AI provider secrets server-side; never embed keys in the APK.
- Authentication, account isolation, and authorization must be designed before enabling private cloud data.
- ChatGPT credit must not imply OpenAI ownership, endorsement, sponsorship, or partnership. AJ AI is an independent AJ SOFTWARE LABS project.
- Privacy/security language must not promise absolute security.
- Build modularly and preserve existing chat history and pending messages.

## 8. Verification gates
- Run Flutter Analyze and automated tests.
- Build a release APK through GitHub Actions.
- Verify installation and key flows on the user's Android device.
- Test login/signup, account data isolation, queue recovery, offline/slow network behavior, chat history restore, Hindi consistency, and voice permissions.
- Mark a feature complete only after implementation and test evidence exist.

## 9. Current implementation status
- Update 31 branch is the starting point for Update 32 work.
- This document records approved design decisions; it does not claim that these features have been implemented.
- Production backend changes, merging protected PRs, and final release approval remain separate explicit decisions.
