import 'package:flutter_test/flutter_test.dart';
import 'package:aj_ai/request_diagnostics.dart';

void main() {
  group('ChatRequestMetric', () {
    test('records successful HTTP request without content fields', () {
      final metric = ChatRequestMetric();
      metric.responseReceived(200);
      metric.markSuccess();

      final line = metric.diagnosticLine();

      expect(
        line,
        matches(
          RegExp(
            r'^AJ_AI_METRIC request_ms=\d+ status=200 outcome=success$',
          ),
        ),
      );
    });

    test('classifies non-200 response as HTTP error', () {
      final metric = ChatRequestMetric();
      metric.responseReceived(503);
      metric.markFailure();

      expect(
        metric.diagnosticLine(),
        matches(
          RegExp(
            r'^AJ_AI_METRIC request_ms=\d+ status=503 outcome=httpError$',
          ),
        ),
      );
    });

    test('classifies a failure before response as network error', () {
      final metric = ChatRequestMetric();
      metric.stop();
      metric.markFailure();

      expect(
        metric.diagnosticLine(),
        matches(
          RegExp(
            r'^AJ_AI_METRIC request_ms=\d+ status=none outcome=networkError$',
          ),
        ),
      );
    });

    test('classifies malformed or empty response after HTTP 200 as response error', () {
      final metric = ChatRequestMetric();
      metric.responseReceived(200);
      metric.markFailure();

      expect(
        metric.diagnosticLine(),
        matches(
          RegExp(
            r'^AJ_AI_METRIC request_ms=\d+ status=200 outcome=responseError$',
          ),
        ),
      );
    });

    test('finishing is idempotent', () {
      final metric = ChatRequestMetric();
      final first = metric.diagnosticLine();
      final second = metric.diagnosticLine();

      expect(second, first);
    });
  });
}
