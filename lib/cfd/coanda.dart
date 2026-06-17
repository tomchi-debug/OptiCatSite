import 'fluid_grid.dart';

/// Implements the Coanda effect: air "sticking" to walls.
class Coanda {
  /// Applies Coanda forces to bend airflow towards walls.
  /// [strength] is a multiplier for the effect (0.0 to 1.0).
  static void apply(FluidGrid grid, double strength) {
    if (strength <= 0) return;

    for (int y = 1; y < grid.height - 1; y++) {
      for (int x = 1; x < grid.width - 1; x++) {
        int idx = grid.getIndex(x, y);
        if (grid.boundaries[idx] == BoundaryType.wall) continue;

        // Check neighbors for walls
        _checkAndBend(grid, x, y, idx, strength);
      }
    }
  }

  static void _checkAndBend(FluidGrid grid, int x, int y, int idx, double strength) {
    // If there's a wall to the left or right, bias v (vertical)
    bool wallLeft = grid.boundaries[grid.getIndex(x - 1, y)] == BoundaryType.wall;
    bool wallRight = grid.boundaries[grid.getIndex(x + 1, y)] == BoundaryType.wall;
    
    // If there's a wall above or below, bias u (horizontal)
    bool wallTop = grid.boundaries[grid.getIndex(x, y - 1)] == BoundaryType.wall;
    bool wallBottom = grid.boundaries[grid.getIndex(x, y + 1)] == BoundaryType.wall;

    if (wallLeft || wallRight) {
      // Air flowing vertically near a vertical wall should stick
      // We reduce horizontal velocity components that push away from the wall
      if (wallLeft && grid.u[idx] < 0) grid.u[idx] *= (1.0 - strength);
      if (wallRight && grid.u[idx] > 0) grid.u[idx] *= (1.0 - strength);
    }

    if (wallTop || wallBottom) {
      // Air flowing horizontally near a horizontal wall should stick
      if (wallTop && grid.v[idx] < 0) grid.v[idx] *= (1.0 - strength);
      if (wallBottom && grid.v[idx] > 0) grid.v[idx] *= (1.0 - strength);
    }
  }
}
