import 'dart:math' as math;
import 'acoustic_math_util.dart';

enum FanType { centrifugal, axial, mixedFlow }

/// Implements ASHRAE generic fan sound generation models.
class FanSoundModel {
  /// Base spectrum (Kw) for different fan types per ASHRAE.
  static const Map<FanType, List<double>> _baseSpectrums = {
    FanType.centrifugal: [40, 38, 35, 30, 25, 20, 15, 10],
    FanType.axial: [45, 45, 44, 43, 42, 41, 40, 38],
    FanType.mixedFlow: [42, 41, 40, 37, 34, 31, 28, 25],
  };

  /// Calculates the sound power level (Lw) spectrum for a fan.
  /// [flow] in m³/s, [pressure] in Pa.
  static AcousticSpectrum calculateLw({
    required FanType type,
    required double flow,
    required double pressure,
    double? bladePassageFrequency,
  }) {
    List<double> baseKw = _baseSpectrums[type]!;
    
    // ASHRAE Formula: Lw = Kw + 10*log10(Q) + 20*log10(P)
    // Note: Q is in m³/s, P is in Pa.
    double flowTerm = 10 * (math.log(math.max(flow, 0.001)) / math.ln10);
    double pressureTerm = 20 * (math.log(math.max(pressure, 1.0)) / math.ln10);
    
    List<double> results = List.filled(8, 0.0);
    for (int i = 0; i < 8; i++) {
      results[i] = baseKw[i] + flowTerm + pressureTerm;
    }

    // Add Blade Passage Frequency (BPF) peak (+5 dB in the relevant band)
    if (bladePassageFrequency != null) {
      int bandIdx = _getBandIndex(bladePassageFrequency);
      if (bandIdx >= 0) {
        results[bandIdx] += 5.0;
      }
    }

    return AcousticSpectrum(results);
  }

  static int _getBandIndex(double frequency) {
    if (frequency < 88) return 0;   // 63 Hz center
    if (frequency < 177) return 1;  // 125 Hz center
    if (frequency < 354) return 2;  // 250 Hz center
    if (frequency < 707) return 3;  // 500 Hz center
    if (frequency < 1414) return 4; // 1000 Hz center
    if (frequency < 2828) return 5; // 2000 Hz center
    if (frequency < 5657) return 6; // 4000 Hz center
    return 7;                       // 8000 Hz center
  }
}
