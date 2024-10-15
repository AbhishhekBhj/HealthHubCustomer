import 'dart:async';
import 'dart:math';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../../utils/shared_preference_helper.dart';
import '../providers/step_counter_provider.dart';


import 'dart:async';
import 'dart:math';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';

class StepDetectionService {
  double _x = 0.0;
  double _y = 0.0;
  double _z = 0.0;
  double _lastMagnitude = 0.0;
  final double _threshold = 0.15;
  final double _alpha = 0.9;
  final int _bufferSize = 50;
  final List<double> _magnitudeBuffer = [];
  DateTime? _lastStepTime;
  final Duration _debounceDuration = const Duration(milliseconds: 500);
  Position? _currentPosition;

  StreamSubscription<UserAccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<Position>? _positionStream;

  Function()? onStepDetected;

  StepDetectionService({this.onStepDetected});

  // Start listening to accelerometer and position updates
  void startListening() {
    _startAccelerometerListening();
    _getCurrentLocation();
  }

  // Stop listening to accelerometer and position updates
  void stopListening() {
    _accelerometerSubscription?.cancel();
    _positionStream?.cancel();
  }

  // Start listening to accelerometer events
  void _startAccelerometerListening() {
    _accelerometerSubscription = userAccelerometerEvents.listen((event) {
      _x = event.x;
      _y = event.y;
      _z = event.z;

      double magnitude = sqrt(_x * _x + _y * _y + _z * _z);
      _magnitudeBuffer.add(magnitude);
      if (_magnitudeBuffer.length > _bufferSize) {
        _magnitudeBuffer.removeAt(0);
      }

      double avg = _magnitudeBuffer.reduce((a, b) => a + b) / _magnitudeBuffer.length;
      double delta = magnitude - avg;
      _lastMagnitude = _alpha * _lastMagnitude + (1 - _alpha) * delta;

      _checkForStep();
    });
  }

  // Check if a step is detected based on magnitude and speed
  void _checkForStep() {
    DateTime now = DateTime.now();

    if (_lastMagnitude > _threshold && (_lastStepTime == null || now.difference(_lastStepTime!) > _debounceDuration)) {
      if (_currentPosition != null) {
        double speed = _currentPosition!.speed;

        // Only count steps if the speed is above a threshold (e.g., walking)
        if (speed > 0.5) {
          _lastStepTime = now;

          // Notify listeners that a step is detected
          onStepDetected?.call();
          dev.log('Step detected at speed: $speed');
        }
      }
    }
  }

  // Get current location and start listening for location changes
  Future<void> _getCurrentLocation() async {
    _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 1),
    ).listen((Position position) {
      _currentPosition = position;
      // dev.log('Updated position: ${position.latitude}, ${position.longitude}');
    });
  }
}



class StepCounterPage extends StatefulWidget {
  @override
  _StepCounterPageState createState() => _StepCounterPageState();
}

class _StepCounterPageState extends State<StepCounterPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Start step detection after the frame is rendered
      Provider.of<StepCounterProvider>(context, listen: false).startStepDetection();
    });
  }

  @override
  void dispose() {
    Provider.of<StepCounterProvider>(context, listen: false).stopStepDetection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stepCounterProvider = Provider.of<StepCounterProvider>(context);
    int currentSteps = stepCounterProvider.steps;
    int stepGoals = stepCounterProvider.stepGoals;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularPercentIndicator(
              radius: 80.0,
              lineWidth: 12.0,
              animation: true,
              animationDuration: 1200,
              percent: (currentSteps / stepGoals).clamp(0.0, 1.0),
              center: Text(
                '$currentSteps',
                style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.grey.shade200,
              progressColor: Colors.blueAccent,
              circularStrokeCap: CircularStrokeCap.round,
            ),
            const SizedBox(height: 20),
            Text(
              'Goal: $stepGoals steps',
              style: const TextStyle(fontSize: 16.0, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
