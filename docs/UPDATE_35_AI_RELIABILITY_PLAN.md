# Update 35 — Smart AI Reliability & Hindi Intelligence

Status: implementation started; planning checkpoint only. No production backend changes or deployment.

## Baseline (24 Nov 2026)
- Working branch: `feature/update-34-full-neon-design`
- Baseline commit: `0e22eb22310effd69f79e2df26f453b2dce7b9fc`
- Pre-change backup: `backup/update35-before-reliability-20261124`
- Build #77: PASS; run ID `45452571491`; artifact `AJ-AI-APK`, ID `14948922559`.
- Existing Android chat persists messages and queue items with stable request IDs.
- Existing queue sends requests sequentially; an error is currently appended to the chat as an AJ message while the original request remains queued. This can make the transcript appear contradictory when a later retry succeeds.
- The Android request includes requestId, but the current Worker does not implement idempotency/deduplication for requestId.
- Worker has primary and fallback Gemini model attempts. It logs attempt outcome and duration, but Android does not display model/fallback metadata.
- Worker currently has a language-matching instruction, but there is no persistent in-app language preference setting.
- Worker source is inspected only. Do not deploy or change production Worker without separate explicit approval.

## Scope and order
1. Improve client-side message lifecycle so queued, processing, failed, and completed states are distinguishable; do not append transient transport errors as permanent assistant answers.
2. Preserve stable request IDs through retries and add regression tests for queue identity/status behavior.
3. Inspect and improve duplicate-send protection on the Android client. Do not claim server-side exactly-once delivery until backend idempotency is implemented and deployed.
4. Add persistent Hindi/English preference only after confirming the current UI/settings architecture and request contract. A client-only preference that the backend ignores is not accepted as complete.
5. Surface backend model/fallback metadata only if it is safely supported by the existing response contract.
6. Review answer quality prompt behavior with test cases; keep factual uncertainty and finance/crypto accuracy tests.
7. Build APK and verify CI. Physical-device testing remains a user action; do not claim it passed without user evidence.

## Acceptance tests
- Hindi preference persists across app restart and backend actually receives/uses it.
- Network failure leaves one queued request with its original stable ID.
- Retry does not create a second visible user message.
- Failed attempt is shown as status/error, not as a successful AJ answer.
- Successful retry creates exactly one assistant reply in the local transcript.
- Repeated taps cannot enqueue duplicate requests accidentally.
- Existing history and offline queue regression tests pass.
- No chat content, tokens, keys, or personal data in logs.

## Guardrails
- Keep the approved Dashboard layout and holographic core unchanged.
- Temporary Guest Login remains available for testing; do not remove it in this update.
- Free/open-source only; no paid APIs/services/credits or upgrades.
- No Worker production deployment, secret changes, signing changes, PR merge, release, data deletion, or destructive migration without explicit approval.
- Create a backup before every logical code-change batch and a post-change checkpoint after successful tests.
