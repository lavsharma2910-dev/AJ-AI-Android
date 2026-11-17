# Update 31 — AJ AI Chat Actions

Status: implementation branch created; feature implementation and verification are pending.

## Scope (only these six chat actions)

1. **New Chat** — start a fresh conversation without silently overwriting the saved conversation.
2. **Delete** — delete the selected conversation or selected message only after confirmation.
3. **Save** — persist the current conversation and allow saved conversations to be reopened.
4. **Share** — share the current conversation or selected messages through the Android share sheet.
5. **Select** — enter multi-select mode for messages; selected items can be copied, shared, or deleted.
6. **History** — show saved conversations and reopen one.

## Data and safety requirements

- Keep conversation data local to the device in this update.
- Use stable conversation and message IDs; do not identify messages by list index.
- Persist changes before reporting success; restore the previous in-memory state if persistence fails.
- Confirm destructive delete operations.
- Keep New Chat separate from Delete: starting a new chat must preserve the previous saved conversation.
- Share only the content the user explicitly selected.
- Do not send chat contents to a third-party service for save/history/share.
- Preserve existing chat API request/response behavior and queue handling.
- No AI-provider, search-provider, Cloudflare Worker, or backend changes in Update 31.

## Verification required

- Flutter format/analyze/test and GitHub Actions APK build.
- Manual Android checks for all six actions.
- Persistence/restart checks for saved conversations and history.
- Multi-select checks for selection, deselection, and bulk actions.
- Share-sheet launch and payload checks.
- Delete confirmation and rollback-on-storage-failure checks.

## Change control

- Separate branch: `feature/update-31-chat-actions`
- Base branch: `main`
- Update 30 PR #2 remains untouched and draft.
- Do not merge this PR or deploy Cloudflare Worker without explicit approval.
