import 'dart:ui' as ui;
import 'package:flutter/material.dart';

enum CfdVisualizationMode { velocity, temperature, hidden }

/// A widget that renders CFD simulation results using fragment shaders.
class CfdOverlayWidget extends StatelessWidget {
  final ui.Image? texture;
  final ui.FragmentProgram? shaderProgram;
  final CfdVisualizationMode mode;
  final Size size;

  const CfdOverlayWidget({
    super.key,
    this.texture,
    this.shaderProgram,
    required this.mode,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    if (mode == CfdVisualizationMode.hidden || texture == null || shaderProgram == null) {
      return const SizedBox.shrink();
    }

    return CustomPaint(
      size: size,
      painter: _CfdShaderPainter(
        texture: texture!,
        shaderProgram: shaderProgram!,
      ),
    );
  }
}

class _CfdShaderPainter extends CustomPainter {
  final ui.Image texture;
  final ui.FragmentProgram shaderProgram;

  _CfdShaderPainter({required this.texture, required this.shaderProgram});

  @override
  void paint(Canvas canvas, Size size) {
    final ui.FragmentShader shader = shaderProgram.fragmentShader();
    
    // Set uniforms
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setImageSampler(0, texture);

    final Paint paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant _CfdShaderPainter oldDelegate) {
    return oldDelegate.texture != texture;
  }
}
