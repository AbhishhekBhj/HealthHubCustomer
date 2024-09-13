import 'dart:async';
import 'dart:math';
import 'dart:developer' as dev;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class StepCounterPage extends StatefulWidget {
  @override
  _StepCounterPageState createState() => _StepCounterPageState();
}

class _StepCounterPageState extends State<StepCounterPage> {
  double _x = 0.0;
  double _y = 0.0;
  double _z = 0.0;
  double _gyroX = 0.0;
  double _gyroY = 0.0;
  double _gyroZ = 0.0;
  int _stepCount = 0;
  int initialSteps = 0;

  double _lastMagnitude = 0.0;
  double _threshold = 0.1;
  double _alpha = 0.95;
  int _bufferSize = 50;

  List<double> _magnitudeBuffer = [];
  StreamSubscription<UserAccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  final StreamController<int> _stepCountController = StreamController<int>.broadcast();

  DateTime? _lastStepTime;
  final Duration _debounceDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _startListening();
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

    _gyroscopeSubscription = gyroscopeEvents.listen((event) {
      _gyroX = event.x;
      _gyroY = event.y;
      _gyroZ = event.z;

      // Additional processing of gyroscope data can be done here
    });
  }

  void _checkForStep() {
    DateTime now = DateTime.now();

    if (_lastMagnitude > _threshold && (_lastStepTime == null || now.difference(_lastStepTime!) > _debounceDuration)) {
      _stepCount++;
      _stepCountController.add(_stepCount);
      _lastStepTime = now;
    }
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    _stepCountController.close();
    super.dispose();
  }

  void _updateThreshold(double newValue) {
    setState(() {
      _threshold = newValue;
    });
  }

  void _updateAlpha(double newValue) {
    setState(() {
      _alpha = newValue;
    });
  }

  void _updateBufferSize(double newValue) {
    setState(() {
      _bufferSize = newValue.toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step Counter'),
      ),
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
                  dev.log('Step count: ${snapshot.data}');
                  return Text(
                    'Step Count: ${snapshot.data}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 24),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return Text('Connection has been closed');
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Steps: ${initialSteps}');
                } else {
                  return CupertinoActivityIndicator();
                }
              },
            ),
            SizedBox(height: 32),
            _buildCalibrationControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalibrationControls() {
    return Column(
      children: [
        Text('Calibration Controls', style: Theme.of(context).textTheme.bodySmall),
        SizedBox(height: 16),
        _buildSlider(
          title: 'Threshold',
          value: _threshold,
          min: 0.0,
          max: 1.0,
          onChanged: (value) => _updateThreshold(value),
        ),
        SizedBox(height: 16),
        _buildSlider(
          title: 'Alpha',
          value: _alpha,
          min: 0.0,
          max: 1.0,
          onChanged: (value) => _updateAlpha(value),
        ),
        SizedBox(height: 16),
        _buildSlider(
          title: 'Buffer Size',
          value: _bufferSize.toDouble(),
          min: 10.0,
          max: 100.0,
          onChanged: (value) => _updateBufferSize(value),
        ),
      ],
    );
  }

  Widget _buildSlider({
    required String title,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodySmall),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: 100,
          onChanged: onChanged,
        ),
        Text(value.toStringAsFixed(2)),
      ],
    );
  }
}
