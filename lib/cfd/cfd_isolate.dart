import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'fluid_grid.dart';
import 'advection.dart';
import 'pressure_solver.dart';
import 'boundary.dart';
import 'buoyancy.dart';
import 'coanda.dart';

/// Manages the CFD simulation loop in a background Dart Isolate.
class CfdIsolate {
  /// Entry point for the Isolate.
  static void entryPoint(SendPort mainSendPort) {
    final ReceivePort receivePort = ReceivePort();
    mainSendPort.send(receivePort.sendPort);

    FluidGrid? grid;
    double dt = 0.1;
    int iterations = 40;
    double coandaStrength = 0.5;

    receivePort.listen((message) {
      if (message is Map) {
        final String command = message['command'];

        switch (command) {
          case 'init':
            grid = FluidGrid(message['width'], message['height']);
            if (message['boundaries'] != null) {
              grid!.boundaries.setAll(0, message['boundaries'] as Uint8List);
            }
            break;

          case 'step':
            if (grid != null) {
              _performStep(grid!, dt, iterations, coandaStrength);
              // Send back the results as TransferableTypedData if needed,
              // but for now, we'll just send the lists (which might be copied).
              mainSendPort.send({
                'type': 'result',
                'u': grid!.u,
                'v': grid!.v,
                'temperature': grid!.temperature,
              });
            }
            break;

          case 'update_params':
            dt = message['dt'] ?? dt;
            iterations = message['iterations'] ?? iterations;
            coandaStrength = message['coanda'] ?? coandaStrength;
            break;

          case 'inject':
             if (grid != null) {
               int idx = grid!.getIndex(message['x'], message['y']);
               grid!.u[idx] += message['u'] ?? 0;
               grid!.v[idx] += message['v'] ?? 0;
               grid!.temperature[idx] += message['temp'] ?? 0;
             }
             break;
        }
      }
    });
  }

  /// Performs a single simulation step.
  static void _performStep(FluidGrid grid, double dt, int iterations, double coandaStrength) {
    // 1. Apply External Forces (Buoyancy)
    Buoyancy.apply(grid, dt);

    // 2. Advect Velocity
    grid.swapVelocity();
    Advection.solve(grid, grid.u, grid.uOld, dt);
    Advection.solve(grid, grid.v, grid.vOld, dt);

    // 3. Advect Temperature
    grid.swapTemperature();
    Advection.solve(grid, grid.temperature, grid.temperatureOld, dt);

    // 4. Boundary Effects (Coanda)
    Coanda.apply(grid, coandaStrength);

    // 5. Project (Incompressibility)
    Boundary.apply(grid);
    PressureSolver.solve(grid, iterations);
    Boundary.apply(grid);
  }
}
