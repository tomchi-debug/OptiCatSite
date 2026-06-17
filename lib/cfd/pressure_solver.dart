import 'dart:typed_data';
import 'fluid_grid.dart';

/// Solves the pressure Poisson equation and projects the velocity field
/// to maintain incompressibility (divergence-free flow).
class PressureSolver {
  /// Solves the pressure Poisson equation using Jacobi iteration.
  /// [iterations] typically range from 20 to 80.
  static void solve(FluidGrid grid, int iterations) {
    _calculateDivergence(grid);
    _solvePressurePoisson(grid, iterations);
    _projectVelocity(grid);
  }

  /// Calculates the divergence of the current velocity field.
  static void _calculateDivergence(FluidGrid grid) {
    final double h = 1.0 / (grid.width > grid.height ? grid.width : grid.height);

    for (int y = 1; y < grid.height - 1; y++) {
      for (int x = 1; x < grid.width - 1; x++) {
        int idx = grid.getIndex(x, y);
        if (grid.boundaries[idx] == BoundaryType.wall) {
          grid.divergence[idx] = 0;
          continue;
        }

        // Standard central difference for divergence
        double uLeft = grid.u[grid.getIndex(x - 1, y)];
        double uRight = grid.u[grid.getIndex(x + 1, y)];
        double vTop = grid.v[grid.getIndex(x, y - 1)];
        double vBottom = grid.v[grid.getIndex(x, y + 1)];

        grid.divergence[idx] = -0.5 * h * (uRight - uLeft + vBottom - vTop);
        grid.pressure[idx] = 0; // Reset pressure for the next solve
      }
    }
  }

  /// Iteratively solves the Poisson equation: ∇²p = div(u)
  static void _solvePressurePoisson(FluidGrid grid, int iterations) {
    for (int k = 0; k < iterations; k++) {
      for (int y = 1; y < grid.height - 1; y++) {
        for (int x = 1; x < grid.width - 1; x++) {
          int idx = grid.getIndex(x, y);
          if (grid.boundaries[idx] == BoundaryType.wall) continue;

          double pLeft = grid.pressure[grid.getIndex(x - 1, y)];
          double pRight = grid.pressure[grid.getIndex(x + 1, y)];
          double pTop = grid.pressure[grid.getIndex(x, y - 1)];
          double pBottom = grid.pressure[grid.getIndex(x, y + 1)];

          // Jacobi iteration step
          grid.pressure[idx] = (grid.divergence[idx] + pLeft + pRight + pTop + pBottom) / 4.0;
        }
      }
      // Note: Real Stable Fluids often applies boundaries to pressure here
    }
  }

  /// Subtracts the pressure gradient from the velocity field: u = u - ∇p
  static void _projectVelocity(FluidGrid grid) {
    final double h = 1.0 / (grid.width > grid.height ? grid.width : grid.height);

    for (int y = 1; y < grid.height - 1; y++) {
      for (int x = 1; x < grid.width - 1; x++) {
        int idx = grid.getIndex(x, y);
        if (grid.boundaries[idx] == BoundaryType.wall) continue;

        double pLeft = grid.pressure[grid.getIndex(x - 1, y)];
        double pRight = grid.pressure[grid.getIndex(x + 1, y)];
        double pTop = grid.pressure[grid.getIndex(x, y - 1)];
        double pBottom = grid.pressure[grid.getIndex(x, y + 1)];

        grid.u[idx] -= 0.5 * (pRight - pLeft) / h;
        grid.v[idx] -= 0.5 * (pBottom - pTop) / h;
      }
    }
  }
}
