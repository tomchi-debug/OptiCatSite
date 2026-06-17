import 'fluid_grid.dart';

/// Enforces boundary conditions on the fluid grid.
class Boundary {
  /// Applies boundary conditions to the velocity and temperature fields.
  static void apply(FluidGrid grid) {
    // 1. Enforce grid edges (Fixed walls by default)
    for (int x = 0; x < grid.width; x++) {
      _setWall(grid, x, 0);
      _setWall(grid, x, grid.height - 1);
    }
    for (int y = 0; y < grid.height; y++) {
      _setWall(grid, 0, y);
      _setWall(grid, grid.width - 1, y);
    }

    // 2. Enforce internal boundaries
    for (int i = 0; i < grid.size; i++) {
      int type = grid.boundaries[i];
      if (type == BoundaryType.wall) {
        grid.u[i] = 0;
        grid.v[i] = 0;
      }
      // Inlets and Outlets are typically handled during injection/projection
      // but we ensure they don't have weird pressure values if needed.
    }
  }

  /// Sets a specific cell as a wall boundary (velocity = 0)
  static void _setWall(FluidGrid grid, int x, int y) {
    int idx = grid.getIndex(x, y);
    grid.u[idx] = 0;
    grid.v[idx] = 0;
  }

  /// Specialized boundary handling for pressure to ensure Neumann conditions (zero gradient at walls)
  static void applyPressure(FluidGrid grid) {
    for (int x = 1; x < grid.width - 1; x++) {
      grid.pressure[grid.getIndex(x, 0)] = grid.pressure[grid.getIndex(x, 1)];
      grid.pressure[grid.getIndex(x, grid.height - 1)] = grid.pressure[grid.getIndex(x, grid.height - 2)];
    }
    for (int y = 1; y < grid.height - 1; y++) {
      grid.pressure[grid.getIndex(0, y)] = grid.pressure[grid.getIndex(1, y)];
      grid.pressure[grid.getIndex(grid.width - 1, y)] = grid.pressure[grid.getIndex(grid.width - 2, y)];
    }
  }
}
