import 'dart:typed_data';
import 'fluid_grid.dart';

/// Helper to convert high-level room geometry into grid boundary flags.
class RoomGeometry {
  /// Clears boundaries and sets walls based on a binary mask.
  static void applyWallMask(FluidGrid grid, Uint8List mask) {
    if (mask.length != grid.size) return;
    grid.boundaries.setAll(0, mask);
  }

  /// Creates a simple rectangular room boundary.
  static void setRectangularRoom(FluidGrid grid) {
    grid.boundaries.fillRange(0, grid.size, BoundaryType.fluid);
    
    for (int x = 0; x < grid.width; x++) {
      grid.boundaries[grid.getIndex(x, 0)] = BoundaryType.wall;
      grid.boundaries[grid.getIndex(x, grid.height - 1)] = BoundaryType.wall;
    }
    for (int y = 0; y < grid.height; y++) {
      grid.boundaries[grid.getIndex(0, y)] = BoundaryType.wall;
      grid.boundaries[grid.getIndex(grid.width - 1, y)] = BoundaryType.wall;
    }
  }
}
