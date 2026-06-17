import 'fluid_grid.dart';

/// Implements thermal buoyancy using the Boussinesq approximation.
class Buoyancy {
  static const double g = 9.81; // Gravity m/s²
  static const double beta = 1.0 / 293.0; // Expansion coefficient for air at ~20°C
  static const double tRef = 20.0; // Reference temperature (neutral buoyancy)

  /// Applies buoyancy forces to the vertical velocity field (v).
  /// [dt] is the time step.
  static void apply(FluidGrid grid, double dt) {
    for (int i = 0; i < grid.size; i++) {
      if (grid.boundaries[i] == BoundaryType.wall) continue;

      double t = grid.temperature[i];
      // F_buoyancy = beta * (T - T_ref) * g
      // In our 2D grid, positive v is downward, so warm air (T > T_ref) 
      // should decrease v (move upward).
      double force = beta * (t - tRef) * g;
      
      grid.v[i] -= force * dt;
    }
  }
}
