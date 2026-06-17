import 'dart:math' as math;
import 'acoustic_math_util.dart';

/// Implements terminal unit acoustic models including end reflection
/// and room sound pressure conversion.
class TerminalSoundModel {
  static const double speedOfSound = 343.0; // m/s
  static const List<double> frequencies = [63, 125, 250, 500, 1000, 2000, 4000, 8000];

  /// Calculates End Reflection Loss (L_er) for a duct terminating in a room.
  /// [diameter] in mm.
  static AcousticSpectrum calculateEndReflectionLoss(double diameter) {
    double d = diameter / 1000.0; // Convert to meters
    List<double> results = List.filled(8, 0.0);

    for (int i = 0; i < 8; i++) {
      double f = frequencies[i];
      // Formula: L_er = 10 * log10(1 + (c / (pi * f * d))^2)
      double term = speedOfSound / (math.pi * f * d);
      results[i] = 10 * (math.log(1 + term * term) / math.ln10);
    }
    
    return AcousticSpectrum(results);
  }

  /// Converts Sound Power (Lw) in the room to Sound Pressure (Lp) at a distance.
  /// [volume] in m³, [reverberationTime] in seconds, [distance] in meters.
  /// [directivityFactor] (Q): 1 = spherical, 2 = hemispherical (floor), 4 = corner.
  static double calculateLp(double lw, {
    required double distance,
    double volume = 100,
    double reverberationTime = 0.5,
    int directivityFactor = 2,
  }) {
    // Room Constant R = (0.161 * V) / T
    double r = (0.161 * volume) / reverberationTime;
    
    // Lp = Lw + 10 * log10(Q / (4 * pi * r^2) + 4 / R)
    double term1 = directivityFactor / (4 * math.pi * distance * distance);
    double term2 = 4 / r;
    
    return lw + 10 * (math.log(term1 + term2) / math.ln10);
  }
}
