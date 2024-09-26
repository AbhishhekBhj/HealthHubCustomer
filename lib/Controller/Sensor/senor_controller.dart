import 'dart:async';
import 'dart:math';
import 'dart:developer' as dev;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:healthhubcustomer/colors/colors.dart';
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
  double _threshold = 0.15; // Calibration threshold
  double _alpha = 0.9; // Calibration factor
  int _bufferSize = 50;

  List<double> _magnitudeBuffer = [];
  StreamSubscription<UserAccelerometerEvent>? _accelerometerSubscription;
  final StreamController<int> _stepCountController = StreamController<int>.broadcast();

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

    // Using both magnitude threshold and GPS-based speed for calibration
    if (_lastMagnitude > _threshold && (_lastStepTime == null || now.difference(_lastStepTime!) > _debounceDuration)) {
      // Check if the user is moving
      if (_currentPosition != null) {
        double speed = _currentPosition!.speed; // Use Geolocator's speed (in m/s)

        // Basic speed threshold check (adjust as needed)
        if (speed > 0.5) { // Example threshold
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
    // Update location at regular intervals
    Timer.periodic(Duration(seconds: 5), (timer) async {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _stepCountController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int stepGoals = Provider.of<StepCounterProvider>(context).stepGoals;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Step Counter',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            StreamBuilder<int>(
              stream: _stepCountController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  int currentSteps = snapshot.data!;
                  dev.log('Step count: $currentSteps');

                  // Calculate percentage of steps towards goal
                  double percentage = (currentSteps / stepGoals).clamp(0.0, 1.0);

                  return CircularPercentIndicator(
                    radius: 100.0,
                    lineWidth: 10.0,
                    percent: percentage,
                    center: Text('$currentSteps'),
                    backgroundColor: Colors.grey,
                    progressColor: appMainColor,
                  );
                } else {
                  return CircularPercentIndicator(
                    radius: 100.0,
                    lineWidth: 10.0,
                    percent: 0,
                    center: Text('0'),
                    backgroundColor: Colors.grey,
                    progressColor: appMainColor,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
