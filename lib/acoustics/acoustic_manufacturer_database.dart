import 'acoustic_math_util.dart';

/// Database of terminal unit (don) sound power levels (Lw) per octave band.
class AcousticManufacturerDatabase {
  /// Mock data for FläktGroup CTVB series (100, 125, 160 mm).
  /// Key: <model>-<size>-<flow_ls>
  static const Map<String, List<double>> _db = {
    'CTVB-100-20': [45, 42, 40, 35, 30, 25, 20, 15],
    'CTVB-100-40': [52, 48, 46, 42, 38, 33, 28, 22],
    'CTVB-125-30': [47, 44, 42, 37, 32, 27, 22, 17],
    'CTVB-125-60': [55, 51, 49, 45, 41, 36, 31, 25],
    'CTVB-160-50': [49, 46, 44, 39, 34, 29, 24, 19],
    'CTVB-160-100': [58, 54, 52, 48, 44, 39, 34, 28],
  };

  /// Looks up manufacturer data for a specific terminal unit.
  /// Performs logarithmic interpolation for flow if needed.
  static AcousticSpectrum? getSoundData(String model, int size, double flow) {
    // 1. Find standard flow points in DB
    String prefix = '$model-$size-';
    List<int> availableFlows = _db.keys
        .where((k) => k.startsWith(prefix))
        .map((k) => int.parse(k.split('-').last))
        .toList()
      ..sort();

    if (availableFlows.isEmpty) return null;

    // 2. Direct match
    if (availableFlows.contains(flow.toInt())) {
      return AcousticSpectrum(_db['$prefix${flow.toInt()}']!);
    }

    // 3. Find neighbors for interpolation
    if (flow < availableFlows.first) return AcousticSpectrum(_db['$prefix${availableFlows.first}']!);
    if (flow > availableFlows.last) return AcousticSpectrum(_db['$prefix${availableFlows.last}']!);

    int f0 = availableFlows.lastWhere((f) => f < flow);
    int f1 = availableFlows.firstWhere((f) => f > flow);

    List<double> lw0 = _db['$prefix$f0']!;
    List<double> lw1 = _db['$prefix$f1']!;

    // Logarithmic interpolation: L = L0 + (L1 - L0) * (log(Q/Q0) / log(Q1/Q0))
    double ratio = (math.log(flow / f0) / math.ln10) / (math.log(f1.toDouble() / f0) / math.ln10);
    
    List<double> results = List.filled(8, 0.0);
    for (int i = 0; i < 8; i++) {
      results[i] = lw0[i] + (lw1[i] - lw0[i]) * ratio;
    }

    return AcousticSpectrum(results);
  }
}
import 'dart:math' as math;
