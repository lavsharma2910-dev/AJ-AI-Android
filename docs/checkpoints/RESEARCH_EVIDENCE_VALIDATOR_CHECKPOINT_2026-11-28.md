# AJ AI — Research Evidence Validator Checkpoint
Date: 2026-11-28
Status: REVIEW / DRAFT ONLY

## Project
Repository: lavsharma2910-dev/AJ-AI-Android
Main branch baseline: db7bf0637b6b6857b46689fb005ec5ea4bc21c4f
Verified backup branch: backup/research-validator-pre-update-20261128
Review branch: feature/research-evidence-validator-review-20261128

## Verified backup state
- Backup branch compared with main: identical.
- ahead_by: 0
- behind_by: 0
- No changes were made to main.
- No deployment was performed.

## Current task
Review the Gemini-produced pure ESM module: backend/research_evidence_validator.mjs
Expected companion tests: backend/research_evidence_validator.test.mjs
The latest module source was supplied in the conversation on 2026-11-28. The complete test file has not yet been supplied in this checkpoint conversation and tests have not been executed.

## Initial review findings requiring correction or validation
1. Source independence currently counts unique canonical URLs as distinct independent sources. Different URLs, and even different domains, do not prove editorial or ownership independence. Confidence scoring must not overstate independence.
2. Hindi negation handling has a token-length filter that drops single-character न; negation detection needs adversarial tests.
3. Numeric contradiction detection compares same-unit values without confirming that entity, metric, and time period match; this can produce false conflicts.
4. Date parsing uses JavaScript Date parsing and needs strict validation of impossible calendar dates.
5. URL safety needs additional reserved IPv4/IPv6 edge-case review; credential-bearing URLs must never become trusted evidence.
6. Publisher/domain mismatch currently warns but may still leave the record trusted; define and test a safe policy.
7. Lexical overlap is heuristic only. It cannot establish semantic entailment or factual truth. Preserve a clear disclaimer.
8. Invalid/unsafe records must be consistently excluded from trust, source-independence, conflict, and confidence calculations.

## Guardrails
- Keep all work on the isolated review branch.
- Do not modify main, merge, deploy, or change production configuration.
- Do not add dependencies or network/fetch calls; target Cloudflare Worker-compatible pure JavaScript ESM.
- Use Node built-in node:test for tests.
- Do not claim tests pass until they have actually run.
- Review and test before asking the Project Owner for integration approval.

## Next actions
1. Obtain/verify the complete companion test file.
2. Review the module and tests, then implement corrections on the isolated branch only.
3. Run the full test suite and report exact pass/fail output.
4. Conduct security, edge-case, and regression review.
5. Present a checkpoint and wait for explicit Project Owner approval before integration, merge, or deployment.
