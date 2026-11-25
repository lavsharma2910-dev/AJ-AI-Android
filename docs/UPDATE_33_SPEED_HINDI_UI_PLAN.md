# Update 33 — Response Speed, Hindi Quality & Premium UI
Status: diagnostic and implementation plan; no release acceptance until CI and device testing pass.

## Scope
- Android client request/response timing and user-visible wait behavior.
- Backend stage timing using safe metrics only.
- Natural Devanagari Hindi language consistency.
- Premium abstract AI Core design, Neon Blue/Purple, responsive small-screen layout.
- Regression testing of existing chat features.

## Baseline facts from source inspection
- Chat currently uses an HTTP POST and awaits the complete response body.
- The inspected request timeout is 60 seconds.
- Streaming is not implemented in this inspected client request path.
- Chat state and offline queue persistence are present; their regression tests remain required.
- Current observed 19–20 second response latency is user feedback, not a benchmark.

## Latency measurement plan
Record only durations and non-sensitive outcome flags. The Android client now emits a debug-only line in the form `AJ_AI_METRIC request_ms=<duration> status=<code-or-none> outcome=<category>`. It measures the HTTP round-trip through response-body completion; it does not include later UI persistence/display work. The diagnostic line never includes message/answer text, prompt history, account identifiers, tokens, or PII. Outcomes are limited to success, HTTP error, network error, and response error. No metric is sent to a separate analytics service. Never log message text, AI answer text, account identifiers, tokens, or personal data.
- Android: request start, response received, decode completed, UI answer displayed.
- Backend: total chat completion duration; primary model attempt duration; fallback used (boolean); HTTP outcome category.
- Compare at least 10 representative requests before and after changes; report median and range. Include Hindi, English, short, multi-part, calculation, and follow-up prompts.
- No target promise (e.g. 2–3 seconds) until results demonstrate it.

## Hindi quality acceptance
- Explicit Hindi preference is respected with natural Devanagari.
- Avoid archaic/overly Sanskritized wording and avoid Hinglish unless user asks.
- One-line questions get concise direct answers.
- Multi-part questions answer each part.
- Ambiguous prompts ask one focused clarification.
- Live facts are not invented when live retrieval is unavailable.
- Contextual follow-up uses prior relevant details without unrelated repetition.

## Premium UI acceptance
- Neon Blue + Purple visual system, abstract holographic/infinity AI Core (no human avatar).
- Home cards and navigation remain tappable and have meaningful destinations or clearly labeled previews.
- No overflow on small screens; accessible text contrast and tap targets.
- Animations remain smooth and do not block chat input.

## Regression matrix
Mark each test PASS / FAIL / PARTIAL / NOT TESTED and attach evidence:
- Home render, AI Core animation, cards, navigation, small-screen layout.
- Chat send/receive, New Chat, History restore, Copy All, Share All, Delete All and confirmation.
- Message selection/copy/share/delete.
- Offline queue persistence, retry and reconnect.
- Hindi/English, follow-up context, arithmetic, multi-part answers, uncertainty.
- Slow network, repeated sends, loading state, response timing.
- Restart persistence, crash/recovery, deletion behavior, no data loss.

## Change/backup discipline
For each significant source change: checkpoint branch/commit -> change -> analyze/test -> build APK -> device test -> fix -> rebuild/retest -> checkpoint successful result. Keep failing experiments on the development branch; do not overwrite the last verified checkpoint.

## Approval boundary
Do not deploy production Cloudflare Worker, merge protected PRs, or publish/release without explicit user approval.


## Verified checkpoint — 24 Nov 2026

