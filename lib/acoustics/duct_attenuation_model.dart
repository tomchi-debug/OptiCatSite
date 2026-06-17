import 'dart:math' as math;
import 'acoustic_math_util.dart';

/// Implements VDI 2081 / ASHRAE duct attenuation and branch loss models.
class DuctAttenuationModel {
  /// Calculates natural attenuation for a straight duct.
  /// [diameter] in mm, [length] in meters.
  static AcousticSpectrum getStraightDuctAttenuation(double diameter, double length) {
    List<double> dbPerMeter;
    
    if (diameter < 200) {
      dbPerMeter = [0.10, 0.08, 0.05, 0.03, 0.02, 0.02, 0.01, 0.01];
    } else if (diameter <= 400) {
      dbPerMeter = [0.06, 0.05, 0.04, 0.02, 0.01, 0.01, 0.01, 0.01];
    } else if (diameter <= 800) {
      dbPerMeter = [0.04, 0.03, 0.02, 0.01, 0.01, 0.01, 0.01, 0.01];
    } else {
      dbPerMeter = [0.02, 0.02, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01];
    }

    return AcousticSpectrum(dbPerMeter.map((db) => db * length).toList());
  }

  /// Calculates attenuation for a 90-degree elbow (unlined).
  /// [diameter] in mm.
  static AcousticSpectrum getElbowAttenuation(double diameter) {
    // Simplified VDI 2081 elbow attenuation
    if (diameter < 250) {
      return AcousticSpectrum([0, 0, 1, 2, 3, 3, 3, 3]);
    } else if (diameter < 500) {
      return AcousticSpectrum([0, 1, 2, 3, 3, 3, 3, 3]);
    } else {
      return AcousticSpectrum([1, 2, 3, 3, 3, 3, 3, 3]);
    }
  }

  /// Calculates branch loss (energy division) at a T-junction.
  /// [areaBranch] and [areaTotal] in any consistent unit (e.g., m²).
  static double calculateBranchLoss(double areaBranch, double areaTotal) {
    if (areaBranch >= areaTotal) return 0;
    if (areaBranch <= 0) return 99; // Total loss
    
    // Loss = -10 * log10(A_branch / A_total)
    return -10 * (math.log(areaBranch / areaTotal) / math.ln10);
  }
}
