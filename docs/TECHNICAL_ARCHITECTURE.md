# AJ AI — TECHNICAL ARCHITECTURE

Version: 1.0
Company: AJ SOFTWARE LABS

## 1. Architecture Overview
AJ AI uses an Android client with a cloud backend. The design separates the user interface, AI services, data storage and security controls.

## 2. Android Application
- Framework: Flutter
- Language: Dart
- Platform: Android
- Local chat history and pending queue use device storage.
- Backend communication uses HTTPS.
- Future: encrypted local memory cache and cloud sync.

## 3. Cloud Backend
- Platform: Cloudflare Workers
- Worker: aj-ai-backend
- Production endpoint: https://aj-ai-backend.lavsharma2910.workers.dev/
- Health endpoint: /
- Chat endpoint: POST /chat
- Deployment: GitHub Actions workflow deploy.yml

## 4. AI Provider Layer
- Current provider integration: Google Gemini
- Current backend supports model fallback.
- API keys remain on the server and must never be embedded in the APK.
- Future: provider abstraction, latency monitoring and controlled retries.

## 5. Memory Architecture — Planned
Hybrid Cloud Memory is the selected design:
- Cloud database as primary memory store.
- Encrypted local mobile cache for offline access.
- Object storage for documents and attachments.
- Semantic search and Retrieval-Augmented Generation (RAG).
- Account-based sync across devices.
- User controls for view, edit, export and deletion.
- Storage limits, retention and costs must be defined before launch.

## 6. Security Requirements
- HTTPS for network communication.
- Server-side secret storage.
- Authentication and authorization before private cloud memory is enabled.
- Rate limiting and request validation.
- Data minimization and consent-based memory.
- Defined backup and deletion procedures.

## 7. Reliability and Performance
- Preserve queued messages until successful processing is confirmed.
- Add safe retry and duplicate-response protection.
- Record per-model and total request latency.
- Test slow networks, timeouts, offline recovery and app restarts.

## 8. Planned Integrations
- Cloud database and object storage.
- Web research service.
- Voice and image services.
- File analysis and AJ Code Studio.
- Approved agent and automation workflows.

## 9. Current Implementation Boundary
Implemented components must be verified against source code and tests. Cloud memory, semantic search, authentication hardening and the planned integrations are not considered production-ready until implemented and tested.

## 10. Change Control
Architecture changes are proposals until reviewed and approved. Record material changes with version, reason, impact and date.

## 11. Update 30 — Current App First

- Current app remains a Flutter Android client connected to the Cloudflare Worker.
- Gemini is the temporary prototype provider. Model access and free-tier quotas are subject to Google AI Studio / Gemini API eligibility, model availability and rate limits.
- Gemini credentials remain server-side only as `GEMINI_API_KEY`; no key in APK or repository.
- Preserve the existing `POST /chat` response contract while improving Android integration and backend reliability.
- No additional AI provider or third-party search provider is introduced.
- No external web-search integration is included in this update.
- Prototype requests must not contain sensitive/private personal data.
- CI success does not replace live API, device, security or regression testing.

## 12. Deferred Independent AJ AI Track (Not in Update 30)
- AJ Brain: reasoning, planning, context, tools and orchestration.
- AJ Provider: AJ-owned API gateway and self-hosted model serving.
- AJ Memory / Knowledge: consent-based storage, retrieval and user controls.
- AJ Model: open-weight model evaluation, fine-tuning, and later foundation-model research.
- This track remains separate until the current Companion app is complete and stable. No integration or deployment without a later explicit approval.
