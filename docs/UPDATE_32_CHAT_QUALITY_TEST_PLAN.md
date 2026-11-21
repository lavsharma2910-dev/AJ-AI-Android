# Update 32 — Chat Reliability, Response Quality & Design Test Plan

Status: implementation in progress; no APK acceptance claim until CI and device testing pass.

## Product acceptance principles
1. Accuracy First: answer the exact user question directly, accurately, and transparently.
2. Hindi means natural Devanagari Hindi when requested; Hinglish is not an acceptable substitute in that mode.
3. Never invent live market/news/pricing facts, citations, or claim a search/test that did not happen.
4. Short questions receive concise direct answers; details follow only when useful or requested.

## Implemented in this branch
- Add Copy All to the chat overflow (three-dot) menu.
- Add Share All to the chat overflow and route the app-bar share action through the same full-transcript snapshot.
- Generate copy/share/view transcript from one shared transcript formatter and a stable snapshot of the loaded conversation.
- Replace the human-like home Core and chat header symbol with an abstract AI Core motif.
- Strengthen the Worker system instruction for directness, relevance, Devanagari Hindi, factual uncertainty, and no fabricated current facts.

## Manual APK acceptance tests
### Chat copy
- [ ] Three-dot menu visibly contains Copy All.
- [ ] Copy All copies every message from the loaded conversation in chronological order.
- [ ] Transcript labels user messages as आप and assistant messages as AJ AI.
- [ ] Paste into Notes/WhatsApp; verify first, middle, and last messages and long messages.
- [ ] Empty conversation / history-loading state does not report success.

### Chat share
- [ ] Share All is available in the overflow menu.
- [ ] App-bar Share and Share All produce the same complete transcript.
- [ ] Share to WhatsApp, Gmail, and Notes; verify first, middle, and last messages.
- [ ] Selected-message Share continues to share only selected messages by design.
- [ ] Test a long conversation and verify the receiving app contains the full text.

### AI answer quality
- [ ] Ask for Hindi explicitly; answer must be natural Devanagari Hindi.
- [ ] Ask a one-line factual question; answer begins with the direct answer.
- [ ] Ask a multi-part question; every part is addressed.
- [ ] Ask an ambiguous question; AJ asks one concise clarification.
- [ ] Ask for current market/FII-DII data; AJ does not fabricate data or causes when live verification is unavailable.
- [ ] Ask a calculation; independently verify arithmetic.
- [ ] Ask a follow-up using earlier context; verify relevant context is used without unrelated repetition.
- [ ] Ask an answer outside available knowledge; AJ states uncertainty plainly.

### UI / regression
- [ ] App launches and Home renders without overflow on small screens.
- [ ] Abstract AI Core renders; no human avatar icon remains in the Home Core or Chat header.
- [ ] Chat send, history restore, offline queue, retry, new chat, delete and selection actions still work.
- [ ] No chat data is lost during copy/share.
- [ ] Test offline and slow-network behavior.

## Limits / deployment boundary
- The Worker source change is not a production deployment. Production Cloudflare Worker must remain untouched without explicit user approval.
- The prompt improves response behavior but does not add web search, live-data retrieval, citations, or a new model. Those require separately designed and tested backend capabilities.
- CI build success is not proof of answer accuracy; the manual quality suite is mandatory.
- No merge of protected PRs and no public launch without explicit approval.


## User-device test report (2026-11-21)

Verified by the user on the installed APK:
- Copy All copies the complete conversation correctly.
- Share All shares the complete conversation correctly.
- Delete All removes the conversation as expected.
- Delete confirmation appears; cancelling leaves the conversation intact.
- Copy, share, and delete work correctly in long conversations.

User acceptance: **5/5 chat-management checks passed** (based on the user's hands-on report; not automated test results).

Response-time feedback:
- The user reports response speed has improved compared with earlier builds.
- Current observed response time is still around **19–20 seconds** and is considered too slow; substantial improvement remains.
- This is subjective user-observed feedback, not a measured benchmark.

## Update 33 kickoff — response latency + Hindi answer quality

Priority work:
1. Trace Android request/response path and determine whether the client waits for the full response (streaming absent/available).
2. Use existing Worker logs (gemini_attempt durationMs, chat_complete totalDurationMs, and fallbackUsed) to separate primary-model latency, fallback latency, and total request time; do not guess at the bottleneck.
3. Design safe timing diagnostics that avoid logging user prompt/answer text or other personal data.
4. Improve persistent language preference handling so explicit natural Devanagari Hindi requests are respected across turns, without archaic or overly Sanskritized wording.
5. Add a repeatable quality/latency evaluation checklist and compare changes before claiming improvement.

Constraints: no production Cloudflare Worker deployment, PR merge, or public release without explicit user approval. Do not promise 2–3 second responses until measured and demonstrated.
