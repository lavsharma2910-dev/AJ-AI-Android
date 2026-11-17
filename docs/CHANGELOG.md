# AJ AI — CHANGELOG

Version: 1.0
Company: AJ SOFTWARE LABS

This file records known project changes. Planned work is not marked as completed.

## 2026-11-15

### Queue Safety and Retry Controls
- Commit: a636ab2
- Improved pending message queue processing.
- Added queue persistence checks.
- Added retry controls in the chat interface.
- Kept failed queue items pending for retry.
- Consecutive message queue behavior observed on device; reliability testing remains pending.

### Project Documentation
- Created and verified MASTER_BLUEPRINT.md version 1.1.
- Created FEATURE_REGISTER.md version 1.0.
- Created TECHNICAL_ARCHITECTURE.md version 1.0.
- Documented Hybrid Cloud Memory as the selected future architecture.

## Earlier Known Milestones

- d6bc718 — Cloudflare chat integration.
- 9577256 — Chat copy and local history.
- 471f2e4 — Copy All and Select All conversation support.

## Current Pending Work
- Complete queue failure, restart and offline recovery tests.
- Measure backend model latency and total response time.
- Improve backend authentication and rate limiting.
- Design and implement cloud memory storage and synchronization.
- Complete regression, security and release testing.

## Record Keeping
- Add entries only after the corresponding change is verified.
- Include commit hash where available.
- Keep planned features separate from completed work.

## Update 30 — Privacy-First AI Core Foundation (2026-11-17)
- Replaced direct provider-specific chat orchestration with a backend AI adapter entry point.
- Kept Gemini as a temporary prototype engine with model-level fallback.
- Removed Tavily search integration, search triggers, search secrets and third-party web-search calls from Worker source.
- Explicitly reports external web search as disabled; no live-search capability is claimed.
- Added tests for provider selection, adapter boundary and conversation context.
- No production Worker deployment or PR merge performed.
- Branch: feature/update-30-web-knowledge
- Added Tavily Basic Search integration to the Cloudflare Worker.
- Added explicit freshness/search intent detection; ordinary chat does not spend search credits.
- Added source URL validation, duplicate filtering, result limits and short timeout.
- Added source links to the AI reply and a structured `sources` response field.
- Added backend tests for search intent and unsafe/malformed search results.
- Tavily API key is a Cloudflare Worker secret and is not stored in source or APK.
- Live provider calls and APK build remain pending CI and secret configuration; no production deployment performed.

