import 'dart:math';

enum RetryStrategy { exponential, linear, immediate }

class RetryPolicy {
  final int maxRetries;
  final Duration initialDelay;
  final Duration maxDelay;
  final RetryStrategy strategy;

  const RetryPolicy({
    this.maxRetries = 5,
    this.initialDelay = const Duration(seconds: 2),
    this.maxDelay = const Duration(minutes: 30),
    this.strategy = RetryStrategy.exponential,
  });

  Duration getNextDelay(int retryCount) {
    if (retryCount >= maxRetries) return maxDelay;

    switch (strategy) {
      case RetryStrategy.exponential:
        final exponent = pow(2, retryCount).toDouble();
        final delayMs = initialDelay.inMilliseconds * exponent;
        // Add jitter (±10%) to prevent sync storms
        final jitter = (Random().nextDouble() * 0.2) - 0.1;
        final finalDelayMs = delayMs * (1 + jitter);
        final calculatedDelay = Duration(milliseconds: finalDelayMs.round());
        if (calculatedDelay < initialDelay) return initialDelay;
        if (calculatedDelay > maxDelay) return maxDelay;
        return calculatedDelay;
      
      case RetryStrategy.linear:
        final calculatedDelay = initialDelay * (retryCount + 1);
        if (calculatedDelay < initialDelay) return initialDelay;
        if (calculatedDelay > maxDelay) return maxDelay;
        return calculatedDelay;
      
      case RetryStrategy.immediate:
        return Duration.zero;
    }
  }

  bool shouldRetry(int retryCount) => retryCount < maxRetries;

  static const defaultPolicy = RetryPolicy();
  static const aggressivePolicy = RetryPolicy(maxRetries: 10, initialDelay: Duration(seconds: 1));
}
