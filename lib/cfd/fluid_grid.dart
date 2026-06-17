import 'dart:typed_data';

/// Boundary types for the CFD grid
class BoundaryType {
  static const int fluid = 0;
  static const int wall = 1;
  static const int inlet = 2;
  static const int outlet = 3;
}

/// Core data structure for the CFD simulation grid.
/// Uses [Float32List] for high-performance memory layout.
class FluidGrid {
  final int width;
  final int height;
  final int size;

  // Velocity fields (Staggered or Collocated? Plan says collocated Jacobi)
  // u = horizontal velocity, v = vertical velocity
  Float32List u;
  Float32List v;
  Float32List uOld;
  Float32List vOld;

  // Scalar fields
  Float32List pressure;
  Float32List temperature;
  Float32List temperatureOld;
  Float32List divergence;

  // Boundary flags: See [BoundaryType]
  final Uint8List boundaries;

  FluidGrid(this.width, this.height)
      : size = width * height,
        u = Float32List(width * height),
        v = Float32List(width * height),
        uOld = Float32List(width * height),
        vOld = Float32List(width * height),
        pressure = Float32List(width * height),
        temperature = Float32List(width * height),
        temperatureOld = Float32List(width * height),
        divergence = Float32List(width * height),
        boundaries = Uint8List(width * height);

  /// Converts 2D coordinates to a 1D index
  int getIndex(int x, int y) {
    // Clamp to ensure we stay within bounds during interpolation
    if (x < 0) x = 0;
    if (x >= width) x = width - 1;
    if (y < 0) y = 0;
    if (y >= height) y = height - 1;
    return y * width + x;
  }

  /// Swaps current velocity buffers with old buffers
  void swapVelocity() {
    var tmp = u;
    u = uOld;
    uOld = tmp;

    tmp = v;
    v = vOld;
    vOld = tmp;
  }

  /// Swaps current temperature buffers with old buffers
  void swapTemperature() {
    var tmp = temperature;
    temperature = temperatureOld;
    temperatureOld = tmp;
  }

  /// Resets all fields except boundaries
  void clear() {
    u.fillRange(0, size, 0);
    v.fillRange(0, size, 0);
    uOld.fillRange(0, size, 0);
    vOld.fillRange(0, size, 0);
    pressure.fillRange(0, size, 0);
    temperature.fillRange(0, size, 0);
    temperatureOld.fillRange(0, size, 0);
    divergence.fillRange(0, size, 0);
  }
}
