import 'package:flutter_test/flutter_test.dart';
import 'package:aj_ai/chat_context.dart';
import 'package:aj_ai/pending_chat_message.dart';

void main() {
  group('buildReliableChatContext', () {
    test('excludes pending messages by request ID, not matching text', () {
      final messages = <Map<String, String>>[
        {'type': 'user', 'text': 'same question', 'requestId': 'done-1'},
        {'type': 'aj', 'text': 'completed answer', 'requestId': 'done-1'},
        {'type': 'user', 'text': 'same question', 'requestId': 'pending-2'},
      ];
      final queue = [
        PendingChatMessage(
          id: 'pending-2',
          text: 'same question',
          createdAt: DateTime.utc(2026, 11, 26),
        ),
      ];

      expect(
        buildReliableChatContext(messages: messages, pendingQueue: queue),
        [
          {'role': 'user', 'text': 'same question'},
          {'role': 'model', 'text': 'completed answer'},
        ],
      );
    });

    test('preserves legacy pending-message text fallback', () {
      final messages = <Map<String, String>>[
        {'type': 'user', 'text': 'old queued message'},
        {'type': 'user', 'text': 'completed legacy message'},
        {'type': 'aj', 'text': 'legacy answer'},
      ];
      final queue = [
        PendingChatMessage(
          id: 'legacy-queue-id',
          text: 'old queued message',
          createdAt: DateTime.utc(2026, 11, 26),
        ),
      ];

      expect(
        buildReliableChatContext(messages: messages, pendingQueue: queue),
        [
          {'role': 'user', 'text': 'completed legacy message'},
          {'role': 'model', 'text': 'legacy answer'},
        ],
      );
    });

    test('limits context to twelve entries and starts with a user turn', () {
      final messages = <Map<String, String>>[
        {'type': 'aj', 'text': 'orphan opening answer'},
        for (var i = 0; i < 7; i++) ...[
          {'type': 'user', 'text': 'question $i', 'requestId': 'q$i'},
          {'type': 'aj', 'text': 'answer $i', 'requestId': 'q$i'},
        ],
      ];

      final result = buildReliableChatContext(
        messages: messages,
        pendingQueue: const [],
      );

      expect(result, hasLength(12));
      expect(result.first['role'], 'user');
      expect(result.last['role'], 'model');
    });

    test('filters queue persistence failure notices from model context', () {
      final messages = <Map<String, String>>[
        {'type': 'user', 'text': 'hello', 'requestId': 'hello-1'},
        {'type': 'aj', 'text': 'Queue सेव नहीं हो पाई।'},
        {'type': 'aj', 'text': 'valid answer'},
      ];

      expect(
        buildReliableChatContext(
          messages: messages,
          pendingQueue: const [],
        ),
        [
          {'role': 'user', 'text': 'hello'},
          {'role': 'model', 'text': 'valid answer'},
        ],
      );
    });

    test('filters welcome and failed-send notices from model context', () {
      final messages = <Map<String, String>>[
        {'type': 'aj', 'text': 'नमस्ते! मैं AJ हूँ।'},
        {'type': 'user', 'text': 'hello', 'requestId': 'hello-1'},
        {'type': 'aj', 'text': 'संदेश भेजा नहीं जा सका। Queue में सुरक्षित है।'},
        {'type': 'aj', 'text': 'real answer'},
      ];

      expect(
        buildReliableChatContext(
          messages: messages,
          pendingQueue: const [],
        ),
        [
          {'role': 'user', 'text': 'hello'},
          {'role': 'model', 'text': 'real answer'},
        ],
      );
    });
  });

  group('insertAssistantReply', () {
    test('inserts each reply immediately after its matching user message', () {
      final messages = <Map<String, String>>[
        {'type': 'user', 'text': 'first', 'requestId': 'r1'},
        {'type': 'user', 'text': 'second', 'requestId': 'r2'},
      ];

      expect(
        insertAssistantReply(messages, requestId: 'r1', text: 'answer 1'),
        isTrue,
      );
      expect(
        insertAssistantReply(messages, requestId: 'r2', text: 'answer 2'),
        isTrue,
      );
      expect(
        messages.map((item) => item['text']).toList(),
        ['first', 'answer 1', 'second', 'answer 2'],
      );
    });

    test('does not add a duplicate reply for the same request ID', () {
      final messages = <Map<String, String>>[
        {'type': 'user', 'text': 'question', 'requestId': 'r1'},
      ];

      expect(
        insertAssistantReply(messages, requestId: 'r1', text: 'answer'),
        isTrue,
      );
      expect(
        insertAssistantReply(messages, requestId: 'r1', text: 'duplicate'),
        isFalse,
      );
      expect(messages, hasLength(2));
      expect(messages.last['text'], 'answer');
    });

    test('appends for legacy user messages without request IDs', () {
      final messages = <Map<String, String>>[
        {'type': 'user', 'text': 'old question'},
      ];

      expect(
        insertAssistantReply(messages, requestId: 'old-r', text: 'answer'),
        isTrue,
      );
      expect(messages.last['text'], 'answer');
    });

    test('rejects empty IDs and empty replies', () {
      final messages = <Map<String, String>>[];
      expect(
        insertAssistantReply(messages, requestId: '', text: 'answer'),
        isFalse,
      );
      expect(
        insertAssistantReply(messages, requestId: 'r1', text: '  '),
        isFalse,
      );
      expect(messages, isEmpty);
    });
  });
}
