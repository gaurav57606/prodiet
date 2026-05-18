import 'dart:math';

/// Captures a user modification or spelling correction entry.
class OcrCorrection {
  final String original;
  final String corrected;
  final int count;

  const OcrCorrection({
    required this.original,
    required this.corrected,
    required this.count,
  });
}

/// Dynamic performance tracker of the OCR parser accuracy.
class OcrScanMetrics {
  final int totalScans;
  final int failedScans;
  final int manualModifications;
  final double averageConfidence;

  const OcrScanMetrics({
    required this.totalScans,
    required this.failedScans,
    required this.manualModifications,
    required this.averageConfidence,
  });

  /// Metric score from 0.0 to 1.0. High represents pure automated parsing.
  double get automationIndex {
    if (totalScans == 0) return 1.0;
    return (1.0 - (manualModifications / totalScans)).clamp(0.0, 1.0);
  }
}

/// Intelligent offline learning engine mapping raw scanned text anomalies to clean catalog names.
class OcrLearningSystem {
  final Map<String, String> _userCorrections = {};
  final Set<String> _frequentFoods = {};
  
  // OCR Correction metrics
  int _totalScans = 0;
  int _failedScans = 0;
  int _manualModifications = 0;
  double _cumulativeConfidence = 0.0;

  // Simple in-memory correction prediction cache
  final Map<String, String> _predictionCache = {};

  /// Retrieves a snapshot of the current OCR system efficiency metrics.
  OcrScanMetrics getMetrics() {
    return OcrScanMetrics(
      totalScans: _totalScans,
      failedScans: _failedScans,
      manualModifications: _manualModifications,
      averageConfidence: _totalScans > 0 ? (_cumulativeConfidence / _totalScans) : 1.0,
    );
  }

  /// Records a successful scan incident, incorporating its raw confidence score.
  void recordScanSuccess(double confidence) {
    _totalScans++;
    _cumulativeConfidence += confidence;
  }

  /// Records a failed scan event where OCR could not match any tokens.
  void recordScanFailure() {
    _totalScans++;
    _failedScans++;
  }

  /// Logs a user edit or spelling correction to learn anomalies over time.
  void learnCorrection(String rawText, String correctedText) {
    final raw = rawText.trim().toLowerCase();
    final corrected = correctedText.trim().toLowerCase();

    if (raw.isNotEmpty && corrected.isNotEmpty) {
      if (raw != corrected) {
        _userCorrections[raw] = correctedText; // Learn actual spelling mapping
        _manualModifications++;
        _predictionCache.clear(); // Flush cache to include new learned corrections
      }
      _frequentFoods.add(correctedText);
    }
  }

  /// Predicts the corrected food name based on learned corrections, frequency, or fuzzy dictionaries.
  String predictCorrection(String rawText) {
    final raw = rawText.trim().toLowerCase();
    if (raw.isEmpty) return '';

    // 1. Prediction cache check to bypass computation
    if (_predictionCache.containsKey(raw)) {
      return _predictionCache[raw]!;
    }

    // 2. Direct exact-match correction lookup
    if (_userCorrections.containsKey(raw)) {
      final prediction = _userCorrections[raw]!;
      _predictionCache[raw] = prediction;
      return prediction;
    }

    // 3. Levenshtein fuzzy distance matching against frequent items dictionary
    String bestMatch = rawText;
    int bestDistance = 3; // Maximum error threshold tolerance of 2 typos

    for (final food in _frequentFoods) {
      final distance = _calculateLevenshtein(raw, food.toLowerCase());
      if (distance < bestDistance) {
        bestDistance = distance;
        bestMatch = food;
      }
    }

    _predictionCache[raw] = bestMatch;
    return bestMatch;
  }

  /// Generates dynamic preprocessing parameters (brightness, threshold, crop)
  /// depending on historical OCR scan failure counts.
  Map<String, dynamic> getAdaptivePreprocessingConfig() {
    final metrics = getMetrics();
    
    // If OCR failure rate exceeds 25%, trigger heavier preprocessing filters
    final failureRate = metrics.totalScans > 0 ? (metrics.failedScans / metrics.totalScans) : 0.0;
    if (failureRate > 0.25) {
      return {
        'adaptive_thresholding': true,
        'denoise_strength': 2,
        'contrast_boost': 1.5,
        'grayscale_override': true,
      };
    }

    return {
      'adaptive_thresholding': false,
      'denoise_strength': 1,
      'contrast_boost': 1.0,
      'grayscale_override': false,
    };
  }

  /// Classical Levenshtein distance algorithm for offline spelling correction.
  int _calculateLevenshtein(String s, String t) {
    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;

    final v0 = List<int>.generate(t.length + 1, (i) => i);
    final v1 = List<int>.filled(t.length + 1, 0);

    for (int i = 0; i < s.length; i++) {
      v1[0] = i + 1;
      for (int j = 0; j < t.length; j++) {
        final cost = (s.codeUnitAt(i) == t.codeUnitAt(j)) ? 0 : 1;
        v1[j + 1] = _minimumOfThree(
          v1[j] + 1,
          v0[j + 1] + 1,
          v0[j] + cost,
        );
      }
      for (int j = 0; j < v0.length; j++) {
        v0[j] = v1[j];
      }
    }
    return v0[t.length];
  }

  int _minimumOfThree(int a, int b, int c) {
    return min(a, min(b, c));
  }

  /// Clear learned dictionaries and metrics (for compliance purges).
  void clearMemory() {
    _userCorrections.clear();
    _frequentFoods.clear();
    _predictionCache.clear();
    _totalScans = 0;
    _failedScans = 0;
    _manualModifications = 0;
    _cumulativeConfidence = 0.0;
  }
}
