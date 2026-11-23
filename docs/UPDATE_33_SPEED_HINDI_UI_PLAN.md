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
