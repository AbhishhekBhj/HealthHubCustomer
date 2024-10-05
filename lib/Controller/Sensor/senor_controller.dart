import 'dart:async';
import 'dart:math';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../providers/step_counter_provider.dart';

class StepCounterPage extends StatefulWidget {
  @override
  _StepCounterPageState createState() => _StepCounterPageState();
}

class _StepCounterPageState extends State<StepCounterPage> {
  double _x = 0.0;
  double _y = 0.0;
  double _z = 0.0;
  int _stepCount = 0;

  double _lastMagnitude = 0.0;
  double _threshold = 0.15;
  double _alpha = 0.9;
  int _bufferSize = 50;
  List<double> _magnitudeBuffer = [];
  
  StreamSubscription<UserAccelerometerEvent>? _accelerometerSubscription;
  final StreamController<int> _stepCountController = StreamController<int>.broadcast();
  late StreamSubscription<Position> _positionStream;

  DateTime? _lastStepTime;
  final Duration _debounceDuration = Duration(milliseconds: 500);
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _startListening();
    _getCurrentLocation();
  }

  void _startListening() {
    _accelerometerSubscription = userAccelerometerEventStream().listen((event) {
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

  void _checkForStep() {
    DateTime now = DateTime.now();

    if (_lastMagnitude > _threshold && (_lastStepTime == null || now.difference(_lastStepTime!) > _debounceDuration)) {
      if (_currentPosition != null) {
        double speed = _currentPosition!.speed;

        if (speed > 0.5) {
          _stepCount++;
          _stepCountController.add(_stepCount);
          _lastStepTime = now;
          dev.log('Step detected: $_stepCount at speed: $speed');
        }
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 1),
    ).listen((Position position) {
      _currentPosition = position;
      dev.log('Updated position: ${position.latitude}, ${position.longitude}');
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _stepCountController.close();
    _positionStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int stepGoals = Provider.of<StepCounterProvider>(context).stepGoals;

    return Scaffold(
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            StreamBuilder<int>(
              stream: _stepCountController.stream,
              builder: (context, snapshot) {
                int currentSteps = snapshot.data ?? 0;
                double percentage = (currentSteps / stepGoals).clamp(0.0, 1.0);
      
                return CircularPercentIndicator(
                  radius: 80.0,
                  lineWidth: 12.0,
                  animation: true,
                  animationDuration: 1200,
                  percent: percentage,
                  center: Text(
                    '$currentSteps',
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.grey.shade200,
                  progressColor: Colors.blueAccent,
                  circularStrokeCap: CircularStrokeCap.round,
                );
              },
            ),
            SizedBox(height: 20),
            Text(
              'Goal: $stepGoals steps',
              style: TextStyle(fontSize: 16.0, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
