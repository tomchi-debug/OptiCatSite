import 'dart:math' as math;

/// Represents sound levels in 8 octave bands (63 Hz to 8000 Hz).
class AcousticSpectrum {
  final List<double> bands;

  AcousticSpectrum(List<double> values)
      : assert(values.length == 8),
        bands = List.unmodifiable(values);

  factory AcousticSpectrum.empty() => AcousticSpectrum(List.filled(8, 0.0));

  /// Logarithmically adds another spectrum to this one.
  AcousticSpectrum operator +(AcousticSpectrum other) {
    List<double> result = List.filled(8, 0.0);
    for (int i = 0; i < 8; i++) {
      result[i] = AcousticMathUtil.logAdd(bands[i], other.bands[i]);
    }
    return AcousticSpectrum(result);
  }

  /// Subtracts (attenuates) decibels from each band.
  AcousticSpectrum operator -(AcousticSpectrum other) {
    List<double> result = List.filled(8, 0.0);
    for (int i = 0; i < 8; i++) {
      result[i] = bands[i] - other.bands[i];
    }
    return AcousticSpectrum(result);
  }

  @override
  String toString() => bands.map((e) => e.toStringAsFixed(1)).join(' | ');
}

class AcousticMathUtil {
  /// Standard A-weighting values for octave bands (63, 125, 250, 500, 1k, 2k, 4k, 8k Hz).
  static const List<double> aWeightingOffsets = [
    -26.2, // 63 Hz
    -16.1, // 125 Hz
    -8.6,  // 250 Hz
    -3.2,  // 500 Hz
     0.0,  // 1000 Hz
     1.2,  // 2000 Hz
     1.0,  // 4000 Hz
    -1.1   // 8000 Hz
  ];

  /// Logarithmically adds two decibel values: L = 10 * log10(10^(L1/10) + 10^(L2/10))
  static double logAdd(double l1, double l2) {
    if (l1 <= 0 && l2 <= 0) return 0;
    if (l1 <= 0) return l2;
    if (l2 <= 0) return l1;
    
    double max = math.max(l1, l2);
    double min = math.min(l1, l2);
    
    // Optimized formula: L_total = L_max + 10 * log10(1 + 10^((L_min - L_max)/10))
    return max + 10 * (math.log(1 + math.pow(10, (min - max) / 10)) / math.ln10);
  }

  /// Calculates total A-weighted decibels (LwA) from a spectrum.
  static double calculateLwA(AcousticSpectrum spectrum) {
    double sum = 0;
    for (int i = 0; i < 8; i++) {
      double weighted = spectrum.bands[i] + aWeightingOffsets[i];
      sum += math.pow(10, weighted / 10);
    }
    return 10 * (math.log(sum) / math.ln10);
  }
}
