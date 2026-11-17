import 'package:flutter_test/flutter_test.dart';
import 'package:aj_ai/pending_chat_message.dart';

void main() {
  group('createRequestId', () {
    test('generates a 32-character hexadecimal ID', () {
      final id = createRequestId();

      expect(id, hasLength(32));
      expect(id, matches(RegExp(r'^[0-9a-f]{32}$')));
    });

    test('generates unique IDs', () {
      final ids = List.generate(100, (_) => createRequestId());

      expect(ids.toSet(), hasLength(100));
    });
  });

  group('PendingChatMessage', () {
    test('restores a legacy string queue item', () {
      final message = PendingChatMessage.fromJson('Hello AJ');

      expect(message.text, 'Hello AJ');
      expect(message.id, matches(RegExp(r'^[0-9a-f]{32}$')));
      expect(message.status, 'pending');
    });

    test('serializes and restores a message', () {
      final original = PendingChatMessage(
        id: 'request-123',
        text: 'Test message',
        createdAt: DateTime.utc(2026, 11, 16, 10),
        retryCount: 2,
      );

      final restored = PendingChatMessage.fromJson(original.toJson());

      expect(restored.id, original.id);
      expect(restored.text, original.text);
      expect(restored.createdAt, original.createdAt);
      expect(restored.retryCount, 2);
      expect(restored.status, 'pending');
    });

    test('restores processing and failed statuses', () {
      final processing = PendingChatMessage.fromJson({
        'id': 'request-processing',
        'text': 'Processing',
        'createdAt': '2026-11-16T10:00:00Z',
        'retryCount': 2,
        'status': 'processing',
      });
      final failed = PendingChatMessage.fromJson({
        'id': 'request-failed',
        'text': 'Failed',
        'createdAt': '2026-11-16T10:00:00Z',
        'retryCount': 3,
        'status': 'failed',
      });

      expect(processing.status, 'processing');
      expect(processing.retryCount, 2);
      expect(failed.status, 'failed');
      expect(failed.retryCount, 3);
    });

    test('normalizes unknown status and negative retry count', () {
      final message = PendingChatMessage.fromJson({
        'id': 'request-invalid-state',
        'text': 'State test',
        'retryCount': -4,
        'status': 'unknown',
      });

      expect(message.status, 'pending');
      expect(message.retryCount, 0);
    });

    test('copyWith updates retry state without changing identity', () {
      final original = PendingChatMessage(
        id: 'stable-request',
        text: 'Retry me',
        createdAt: DateTime.utc(2026, 11, 16),
      );

      final retried = original.copyWith(
        status: 'processing',
        retryCount: 1,
      );

      expect(retried.id, original.id);
      expect(retried.text, original.text);
      expect(retried.status, 'processing');
      expect(retried.retryCount, 1);
    });

    test('rejects empty message text', () {
      expect(
        () => PendingChatMessage.fromJson({'text': '   '}),
        throwsFormatException,
      );
    });

    test('rejects unsupported queue data', () {
      expect(
        () => PendingChatMessage.fromJson(123),
        throwsFormatException,
      );
    });

    test('uses current UTC time for an invalid date', () {
      final before = DateTime.now().toUtc();
      final message = PendingChatMessage.fromJson({
        'id': 'request-456',
        'text': 'Date test',
        'createdAt': 'not-a-date',
      });
      final after = DateTime.now().toUtc();

      expect(
        !message.createdAt.isBefore(before) &&
            !message.createdAt.isAfter(after),
        isTrue,
      );
    });
  });
}
