import 'dart:math';

const Set<String> pendingChatStatuses = {
  'pending',
  'processing',
  'failed',
};

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

  PendingChatMessage copyWith({
    String? id,
    String? text,
    DateTime? createdAt,
    int? retryCount,
    String? status,
  }) {
    final nextStatus = status ?? this.status;
    final nextRetryCount = retryCount ?? this.retryCount;
    return PendingChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      retryCount: nextRetryCount < 0 ? 0 : nextRetryCount,
      status: pendingChatStatuses.contains(nextStatus)
          ? nextStatus
          : 'pending',
    );
  }

  factory PendingChatMessage.fromJson(dynamic value) {
    if (value is String) {
      final text = value.trim();
      if (text.isEmpty) {
        throw const FormatException('Invalid queued message text');
      }
      return PendingChatMessage(
        id: createRequestId(),
        text: text,
        createdAt: DateTime.now().toUtc(),
      );
    }

    if (value is Map) {
      final rawText = value['text'];
      if (rawText is! String || rawText.trim().isEmpty) {
        throw const FormatException('Invalid queued message text');
      }

      final rawId = value['id'];
      final id = rawId is String && rawId.trim().isNotEmpty
          ? rawId.trim()
          : createRequestId();

      final rawDate = value['createdAt'];
      final parsedDate =
          rawDate is String ? DateTime.tryParse(rawDate) : null;

      final rawRetryCount = value['retryCount'];
      final retryCount =
          rawRetryCount is int && rawRetryCount >= 0
              ? rawRetryCount
              : 0;

      final rawStatus = value['status'];
      final status = rawStatus is String &&
              pendingChatStatuses.contains(rawStatus)
          ? rawStatus
          : 'pending';

      return PendingChatMessage(
        id: id,
        text: rawText,
        createdAt: parsedDate?.toUtc() ?? DateTime.now().toUtc(),
        retryCount: retryCount,
        status: status,
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
