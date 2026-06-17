import 'dart:math' as math;
import 'fluid_grid.dart';

enum JetType { radial, slot, circular }

/// Implements Jet Injection for terminal units (don) into the CFD grid.
class JetInjection {
  /// Injects velocity and temperature into the grid at [x, y].
  /// [flow] in l/s, [temp] in Celsius, [velocity] in m/s (initial at neck).
  static void inject({
    required FluidGrid grid,
    required int x,
    required int y,
    required JetType type,
    required double flow, // l/s
    required double velocity, // m/s
    required double temperature, // Celsius
    double angleDegrees = 90.0, // Downward by default
  }) {
    int idx = grid.getIndex(x, y);
    if (grid.boundaries[idx] == BoundaryType.wall) return;

    final double angleRad = angleDegrees * math.pi / 180.0;
    
    // Calculate velocity components
    double u_inj = velocity * math.cos(angleRad);
    double v_inj = velocity * math.sin(angleRad);

    // Injection logic: For now, we inject into a single cell and its neighbors
    // to avoid point-source numerical instability.
    _applyInjection(grid, x, y, u_inj, v_inj, temperature);
    _applyInjection(grid, x - 1, y, u_inj * 0.5, v_inj * 0.5, temperature);
    _applyInjection(grid, x + 1, y, u_inj * 0.5, v_inj * 0.5, temperature);
    _applyInjection(grid, x, y + 1, u_inj * 0.5, v_inj * 0.5, temperature);
  }

  static void _applyInjection(FluidGrid grid, int x, int y, double u, double v, double t) {
    if (x < 0 || x >= grid.width || y < 0 || y >= grid.height) return;
    int idx = grid.getIndex(x, y);
    if (grid.boundaries[idx] == BoundaryType.wall) return;

    grid.u[idx] = u;
    grid.v[idx] = v;
    grid.temperature[idx] = t;
  }
}
