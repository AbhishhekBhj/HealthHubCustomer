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
  int _stepCount = 0;

  // Parameters for step detection
  double _lastMagnitude = 0.0;
  double _threshold = 100.0; // Threshold for peak detection
  double _smoothingFactor = 0.5; // For smoothing the magnitude data
  List<double> _magnitudeBuffer = [];
  int _bufferSize = 25;

  StreamSubscription<UserAccelerometerEvent>? _accelerometerSubscription;

  Stream<int> get stepCount => Stream<int>.value(_stepCount);

  StreamController<int> _stepCountController = StreamController<int>.broadcast();


  

  

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    try {
      _accelerometerSubscription = userAccelerometerEventStream().listen((UserAccelerometerEvent event) {
        setState(() {
          _x = event.x;
          _y = event.y;
          _z = event.z;


double magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
          // Calculate the magnitude of the acceleration vector
          

          // Apply smoothing
          if (_magnitudeBuffer.length >= _bufferSize) {
            _magnitudeBuffer.removeAt(0);
          }
          _magnitudeBuffer.add(magnitude);

          double smoothedMagnitude = _magnitudeBuffer.reduce((a, b) => a + b) / _magnitudeBuffer.length;

          // Detect peaks
          if ((smoothedMagnitude - _lastMagnitude) < _threshold) {
            _stepCount++;
            _stepCountController.add(_stepCount); // Emit new step count to the stream

          }
          else{
            dev.log('${smoothedMagnitude - _lastMagnitude}');
            dev.log('Threshold: $_threshold');
          }
          
          

          _lastMagnitude = smoothedMagnitude;
        });
      });
    } catch (e) {
      dev.log('Error starting sensor listening: $e');
    }
  }

  @override
  void dispose() {
    try {
      _accelerometerSubscription?.cancel();
    } catch (e) {
      dev.log('Error canceling sensor subscription: $e');
    }
    super.dispose();
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
              'X: ${_x.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Y: ${_y.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Z: ${_z.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),

            StreamBuilder<int>(
              stream: stepCount,
              builder: (context, snapshot) {
               if (snapshot.hasData) {
                dev.log('Step count: ${snapshot.data}');
                  return Text(
                    'Step count: ${snapshot.data}',
                    style: TextStyle(fontSize: 24),
                  );
                } else {
                  return CupertinoActivityIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
