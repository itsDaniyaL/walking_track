import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:walking_track/screens/main_dashboard.dart';
import 'package:walking_track/shared/filled_button.dart';
import 'package:walking_track/shared/text_field.dart';

class SixMinuteWalkingPage extends StatefulWidget {
  @override
  _SixMinuteWalkingPageState createState() => _SixMinuteWalkingPageState();
}

class _SixMinuteWalkingPageState extends State<SixMinuteWalkingPage> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '0', _timer = '00:00';
  int _initialSteps = 0;
  bool _isWalking = false, _isTimerVisible = false, _areStepsVisible = false;
  Timer? _countupTimer;
  int _elapsedTime = 0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    setState(() {
      _steps = (event.steps - _initialSteps).toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    setState(() {
      _status = 'Pedestrian Status not available';
    });
  }

  void onStepCountError(error) {
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);
  }

  void startWalking() {
    setState(() {
      _isWalking = true;
      _isTimerVisible = true;
      _areStepsVisible = true;
    });

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen((event) {
      if (_initialSteps == 0) {
        _initialSteps = event.steps;
      }
      onStepCount(event);
    }).onError(onStepCountError);

    startTimer();
  }

  void startTimer() {
    _countupTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime++;
        int minutes = _elapsedTime ~/ 60;
        int seconds = _elapsedTime % 60;
        _timer =
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

        if (_elapsedTime >= 10) {
          timer.cancel();
          _isWalking = false;
          showSymptomsBottomSheet();
        }
      });
    });
  }

  void rest() {
    _countupTimer?.cancel();
    setState(() {
      _isWalking = false;
    });
  }

  void continueWalking() {
    setState(() {
      _isWalking = true;
    });
    startTimer();
  }

  @override
  void dispose() {
    _countupTimer?.cancel();
    super.dispose();
  }

  void showSymptomsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Symptoms',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomTextField(
                  hintText: "Add Symptom",
                  onChanged: (text) {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomFilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainDashboardPage()),
                    );
                  },
                  buttonColor: Theme.of(context).primaryColorLight,
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        );
      },
    ).then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainDashboardPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('6 Minute Walking Test'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_isTimerVisible)
                SizedBox(
                  width: 200,
                  height: 50,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(Icons.timelapse, color: Colors.black),
                        Text(
                          _timer,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 100),
              CustomFilledButton(
                onPressed: _isWalking
                    ? rest
                    : (_elapsedTime > 0 ? continueWalking : startWalking),
                width: 150,
                height: 150,
                buttonColor: const Color(0xFF554EEB),
                borderRadius: BorderRadius.circular(60),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_isWalking ? Icons.pause : Icons.directions_walk,
                          size: 50),
                      Text(_isWalking
                          ? "Rest"
                          : (_elapsedTime > 0 ? "Continue" : "Start Walking")),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 100),
              if (_areStepsVisible)
                SizedBox(
                  width: 200,
                  height: 50,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Steps Taken: ',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          _steps,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
