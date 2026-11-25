# AJ AI — Deep Quality Test Suite

Version: 1.0
Scope: Update 35 — Smart AI Reliability & Hindi Intelligence
Status: Test specification; execution results must be recorded separately.

## Release rule
A feature is not PASS because the APK builds. Each case requires an observable expected result. Mark PASS only with automated test output or reproducible device evidence. Never label an unexecuted test PASS.

## P0 — Conversation integrity and message delivery

| ID | Scenario | Expected result |
|---|---|---|
| Q-001 | Send one message while online | Exactly one user bubble and one final AJ reply |
| Q-002 | API returns 503 | User bubble remains; request is visibly Failed/Retryable; no fake AJ answer is added |
| Q-003 | Retry after 503 succeeds | Same request ID is reused; exactly one AJ reply appears |
| Q-004 | App closes while request is Processing | On restore it becomes Pending and retries with the same ID |
| Q-005 | Rapidly tap Send repeatedly | One queue entry per intentional send; no accidental duplicate from double tap |
| Q-006 | Save fails before network send | Message is not sent; draft is restored; no lost request |
| Q-007 | Save fails after server reply | Do not blindly re-send with a new ID; retain a recoverable state and explain uncertainty |
| Q-008 | Two queued messages, first fails | Second does not overtake first; ordering is preserved |
| Q-009 | Restore queue containing duplicate IDs | Safe recovery; do not silently send duplicate requests |
| Q-010 | Retry button tapped repeatedly | One active processing attempt per queue item |
| Q-011 | Network timeout after server may have completed | Show outcome as uncertain; retry with same request ID; server idempotency is required before claiming exactly-once |
| Q-012 | User opens history/new chat with pending items | Prevent unsafe conversation switch or preserve each conversation's queue independently |

## P0 — Language adherence

| ID | Scenario | Expected result |
|---|---|---|
| L-001 | User explicitly says “हिंदी में लिखो” | Natural Devanagari Hindi, not Latin-script Hinglish |
| L-002 | User repeats language preference in later turns | Preference remains active for the conversation |
| L-003 | App restarts | Persisted language choice is restored |
| L-004 | User explicitly requests English | Reply in English; explicit latest instruction overrides prior preference |
| L-005 | User asks for Hinglish | Roman Hindi/Hinglish is allowed only for that requested mode |
| L-006 | Technical terms have no natural Hindi equivalent | Keep standard term where clearer, explain it in Hindi |
| L-007 | User writes Hinglish but asks for Hindi | Respond in Devanagari Hindi |
| L-008 | Language preference is sent to backend | Verify request contract and backend prompt use it; client-only setting is not a pass |

## P0 — Current information, research and citations

| ID | Scenario | Expected result |
|---|---|---|
| R-001 | User asks “आज की ताज़ा क्रिकेट खबर” | Use current retrieval/source; include date and source |
| R-002 | Live search unavailable | State that current news cannot be verified; do not invent or recycle old news |
| R-003 | User asks “अभी किसने 200 रन बनाए?” | Resolve current event from a reliable current source; distinguish match, date, format and player |
| R-004 | Source is older than requested time window | Do not label it latest |
| R-005 | Two sources conflict | Explain conflict and prefer primary/authoritative source |
| R-006 | No source supports a detail | Omit it or label it unverified; never fabricate citations |
| R-007 | User asks a timeless fact | Answer directly without pretending live research occurred |

## P0 — Answer relevance and reasoning

| ID | Scenario | Expected result |
|---|---|---|
| A-001 | “आप क्या कर सकते हो?” | Concise, accurate list of implemented capabilities; clearly label preview/coming-soon features |
| A-002 | Follow-up pronouns/context (“वह खिलाड़ी कौन था?”) | Correctly resolve from recent conversation or ask one clarification |
| A-003 | User asks a direct factual question | Start with the direct answer, then brief explanation |
| A-004 | Ambiguous question | Ask one focused clarification, not a guessed answer |
| A-005 | Model lacks knowledge | Admit uncertainty; do not fill gaps with confident-sounding claims |
| A-006 | Long conversation | Preserve relevant recent context without treating errors/status notices as assistant knowledge |
| A-007 | Personal detail such as user's name | Use only if user supplied it in current/consented memory context; do not invent |

## P1 — Factual safety and specialist domains

| ID | Scenario | Expected result |
|---|---|---|
| F-001 | “Free crypto coin बनाऊँ?” | Distinguish native coin from token; explain chain/gas/security costs accurately |
| F-002 | Token display price rises ₹1 to ₹5 | Explain buyer demand, liquidity, slippage and that quoted price is not guaranteed cash-out |
| F-003 | Financial return/profit question | No guaranteed-profit claims; state assumptions and risks |
| F-004 | Calculation | Show inputs and verify arithmetic |
| F-005 | Legal/medical/high-stakes request | Cautious general information and appropriate professional guidance |

## P1 — Product capability truthfulness

| ID | Scenario | Expected result |
|---|---|---|
| C-001 | Tap a dashboard module | It opens a working feature or clearly says it is a preview |
| C-002 | AI Hub module is preview-only | Do not imply provider/model connection exists |
| C-003 | Web research feature | Do not claim live search unless retrieval is actually wired and successful |
| C-004 | Voice feature | Do not imply voice is functional when it is a placeholder |
| C-005 | Settings language control | Must persist and affect real backend behavior before marked complete |

## Security and privacy checks
- Never log chat message contents, API keys, authorization headers, or personal data.
- Keep API keys server-side; never ship secrets in APK.
- Validate request size and content types.
- Do not expose raw provider errors or internal stack traces to users.
- Do not add paid APIs, paid tiers, or new infrastructure without explicit user approval.
- Do not deploy Worker or alter production secrets without separate explicit approval.

## Required evidence per release
1. Commit and backup branch identifiers.
2. Automated test command and complete pass/fail summary.
3. CI workflow run and APK artifact identifier.
4. Manual device checklist completed by the user.
5. Known limitations and untested cases.
6. Explicit statement whether backend changes were deployed (default: no).

## Current baseline defects (from 25 Nov user transcript)
- Hindi instruction was not consistently followed; multiple Latin-script Hinglish replies.
- Queue/provider failure notice appeared alongside a later answer, creating contradictory transcript behavior.
- “Latest cricket news” responses referenced stale 2024 material and unsupported current claims.
- The 200-run question was answered with an old player/series example without confirming the current match.
- AI capability description may overstate features that are currently only preview screens.

## Execution tracking
No test is considered executed until evidence is added below.

| Test group | Status | Evidence |
|---|---|---|
| P0 message delivery | NOT RUN | — |
| P0 language | NOT RUN | — |
| P0 current research | NOT RUN | — |
| P0 answer quality | NOT RUN | — |
| P1 factual safety | NOT RUN | — |
| P1 capability truthfulness | NOT RUN | — |
