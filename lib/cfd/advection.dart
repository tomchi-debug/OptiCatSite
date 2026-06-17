import 'dart:typed_data';
import 'fluid_grid.dart';

/// Implements Semi-Lagrangian advection for the fluid simulation.
class Advection {
  /// Advects a scalar or vector field [field] based on current velocity.
  /// [dt] is the time step.
  static void solve(FluidGrid grid, Float32List field, Float32List oldField, double dt) {
    final double dt0 = dt * (grid.width > grid.height ? grid.width : grid.height);

    for (int y = 0; y < grid.height; y++) {
      for (int x = 0; x < grid.width; x++) {
        int idx = grid.getIndex(x, y);
        if (grid.boundaries[idx] == BoundaryType.wall) continue;

        // Backtrack along the velocity vector
        double srcX = x - dt0 * grid.u[idx];
        double srcY = y - dt0 * grid.v[idx];

        // Clamp to grid bounds
        if (srcX < 0.5) srcX = 0.5;
        if (srcX > grid.width - 1.5) srcX = grid.width - 1.5;
        if (srcY < 0.5) srcY = 0.5;
        if (srcY > grid.height - 1.5) srcY = grid.height - 1.5;

        field[idx] = _bilinearInterpolate(grid, oldField, srcX, srcY);
      }
    }
  }

  /// Bilinear interpolation at coordinates (x, y) in the [field]
  static double _bilinearInterpolate(FluidGrid grid, Float32List field, double x, double y) {
    int i0 = x.floor();
    int i1 = i0 + 1;
    int j0 = y.floor();
    int j1 = j0 + 1;

    double s1 = x - i0;
    double s0 = 1.0 - s1;
    double t1 = y - j0;
    double t0 = 1.0 - t1;

    return s0 * (t0 * field[grid.getIndex(i0, j0)] + t1 * field[grid.getIndex(i0, j1)]) +
           s1 * (t0 * field[grid.getIndex(i1, j0)] + t1 * field[grid.getIndex(i1, j1)]);
  }
}
