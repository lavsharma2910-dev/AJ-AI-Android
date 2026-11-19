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
- Add a Welcome / Explore experience with guest-first access and optional account creation/login.
- Add integrated voice entry points in AI Chat, Message, and AI Hub, with feasibility and provider review before implementation.

## 2. Welcome, Guest Mode, accounts, home and navigation
### Guest-first access (approved)
- AJ AI should open for new users without forcing account creation or login.
- Welcome page offers three clear choices: Continue as Guest, Create Account, and Login.
- Guest users can try AI Chat and voice experience within reasonable usage limits, and explore the dashboard/features preview.
- Guest chat history may be stored locally on the device. Do not persist guest personal data to cloud storage by default.
- Account creation/login is prompted contextually when a guest opens account-dependent features; do not block basic exploration with an upfront login wall.
- Account-required features include cross-device/cloud chat sync, persistent personal Memory, user-to-user Message, AI Hub collaboration, and account-linked files/projects/profile.
- Explain the benefit before asking a guest to sign up. Do not silently discard local guest history; where technically feasible, offer an explicit choice to transfer eligible local history into the new account.
- Keep guest usage limits configurable and transparent; do not invent a fixed quota until product/backend constraints are reviewed.

### Account and authentication design
- Signup methods planned: email, mobile number, and Google sign-in.
- Email/mobile OTP and Google authentication require a secure provider/backend design.
- Account data must be isolated per user; sessions, recovery, OTP expiry/retry, and authorization must be designed before enabling private cloud data.
- Login remains available from navigation for returning users. Login/Logout presentation must reflect actual auth state.

### Welcome and dashboard
- Welcome page: company name, tagline, AJ AI introduction, development story, accurate ChatGPT development-assistance credit, signup entry, and Explore preview.
- Home dashboard: central holographic Core with a user-editable Core name; the user's chosen display name and Core name are the same.
- Main modules: AI Chat, Message, AI Hub.
- Additional modules: Profile, Code Studio, File, Memory, Evolving.
- Bottom navigation: Home, Login, Logout, Feedback. Auth state must determine which auth action is available; do not show a misleading active Login and Logout action simultaneously.

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

## 5. Safety and implementation boundaries
- Do not deploy or modify the production Cloudflare Worker without explicit user approval.
- Keep AI provider secrets server-side; never embed keys in the APK.
- Authentication, account isolation, and authorization must be designed before enabling private cloud data.
- ChatGPT credit must not imply OpenAI ownership, endorsement, sponsorship, or partnership. AJ AI is an independent AJ SOFTWARE LABS project.
- Privacy/security language must not promise absolute security.
- Build modularly and preserve existing chat history and pending messages.

## 6. Verification gates
- Run Flutter Analyze and automated tests.
- Build a release APK through GitHub Actions.
- Verify installation and key flows on the user's Android device.
- Test guest-to-account transition, local history handling, queue recovery, offline/slow network behavior, chat history restore, Hindi consistency, and voice permissions.
- Mark a feature complete only after implementation and test evidence exist.

## 7. Current implementation status
- Update 31 branch is the starting point for Update 32 work.
- This document records approved design decisions; it does not claim that these features have been implemented.
- Production backend changes, merging protected PRs, and final release approval remain separate explicit decisions.
