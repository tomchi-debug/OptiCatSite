import 'acoustic_math_util.dart';
import 'fan_sound_model.dart';
import 'duct_attenuation_model.dart';
import 'terminal_sound_model.dart';

/// Prototype for an acoustic network solver.
/// Orchestrates the calculation of sound levels from source to terminal.
class AcousticNetworkSolver {
  /// Simple linear path solver example.
  static AcousticSpectrum solveLinearPath({
    required FanType fanType,
    required double flow,
    required double pressure,
    required List<double> ductLengths,
    required double ductDiameter,
    int numberOfElbows = 0,
  }) {
    // 1. Generate Source Noise
    AcousticSpectrum currentLw = FanSoundModel.calculateLw(
      type: fanType,
      flow: flow,
      pressure: pressure,
    );

    // 2. Apply Duct Attenuation
    for (double length in ductLengths) {
      AcousticSpectrum attenuation = DuctAttenuationModel.getStraightDuctAttenuation(ductDiameter, length);
      currentLw = currentLw - attenuation;
    }

    // 3. Apply Elbow Attenuation
    if (numberOfElbows > 0) {
      AcousticSpectrum elbowAtten = DuctAttenuationModel.getElbowAttenuation(ductDiameter);
      for (int i = 0; i < numberOfElbows; i++) {
        currentLw = currentLw - elbowAtten;
      }
    }

    // 4. Apply End Reflection Loss (Terminal)
    AcousticSpectrum erl = TerminalSoundModel.calculateEndReflectionLoss(ductDiameter);
    currentLw = currentLw - erl;

    return currentLw;
  }
}
