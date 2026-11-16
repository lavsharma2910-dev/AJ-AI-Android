import 'dart:math';

String createRequestId() {
  final random = Random.secure();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  return bytes
      .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
      .join();
}

class PendingChatMessage {
  final String id;
  final String text;
  final DateTime createdAt;
  final int retryCount;
  final String status;

  const PendingChatMessage({
    required this.id,
    required this.text,
    required this.createdAt,
    this.retryCount = 0,
    this.status = 'pending',
  });

  factory PendingChatMessage.fromJson(dynamic value) {
    if (value is String) {
      return PendingChatMessage(
        id: createRequestId(),
        text: value,
        createdAt: DateTime.now().toUtc(),
      );
    }

    if (value is Map) {
      final text = value['text'];
      if (text is! String || text.trim().isEmpty) {
        throw const FormatException('Invalid queued message text');
      }

      final rawDate = value['createdAt'];
      final parsedDate = rawDate is String
          ? DateTime.tryParse(rawDate)
          : null;

      return PendingChatMessage(
        id: value['id'] is String && (value['id'] as String).isNotEmpty
            ? value['id'] as String
            : createRequestId(),
        text: text,
        createdAt: parsedDate ?? DateTime.now().toUtc(),
        retryCount: value['retryCount'] is int
            ? value['retryCount'] as int
            : 0,
        status: 'pending',
      );
    }

    throw const FormatException('Invalid queued message');
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'createdAt': createdAt.toUtc().toIso8601String(),
        'retryCount': retryCount,
        'status': status,
      };
}