- Working branch commit: `f2c7ee78aa1e514cb27a3af7d2380a680cedc84b`.
- CI run: [Build #69](https://github.com/lavsharma2910-dev/AJ-AI-Android/actions/runs/45332936299) — **PASS**.
- Flutter analysis: **PASS** with 23 info-level lint/deprecation findings; no analyzer errors or warnings blocked the run.
- Automated tests: **16/16 PASS** (queue model, request diagnostics, and app startup).
- Release APK: **PASS**, built as `app-release.apk` (51.1 MB).
- APK SHA-256: `9f1668f0c565b2ebe1dc580936710f86f0dcf271fa1fc54eb1100e3af0225bdf`.
- GitHub artifact: `AJ-AI-APK`, artifact ID `14892990929`, expires 22 Feb 2027.
- Request timing is client-side round-trip timing only and is emitted in debug builds as duration/status/outcome fields. No prompt or answer content is written by this metric. Backend stage timing is **NOT IMPLEMENTED**; no Cloudflare production Worker was changed or deployed.
- Device QA is **NOT TESTED**. The current premium neon blue/purple abstract AI Core UI is included. Home modules Voice Chat, Code Studio, Web Search, My Files, Memory, Notifications, and the Avatar/Profile destinations remain preview/placeholders and must not be treated as fully implemented.
- Next gate: install this APK on a physical Android device, verify the existing chat/history/queue actions and home navigation, then record Hindi quality and at least 10 request timings. Keep the build as a test APK, not a public release.


## Install compatibility gate — 24 Nov 2026

The previously confirmed phone build (GitHub Actions build #18, artifact `14245265678`) and the Update 33 test build #69 (artifact `14892990929`) were both downloaded and their APK v2 signing certificates were inspected.

- Earlier build #18 certificate SHA-256: `97ab1c74070fed6543ae61ab8f130bd704b9f1b0dcecced3f95c709531810349`.
- Update 33 build #69 certificate SHA-256: `c7904b93d5ab39327708c989bdd5063d2db9a781751770d30eb77450dcf06174`.
- The signing certificates **do not match**. Android will reject installing #69 as an update over #18.
- **Do not uninstall the existing app** to work around this: local chat history and pending messages may be lost.
- The old runner's private debug signing key is not present in the repository or either APK artifact. A new stable signing key would secure future builds but cannot recreate the old certificate.
- Physical-device QA is **BLOCKED pending a safe install route**. Possible routes requiring user approval: a side-by-side test package with a distinct application ID (separate app data), or a user-approved export/backup process before a fresh install. A persistent signing keystore and GitHub Actions secret also require explicit user approval and only solve future upgrades.
- No signing secrets were created or changed; no app uninstall, data deletion, PR merge, or production deployment was performed.

## Repository audit — 25 Nov 2026

- Requested base commit `9c358ce9bdee255dd2e8d25e080cc1d35a195f7c` was verified to exist. The working branch `feature/update-33-response-speed-hindi-quality` currently points to `49f8d285b66f7a129344d5edd5c1a3885657dacb`; GitHub comparison confirms the requested base is its merge base.
- A recoverable pre-audit checkpoint was created and verified at `backup/update33-before-latency-privacy-20261125`, pointing to `49f8d285b66f7a129344d5edd5c1a3885657dacb`.
- Privacy review of `lib/request_diagnostics.dart`: emitted client diagnostic fields are restricted to elapsed request milliseconds, HTTP status (or `none`), and one of four fixed outcome categories. No prompt, response, account ID, token, or PII is accepted by the metric API.
- Privacy review of `backend/worker.js`: structured console events contain fixed event names, model identifier, success flag, HTTP status, duration milliseconds, and fallback boolean. They do not include request body, prompt, generated answer, API key, or user identifier. This is source inspection only; production logs were not accessed.
- Existing tests in `test/request_diagnostics_test.dart` cover success, HTTP failure, pre-response/network failure, malformed/empty response classification, and idempotent finalization. The success test's exact output regex also guards against extra content fields.
- Android debug metrics are guarded by `kDebugMode`; the Worker logs duration/outcome metadata on the server. No external analytics service is used.
- Last verified CI for this branch: [Build #71](https://github.com/lavsharma2910-dev/AJ-AI-Android/actions/runs/45334026024) — PASS on commit `49f8d285b66f7a129344d5edd5c1a3885657dacb`.
- This run made no application-source or Worker changes. No new CI run was triggered. Physical-device latency sampling (10 representative requests), backend log sampling, and end-to-end Hindi answer-quality verification remain NOT TESTED.
