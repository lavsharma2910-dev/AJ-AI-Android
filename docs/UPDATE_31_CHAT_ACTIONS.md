# Update 31 — AJ AI Chat Actions

Status: feature implementation is present on the isolated Update 31 branch. Verification is still pending; this update is not ready to merge or distribute as an APK.

## Scope (only these six chat actions)

1. **New Chat** — start a fresh conversation without silently overwriting the previous conversation.
2. **Delete** — delete the current conversation or selected messages only after confirmation.
3. **Save** — persist the current conversation locally and allow it to be reopened.
4. **Share** — share the current conversation or selected messages through the Android share sheet.
5. **Select** — enter multi-select mode; selected messages can be copied, shared, or deleted.
6. **History** — list locally stored conversations and reopen one.

## Implementation present

- Chat action controls are present in the chat AppBar.
- Local conversation snapshots use SharedPreferences.
- History sheet and conversation restore flow are implemented.
- Multi-select UI and copy/share/delete actions are implemented.
- Android sharing uses `share_plus`.
- New Chat preserves the previous conversation snapshot before switching.
- Delete actions request confirmation.

## Known gaps to resolve before sign-off

- Message selection currently uses list indexes, not stable message IDs. Replace this before calling the feature complete.
- Verify rollback and consistency across all SharedPreferences writes, especially when one write succeeds and a later write fails.
- Verify restore/migration of existing v2 and legacy chat state, including pending queue behavior.
- Review current-conversation deletion semantics and ensure the active-chat state cannot accidentally recreate a deleted snapshot.
- Add focused automated tests for persistence, migration, history restore, selection, and delete rollback.

## Verification required

- Run Dart formatting, Flutter analyze, and Flutter tests.
- Run GitHub Actions Android APK build and inspect the complete job logs.
- Install the generated APK on Android and manually test all six actions.
- Restart the app and verify persistence/history.
- Verify share-sheet payloads and destructive confirmation flows.
- Confirm pending queue and existing chat API behavior remain unchanged.

## Change control

- Branch: `feature/update-31-chat-actions`
- Base branch: `main`
- Draft PR #3: https://github.com/lavsharma2910-dev/AJ-AI-Android/pull/3
- Update 30 PR #2 remains untouched and draft.
- No merge or Cloudflare Worker deployment without explicit approval.
- Do not describe the APK as ready until a successful artifact is available and its Android install/behavior checks pass.
