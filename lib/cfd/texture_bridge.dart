import 'dart:ui' as ui;
import 'dart:typed_data';

/// Bridges the raw Float32List data from the CFD solver to Flutter [ui.Image] textures.
class TextureBridge {
  /// Converts velocity grid data (u, v) into an RGBA image.
  /// R = u (normalized), G = v (normalized), B = 0, A = 255.
  static Future<ui.Image> createVelocityTexture(int width, int height, Float32List u, Float32List v) async {
    final Uint8List pixels = Uint8List(width * height * 4);
    
    for (int i = 0; i < width * height; i++) {
      // Map -1.0..1.0 to 0..255
      pixels[i * 4 + 0] = ((u[i] + 1.0) * 127.5).clamp(0, 255).toInt();
      pixels[i * 4 + 1] = ((v[i] + 1.0) * 127.5).clamp(0, 255).toInt();
      pixels[i * 4 + 2] = 0;
      pixels[i * 4 + 3] = 255;
    }

    final ui.ImmutableBuffer buffer = await ui.ImmutableBuffer.fromUint8List(pixels);
    final ui.ImageDescriptor descriptor = ui.ImageDescriptor.raw(
      buffer,
      width: width,
      height: height,
      pixelFormat: ui.PixelFormat.rgba8888,
    );
    
    final ui.Codec codec = await descriptor.instantiateCodec();
    final ui.FrameInfo frame = await codec.getNextFrame();
    return frame.image;
  }

  /// Converts temperature grid data into a grayscale image (for heatmap input).
  static Future<ui.Image> createTemperatureTexture(int width, int height, Float32List temperature) async {
    final Uint8List pixels = Uint8List(width * height * 4);
    
    for (int i = 0; i < width * height; i++) {
      // Direct mapping of temperature (e.g. 15-30C) to 0-255
      pixels[i * 4 + 0] = (temperature[i] * 10).clamp(0, 255).toInt();
      pixels[i * 4 + 1] = 0;
      pixels[i * 4 + 2] = 0;
      pixels[i * 4 + 3] = 255;
    }

    final ui.ImmutableBuffer buffer = await ui.ImmutableBuffer.fromUint8List(pixels);
    final ui.ImageDescriptor descriptor = ui.ImageDescriptor.raw(
      buffer,
      width: width,
      height: height,
      pixelFormat: ui.PixelFormat.rgba8888,
    );
    
    final ui.Codec codec = await descriptor.instantiateCodec();
    final ui.FrameInfo frame = await codec.getNextFrame();
    return frame.image;
  }
}
