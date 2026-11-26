import 'pending_chat_message.dart';

/// Builds model context from completed turns only.
///
/// New messages are matched by stable request ID. Legacy messages without an
/// ID retain the old text-count fallback so existing saved histories remain
/// readable without rewriting user data.
List<Map<String, String>> buildReliableChatContext({
  required List<Map<String, String>> messages,
  required Iterable<PendingChatMessage> pendingQueue,
}) {
  final pendingIds = <String>{};
  final legacyPendingCounts = <String, int>{};

  for (final queued in pendingQueue) {
    pendingIds.add(queued.id);
    final hasMatchingId = messages.any(
      (message) =>
          message['type'] == 'user' && message['requestId'] == queued.id,
    );
    if (!hasMatchingId) {
      legacyPendingCounts[queued.text] =
          (legacyPendingCounts[queued.text] ?? 0) + 1;
    }
  }

  final context = <Map<String, String>>[];
  for (final message in messages) {
    final type = message['type'];
    final value = (message['text'] ?? '').trim();
    if (value.isEmpty) continue;

    if (type == 'user') {
      final requestId = message['requestId'];
      if (requestId != null && pendingIds.contains(requestId)) {
        continue;
      }
      if (requestId == null) {
        final count = legacyPendingCounts[value] ?? 0;
        if (count > 0) {
          legacyPendingCounts[value] = count - 1;
          continue;
        }
      }
      context.add({'role': 'user', 'text': value});
    } else if (type == 'aj' &&
        !value.startsWith('नमस्ते!') &&
        !value.startsWith('संदेश भेजा नहीं जा सका।') &&
        !value.startsWith('Queue सेव नहीं हो पाई。') &&
        !(message['requestId'] != null &&
            pendingIds.contains(message['requestId']))) {
      context.add({'role': 'model', 'text': value});
    }
  }

  final recent = context.length <= 12
      ? List<Map<String, String>>.from(context)
      : context.sublist(context.length - 12);

  while (recent.isNotEmpty && recent.first['role'] == 'model') {
    recent.removeAt(0);
  }
  return recent;
}

/// Inserts a reply beside its originating user message exactly once.
bool insertAssistantReply(
  List<Map<String, String>> messages, {
  required String requestId,
  required String text,
}) {
  if (requestId.trim().isEmpty || text.trim().isEmpty) return false;

  final alreadyAnswered = messages.any(
    (item) => item['type'] == 'aj' && item['requestId'] == requestId,
  );
  if (alreadyAnswered) return false;

  final userIndex = messages.indexWhere(
    (item) => item['type'] == 'user' && item['requestId'] == requestId,
  );
  final reply = <String, String>{
    'type': 'aj',
    'text': text,
    'requestId': requestId,
  };

  if (userIndex < 0) {
    // Compatibility with saved messages created before request IDs existed.
    messages.add(reply);
  } else {
    messages.insert(userIndex + 1, reply);
  }
  return true;
}
