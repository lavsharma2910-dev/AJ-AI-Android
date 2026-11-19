# AJ AI Update 32 — Registration & Security Implementation Plan

Status: Approved product direction; provider/backend implementation not yet verified.

## Product rule
- No Guest account or Guest Mode.
- Signup and verified Login are required before entering the platform.
- One AJ AI account may link a verified mobile number, verified email address, and Google Sign-In identity.
- Signup is not complete until at least one chosen identity provider is verified.
- Linking another login method requires a fresh authenticated session and proof of control of the new method.
- Detect existing identities and offer safe sign-in/account recovery; never silently merge accounts based only on matching display names.

## Proposed user journeys
1. Welcome → Create account → choose Mobile / Email / Google.
2. Mobile: request OTP → verify OTP → create or resume the AJ AI account.
3. Email: send one-time verification code/link → verify → create or resume the AJ AI account.
4. Google: OAuth/OIDC sign-in using verified provider identity → create or resume the AJ AI account.
5. Complete profile → authenticated Home.
6. Existing user: Login → verify using a linked method → authenticated Home.
7. Settings → Link another method → re-authenticate → verify new method → attach to the same account.
8. Recovery: prove control of a linked method; do not disclose whether an arbitrary email/mobile is registered.

## Security architecture requirements
- Choose a supported identity provider only after inspecting existing Cloudflare Worker routes, environment bindings, and available Firebase/Google configuration. Do not assume that a client-side Firebase config means Firebase Auth is configured.
- Prefer standards-based OIDC/OAuth or a mature managed authentication provider over custom password/OTP cryptography.
- Provider secrets, signing keys, and service credentials remain server-side. Never put secrets in Dart source, APK assets, Git history, or client environment files.
- The backend must verify token signature, issuer, audience, expiry, nonce/state, and required claims. Client-side checks are never authoritative.
- Every private API request must be authenticated and authorized server-side. Enforce user ownership at the data layer; deny by default.
- Use short-lived access tokens, secure refresh rotation, session revocation, OTP expiry, attempt throttling, replay protection, and anti-enumeration responses.
- Account linking requires recent re-authentication and verified ownership of both identities.
- Apply rate limits and abuse controls per account and appropriate network/device signals; avoid relying on IP-only controls.
- Keep audit logs for security events, redact tokens/OTP/PII, and define retention limits.
- Add dependency/secret scanning, least-privilege permissions, secure Android storage, TLS, input validation, and security regression tests.
- Define data export/deletion, consent, privacy notice, backup, incident response, and account recovery before public launch.

## Delivery phases
### Phase A — discovery (first)
- Inspect current app routes, API contract, Cloudflare Worker source/configuration, secrets/bindings names (never values), and current data storage.
- Document the threat model and select the identity provider.
- Keep production backend untouched until separately approved.

### Phase B — UI and contract
- Build Welcome, Signup, verification, Login, recovery, and linked-method screens.
- Add typed auth states: signedOut, verificationPending, authenticated, expired, and error.
- Add API contract tests and loading/error/timeout states.
- Do not label a mock/local-only flow as secure registration.

### Phase C — backend integration
- Implement provider verification and server-side authorization in a non-production environment first.
- Add per-user data isolation and negative tests (user A cannot read/write user B data).
- Test OTP abuse, replay, expired tokens, revoked sessions, duplicate linking, and account recovery.
- Production deployment requires explicit approval.

### Phase D — free public testing
- Keep core product features free for verified accounts during the initial launch.
- Add in-app feedback and bug reporting; communicate usage protections transparently.
- Monitor latency, crash rate, error rate, cost, abuse, and security events.

### Phase E — quality gate and gradual paid services
- Resolve critical/high-severity security defects and data-loss bugs.
- Validate load, backup/restore, account isolation, and recovery.
- Introduce paid advanced features only after a documented readiness review; preserve a useful free tier as a goal.

## Acceptance checklist
- [ ] No Guest/anonymous path into the platform.
- [ ] Signup cannot succeed before verification.
- [ ] Mobile, email, and Google identities can link to one account safely.
- [ ] Duplicate identities cannot create accidental duplicate accounts.
- [ ] Server rejects missing, invalid, expired, wrong-audience, or revoked tokens.
- [ ] Cross-account data access tests all fail closed.
- [ ] OTP and auth endpoints are throttled and replay-safe.
- [ ] Secrets are absent from APK and repository history.
- [ ] Session logout/revocation works across devices according to policy.
- [ ] Recovery, privacy, deletion/export, and feedback flows are documented.
- [ ] Free launch usage/cost protections are measured and transparent.

## Non-goals / honest claims
- No promise of "unhackable", "100% secure", or "bug-free".
- No mock authentication presented as production authentication.
- No production Cloudflare deployment without explicit approval.
- No fixed numeric free quotas or paid pricing until capacity/cost measurements and user approval.
