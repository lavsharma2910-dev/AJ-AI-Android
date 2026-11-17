# AJ AI — MASTER PRODUCT BLUEPRINT

Version: 1.1
Status: Living Blueprint
Company: AJ SOFTWARE LABS
Tagline: Build. Innovate. Automate.

## 1. Vision

AJ AI is an advanced Hindi and English AI companion and productivity ecosystem.

Core goals:
- Natural AI chat
- Long-term personal and project memory
- Voice companion
- AI image generation and editing
- File and document analysis
- Live web research
- Code and project development studio
- AI agents and approved automation

## 2. Current Project Architecture

- Android application: Flutter
- Development environment: Android + Termux
- Repository: AJ-AI-Android
- Main branch: main
- Backend: Cloudflare Workers
- Backend URL: https://aj-ai-backend.lavsharma2910.workers.dev/
- Android APK builds: GitHub Actions
- AI provider: Gemini with fallback support

## 3. Current Development Status

- Basic AJ AI Android application: implemented
- Chat API connection: implemented
- Local chat history: implemented
- Copy message and Copy All: implemented
- Smart message queue: implemented
- Queue persistence and retry controls: implemented in source
- Latest queue commit: a636ab2
- Queue APK device testing: initial behavior observed
- Response speed optimization: pending measurement
- Cloud Memory Engine: planned
- Documentation system: being established

Note: Features are not considered release-complete until appropriate tests pass.

## 4. Advanced Memory Engine v1.0

Selected architecture: Hybrid Cloud Memory.

Components:
1. Conversation Memory
2. Personal Memory
3. Project Memory
4. Knowledge and Document Memory
5. Semantic Search
6. Retrieval-Augmented Generation (RAG)
7. Cloud synchronization
8. Encrypted mobile cache and backup
9. Memory export, edit and deletion controls

Storage strategy:
- Cloud database for structured records
- Object storage for documents and attachments
- Vector search for semantic retrieval
- Mobile encrypted cache for offline access
- Backup and restore procedures

Retention:
Keep records until the user requests deletion, subject to documented backup and deletion policies.

Memory must be permission-based. Sensitive information must not be stored without appropriate consent.

Unlimited storage is not promised. Storage should be expandable according to actual provider limits and cost.

## 5. Development Roadmap

Phase 1: Foundation and documentation
Phase 2: Advanced Chat and Queue
Phase 3: Smart AI Core and Speed Optimization
Phase 4: AI Web Research
Phase 5: Knowledge and Memory Engine
Phase 6: Decision Intelligence
Phase 7: Voice Companion
Phase 8: AI Image Studio
Phase 9: File and Document Studio
Phase 10: AJ Code Studio
Phase 11: Self-Evolving Knowledge System
Phase 12: AI Agent and Automation
Phase 13: Cloud Sync and Personalization
Phase 14: Quality and Security Testing
Phase 15: Production Launch

## 6. Product Expansion

After the current AJ AI development batch:
1. Official AJ SOFTWARE LABS website
2. AJ SOFTWARE LABS company Android application
3. School Manager
4. Property CRM
5. Transport Manager
6. Clinic Appointment Manager
7. AI Customer Support

## 7. Engineering Rules

- Safety before quality; quality before release.
- Back up files before major changes.
- Never delete existing backups without approval.
- Never commit unrelated or unreviewed files.
- Keep API secrets on the server.
- Test before marking features complete.
- Measure APK size and performance after meaningful releases.
- Preserve working features during upgrades.
- Major Blueprint changes require review and approval.

## 8. Versioning

- v1.0: Original product foundation
- v1.1: Expanded ecosystem and Memory Architecture
- v1.2: Technical architecture updates
- v2.0: Major product or architecture revision

The Blueprint is a living document. New features and changes must be recorded with reason, impact and approval.

## 9. Release Standard

A release candidate requires:
- Successful cloud build
- Functional tests
- Regression tests
- Network failure tests
- Security and privacy checks
- APK size report
- Device installation and usability tests

## 10. Current Priority

1. Verify Queue and Retry behavior
2. Measure actual response latency
3. Improve backend speed using measured evidence
4. Complete project documentation
5. Design and implement Memory Engine

## 11. Update 30 — AJ AI Companion Stabilization (Gemini Prototype)

Current objective: finish and stabilize the existing AJ AI Companion app before beginning the independent AJ Brain / AJ Self Provider program.

In scope:
- Keep Google Gemini API as the temporary prototype AI engine, accessed only from the Cloudflare Worker.
- Preserve the existing Android `POST /chat` integration contract.
- Keep API keys server-side in Cloudflare secrets; never include them in Git or APK.
- Continue Android chat, queue/retry, local history, and backend reliability work.
- Test model availability, quota handling, latency, failure recovery and Android response parsing.
- Do not send sensitive/private personal data during Gemini prototype testing.
- Do not add Tavily or any other third-party AI/search provider in this update.
- Web research remains out of scope until a privacy-approved approach is explicitly selected.

Deferred Future Track (separate project; not part of current app update):
- AJ AI Brain and orchestration engine
- AJ-owned Provider API and self-hosted inference
- AJ-controlled Memory / Knowledge platform
- AJ fine-tuned model and future AJ Foundation Model

The Future Track must not delay or destabilize the current Companion app. Integration is considered only after the independent system is implemented, security-reviewed and fully tested, followed by explicit user approval.

## 12. Update 30 Verification
- GitHub Actions run 44165637617: PASSED (build job completed successfully).
- This CI result confirms the workflow run only; it does not prove live Gemini API access or real-device regression.
- Live Gemini API test: PENDING; requires configured server-side `GEMINI_API_KEY`.
- Cloudflare production deployment: NOT PERFORMED.
- PR merge: NOT PERFORMED.
