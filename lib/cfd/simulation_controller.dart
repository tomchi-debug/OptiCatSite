import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'cfd_isolate.dart';
import 'texture_bridge.dart';

/// High-level controller to manage the CFD simulation state and communication.
class SimulationController {
  final int width;
  final int height;
  
  Isolate? _isolate;
  SendPort? _sendPort;
  ReceivePort? _receivePort;
  
  bool isRunning = false;
  
  // Latest results for visualization
  ui.Image? velocityTexture;
  ui.Image? temperatureTexture;

  SimulationController({this.width = 128, this.height = 128});

  /// Initializes the background isolate and simulation grid.
  Future<void> init(Uint8List? boundaries) async {
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(CfdIsolate.entryPoint, _receivePort!.sendPort);

    // Listen for messages from the isolate
    _receivePort!.listen((message) async {
      if (message is SendPort) {
        _sendPort = message;
        // Send initial config
        _sendPort!.send({
          'command': 'init',
          'width': width,
          'height': height,
          'boundaries': boundaries,
        });
      } else if (message is Map && message['type'] == 'result') {
        // Update textures from background results
        velocityTexture = await TextureBridge.createVelocityTexture(
          width, height, message['u'], message['v']);
        temperatureTexture = await TextureBridge.createTemperatureTexture(
          width, height, message['temperature']);
      }
    });
  }

  /// Starts or resumes the simulation loop.
  void start() {
    isRunning = true;
    _runLoop();
  }

  /// Pauses the simulation.
  void pause() {
    isRunning = false;
  }

  /// Injects a source into the simulation.
  void injectSource(int x, int y, double u, double v, double temp) {
    _sendPort?.send({
      'command': 'inject',
      'x': x,
      'y': y,
      'u': u,
      'v': v,
      'temp': temp,
    });
  }

  /// Updates simulation parameters.
  void updateParams({double? dt, int? iterations, double? coanda}) {
    _sendPort?.send({
      'command': 'update_params',
      'dt': dt,
      'iterations': iterations,
      'coanda': coanda,
    });
  }

  void _runLoop() {
    if (!isRunning) return;
    
    _sendPort?.send({'command': 'step'});
    
    // Schedule next step (approx 60fps or as fast as possible)
    Future.delayed(const Duration(milliseconds: 16), _runLoop);
  }

  void dispose() {
    isRunning = false;
    _isolate?.kill();
    _receivePort?.close();
  }
}
