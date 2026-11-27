# AJ AI — Intelligence & Execution Core Upgrade Blueprint

Version: 2.0-draft
Date: 2026-11-27
Repository: lavsharma2910-dev/AJ-AI-Android
Working branch: feature/intelligence-execution-core
Baseline commit: 21019085c61ea3d4fa7868c4714ce16bdbaaa269
Status: Approved development direction; implementation not yet started

## 1. Product objective

Upgrade AJ AI from a Gemini-backed chat client into a dependable assistant that understands user intent and context, distinguishes verified facts from estimates and assumptions, researches current information when freshness matters, reasons through multi-step problems, executes tasks only through available authorized tools, checks answer quality, and communicates limitations honestly.

No AI system can guarantee perfect answers. The engineering target is measurable improvement in factuality, completeness, relevance, freshness, and execution reliability.

## 2. Verified baseline and audit observations (read-only audit, 2026-11-27)

### Existing implementation
- Flutter Android client sends POST /chat to the existing Cloudflare Worker.
- Worker calls Gemini using a primary model and a fallback model.
- API key is read from the Worker environment, not embedded in the Android source.
- Worker system instruction already asks for correctness, relevance, uncertainty, and no fabricated facts or citations.
- Android stores local chat history and a persistent pending queue.
- Chat context excludes pending messages and caps recent context to 12 entries.
- Reply insertion uses request IDs to preserve transcript order and avoid duplicate assistant replies.
- Request diagnostics and privacy-conscious Worker timing logs exist.
- Existing test sources cover context filtering, reply ordering, duplicate prevention, retry-notice handling, queue serialization, and request IDs.
- Historical CI evidence on the baseline: 29 Flutter tests passed; Flutter analyze passed with informational notices; Worker syntax check and APK build were reported successful on the documented run. These results are historical and are not a fresh run for this branch.

### Important gaps observed in source
- No live web research, retrieval, citation verification, or independent factuality verifier is implemented in the current Worker request path.
- The current system instruction is a static prompt; it does not provide verified evidence or a source corpus to ground answers.
- The Worker currently tries two Gemini models sequentially, each with a 25-second timeout. The Android request timeout is 60 seconds. Combined model wait can approach 50 seconds before network and serialization overhead, so latency and timeout behavior need measurement and redesign.
- The Android queue retains a failed item and exposes manual retry, but retry count and status are not visibly advanced in the current send path. End-to-end retry and backoff behavior still needs testing.
- The Worker source currently has permissive CORS (Access-Control-Allow-Origin: *) and no visible authentication or rate-limiting check. These are security review items before broader exposure; do not change production behavior without a separate approved and tested plan.
- The current client passes up to 12 context entries; Worker validates roles and truncates history item text, but there is no visible token-budget or semantic relevance selection.
- No tool-routing or task-execution framework is currently connected to the chat endpoint.

## 3. Target request pipeline

1. Request validation: validate payload shape, message size, context size, request ID, and supported operation; apply abuse controls and bounded resource/time budgets.
2. Intent and risk classification: identify question, advice, research, calculation, comparison, creation, or action request; identify freshness requirements and high-impact domains.
3. Context assembly: include only relevant completed turns and user-approved memory; preserve request IDs and conversation boundaries; use a bounded token/context budget.
4. Routing: direct answer for stable low-risk questions; research route for current or source-dependent claims; calculation/reasoning route for structured problems; tool route only when an approved capability exists.
5. Provider orchestration: keep Gemini as the initial provider; keep provider interface modular; use bounded retries, timeouts, cancellation, and fallback policy.
6. Evidence and solution construction: separate source-backed facts from estimates and assumptions; produce a practical complete response or task plan.
7. Answer quality verification: check relevance, completeness, internal consistency, evidence, freshness, and uncertainty; rework once within budget or explicitly disclose unresolved uncertainty.
8. Response and telemetry: return answer, request ID, safe timing/status metadata, and citations where available; never log prompts, private history, API keys, or sensitive content.

## 4. Core modules and responsibilities

### A. Intent Understanding
- Classify request type, expected output, constraints, and whether clarification is essential.
- Preserve explicit user preferences only within approved memory rules.
- Avoid over-questioning when a safe answer can be given.

### B. Knowledge Intelligence
- Establish a fact/estimate/assumption/unknown representation.
- Detect claims that require current verification.
- Apply stricter evidence standards to legal, financial, medical, safety, and other high-impact topics.
- Never fabricate sources, dates, laws, prices, statistics, or earnings.

### C. Research and Evidence
- Add a provider-neutral research interface.
- Research only when current or external evidence materially improves the answer.
- Prefer primary and official sources, compare independent sources when useful, record publication/update dates, and preserve source URLs.
- If research is unavailable or inconclusive, say so.
- Do not add a paid API or service without explicit user approval of the exact service and expected charge.

### D. Reasoning and Solution Engine
- Break complex requests into verifiable steps.
- Recheck calculations and comparisons.
- State assumptions and dependencies.
- Give actionable steps, alternatives, risks, and completion criteria.

