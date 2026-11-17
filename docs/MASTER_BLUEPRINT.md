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

## 11. Update 30 — Privacy-First AI Core Foundation
- Gemini is a temporary prototype engine for functional testing only; provider access is isolated behind a backend adapter.
- No Tavily or other third-party search provider is included. Live web search is disabled in this update.
- The Android `/chat` contract remains stable so a future AJ-owned/self-hosted model can replace the prototype provider.
- Model fallback currently means trying another Gemini model, not switching to an independent AI company.
- Private or sensitive data must not be used in prototype tests because prompts are processed by Google Gemini.
- Future self-hosted inference, AJ-controlled memory, knowledge ingestion and privacy controls remain planned and require separate implementation and verification.
The next AI intelligence layer uses a free-first web research pipeline:
- Gemini remains the response-generation model.
- Tavily Basic Search is called only when the latest question signals freshness/current information or explicit web search intent.
- Search snippets are passed to Gemini as untrusted evidence, never as executable instructions.
- The model is instructed to cite supplied source numbers and disclose weak or conflicting evidence.
- Backend responses include structured source metadata and a readable source list.
- Search credentials stay in Cloudflare Worker secrets; never in Android or Git.
- The free-tier quota must be monitored; paid overage is not enabled by this implementation.
- Knowledge Base / RAG remains a separate future component; web search does not silently become permanent memory.

