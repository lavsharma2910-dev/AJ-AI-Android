enum ChatRequestOutcome { success, httpError, networkError, responseError }

class ChatRequestMetric {
  final Stopwatch _stopwatch = Stopwatch()..start();
  int? _statusCode;
  ChatRequestOutcome _outcome = ChatRequestOutcome.networkError;
  bool _finished = false;

  void stop() {
    if (_finished) return;
    _stopwatch.stop();
    _finished = true;
  }

  void responseReceived(int statusCode) {
    _statusCode = statusCode;
    _outcome = statusCode == 200
        ? ChatRequestOutcome.responseError
        : ChatRequestOutcome.httpError;
  }

  void markSuccess() {
    if (_statusCode == 200) {
      _outcome = ChatRequestOutcome.success;
    }
  }

  void markFailure() {
    if (_outcome == ChatRequestOutcome.success) return;
    if (_statusCode == null) {
      _outcome = ChatRequestOutcome.networkError;
    } else if (_statusCode != 200) {
      _outcome = ChatRequestOutcome.httpError;
    } else {
      _outcome = ChatRequestOutcome.responseError;
    }
  }

  String diagnosticLine() {
    stop();
    final status = _statusCode?.toString() ?? 'none';
    return 'AJ_AI_METRIC request_ms=${_stopwatch.elapsedMilliseconds} '
        'status=$status outcome=${_outcome.name}';
  }
}