### E. Task Execution
- Expose only explicitly implemented and authorized tools.
- Use a plan/execute/verify/report cycle.
- Require confirmation for external messages, purchases, financial actions, deletion, public release, account/security changes, production deployment, or other irreversible/high-impact operations.
- Never claim an action succeeded without a tool result confirming it.

### F. Answer Quality Verifier
- Evaluate correctness against evidence, relevance to intent, completeness, consistency, freshness, and honest uncertainty.
- Do not treat the same model's unsupported confidence as independent verification.
- Use deterministic checks and independent sources/tools where available.
- Keep verification bounded to protect response time and free-tier limits.

### G. Reliability, Memory, and Observability
- Improve queue retry/backoff, timeout budgets, duplicate handling, and recovery.
- Design consent-based memory with view/edit/export/delete controls before enabling cloud persistence.
- Keep privacy-safe metrics; never log message text, chat history, credentials, or sensitive memory.
- Measure latency by stage before optimizing.

## 5. Implementation phases and exit gates

| Phase | Scope | Exit gate |
|---|---|---|
| 0. Audit and baseline | Trace Android request, Worker, prompts, fallback, queue, tests, deployment boundaries | Source map, known gaps, baseline tests and safety review recorded |
| 1. Architecture and contracts | Define request/response schemas, routing interfaces, evidence and verifier contracts | Reviewed blueprint and compatibility plan |
| 2. Knowledge safeguards | Fact/estimate/assumption handling, high-impact caution, uncertainty policy, regression cases | No fabricated citations; known hallucination tests improve |
| 3. Research foundation | Provider-neutral search adapter, source metadata, freshness and citation rules | Current-fact tests cite accessible sources or admit no verification |
| 4. Reasoning and solutions | Structured problem solving, calculations, options, practical steps | Domain test set passes with checked arithmetic and assumptions |
| 5. Task execution foundation | Tool registry, permission gates, plan/execute/verify/report | No unauthorized or unconfirmed side effects in tests |
| 6. Answer verifier | Quality rubric, bounded repair, fail-safe uncertainty | Test set demonstrates measurable quality improvement |
| 7. Reliability and memory | Retry/backoff, timeout budget, queue recovery, memory consent and controls | Regression, offline, privacy, and recovery tests pass |
| 8. Integration and release | Integrate modules, then design refresh, full tests, device QA, signing check | CI and device gates pass; user approves release |

Phases may overlap only where interfaces and safety gates are already stable. Do not start cosmetic redesign before the intelligence core and reliability gates are accepted.

## 6. Test strategy

Build a repeatable AJ AI quality suite with representative Hindi, Hinglish, and English tasks:
- Current legal/policy questions requiring official sources.
- Copyright and commercial-use questions.
- Finance, monetization, commission, and earnings questions where estimates must be labeled.
- Calculations and multi-step comparisons.
- Ambiguous requests requiring one essential clarification.
- Stale or conflicting source cases.
- Unsupported requests where AJ AI must disclose limitations.
- Tool execution requiring explicit confirmation.
- Long history, offline queue, timeout, fallback, retry, duplicate, and app-restart cases.

For each case record expected behavior, actual answer, evidence, severity, and regression status. Measure factuality, completeness, relevance, citation correctness, uncertainty quality, and response time. Do not claim improvement without before/after results.

## 7. Security, privacy, and cost controls

- Maintain zero-cost-first: free/open-source options first.
- No paid API, subscription, credit, hosting, or upgrade without prior explicit approval.
- Keep provider credentials server-side and out of logs and APKs.
- Review CORS, authentication, rate limits, request validation, and abuse controls before wider release.
- Do not deploy the Worker, change secrets, or alter production data without explicit approval.
- Do not enable cloud memory until authentication, authorization, consent, retention, export, and deletion behavior are designed and tested.
- Preserve existing local chat data and backward compatibility.
- Require explicit confirmation for irreversible or externally visible actions.

## 8. Change and backup protocol

- Before every logical code, configuration, or documentation change, create and verify a pre-change GitHub backup branch from the exact working commit.
- Immediately after each logical change, create and verify a post-change backup branch.
- If a backup cannot be verified, stop further modifications.
- Keep module, integration-build, and milestone checkpoints with commit SHA and test/build evidence.
- Do not deploy production or publish a release without explicit user approval.

## 9. Current execution status

- Pre-change checkpoint created: backup/pre-intelligence-core-audit-20261127-1003.
- Baseline commit: 21019085c61ea3d4fa7868c4714ce16bdbaaa269.
- Working branch created: feature/intelligence-execution-core.
- Read-only audit completed for the Worker request path, Flutter chat request/queue path, context builder, diagnostics, existing tests, architecture and feature register.
- This document records the architecture proposal and audit findings. No application code has been changed and no production deployment has occurred.
- Next: implement the first bounded knowledge-safety module only after its exact interface, test cases, and pre-change backup are verified.
