import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';
import 'package:provider/provider.dart';
import 'package:walking_track/providers/user_data_provider.dart';
import 'package:walking_track/screens/main_dashboard.dart';
import 'package:walking_track/shared/filled_button.dart';
import 'package:walking_track/shared/notificationservice.dart';
import 'package:walking_track/shared/text_field.dart';

class WalkingWorkoutPage extends StatefulWidget {
  const WalkingWorkoutPage({super.key});

  @override
  _WalkingWorkoutPageState createState() => _WalkingWorkoutPageState();
}

class _WalkingWorkoutPageState extends State<WalkingWorkoutPage>
    with WidgetsBindingObserver {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '0', _timer = '00:00', symptom = "";
  int _initialSteps = 0, continueCount = 1;
  bool _isWalking = false,
      _isTimerVisible = false,
      _areStepsVisible = false,
      _isStopVisible = false,
      _isPainShowing = false,
      _isResting = false;
  Timer? _countupTimer;
  int _elapsedTime = 0;
  List<String> restTimestamps = [];
  List<int> painLevels = [];
  List<String> claudication = [];
  List<String> captureTimeN = [];
  String? startTime, endTime;
  bool _hasReturnedToApp = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    NotificationService().initNotification(handleNotificationTap);
    initPlatformState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _countupTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _hasReturnedToApp = false;

      // Delay showing the notification by 15 seconds
      Future.delayed(const Duration(seconds: 15), () {
        if (!_hasReturnedToApp && _isWalking) {
          NotificationService().showNotification(
              2, "Continue Walking", "Please continue your walking workout.");

          Future.delayed(const Duration(seconds: 30), () {
            if (!_hasReturnedToApp) {
              formatAndStoreWalkingData();
              NotificationService().showNotification(2, "Walking Workout Saved",
                  "Workout saved as you did not return back to the app");
              Navigator.of(context).pushReplacementNamed('/mainDashboard');
            }
          });
        }
      });
    } else if (state == AppLifecycleState.resumed) {
      _hasReturnedToApp = true;
    }
  }

  void handleNotificationTap() {
    debugPrint("Successfully returned back to the app");
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
      _isPainShowing = true;
      _isResting = false;
      _isStopVisible = true;
      _areStepsVisible = true;
      _isTimerVisible = true;
      startTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    });

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen((event) {
      if (_initialSteps == 0) {
        _initialSteps = event.steps;
      }
      onStepCount(event);
    }).onError(onStepCountError);

    startTimer();

    NotificationService().showNotification(
        1, "Walking Started", "You have started your walking workout.");
  }

  void startTimer() {
    _countupTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime++;
        int minutes = _elapsedTime ~/ 60;
        int seconds = _elapsedTime % 60;
        _timer =
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      });
    });
  }

  void rest() {
    setState(() {
      _isResting = false;
      _isWalking = true;
      restTimestamps
          .add(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()));
      _stepCountStream.listen((event) {}).cancel();
      // _countupTimer?.cancel();
    });
    showPainLevelDialog();
  }

  void continueWalking() {
    setState(() {
      _isWalking = true;
      _isPainShowing = true;
      _isResting = false;
      continueCount++;
      captureTimeN
          .add(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()));
    });
    _stepCountStream = Pedometer.stepCountStream; // Restart counting steps
    _stepCountStream.listen((event) {
      if (_initialSteps == 0) {
        _initialSteps = event.steps;
      }
      onStepCount(event);
    }).onError(onStepCountError);
    // startTimer();
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
                  onChanged: (text) {
                    setState(() {
                      symptom = text;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomFilledButton(
                  onPressed: () async {
                    endTime = DateFormat('yyyy-MM-dd HH:mm:ss')
                        .format(DateTime.now());
                    final statusCheck = await formatAndStoreWalkingData();
                    if (statusCheck) {
                      debugPrint("Successful");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              const Text('Walking Data saved Successfully!'),
                          duration: const Duration(seconds: 4),
                        ),
                      );
                      Navigator.pushNamed(context, '/mainDashboard');
                    } else {
                      debugPrint("Failed");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                              'Faced an error saving data. Try again later!'),
                          duration: const Duration(seconds: 4),
                        ),
                      );
                      Navigator.pushNamed(context, '/mainDashboard');
                    }
                  },
                  buttonColor: Theme.of(context).primaryColorLight,
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> formatAndStoreWalkingData() async {
    String painLevelsStr = painLevels.join(',');
    String claudicationStr = claudication.join(',');
    String restTimestampsStr = restTimestamps.join(',');
    String captureTimeNStr = captureTimeN.join((','));
    final userDataProvider =
        Provider.of<UserDataProvider>(context, listen: false);
    final username = userDataProvider.phone;
    if (symptom.isEmpty) {
      setState(() {
        symptom = "Incomplete";
      });
    }
    if (username != null) {
      Map<String, String> walkingData = {
        "username": username,
        "N": continueCount.toString(),
        "total_steps": _steps,
        "symptoms": symptom,
        "pain_level": painLevelsStr,
        "capturetimeN": captureTimeNStr,
        "start_time": startTime ?? "",
        "end_time": endTime ?? "",
        "claudication": claudicationStr,
        "rest_time": restTimestampsStr,
      };
      return await context.read<UserDataProvider>().walkingData(walkingData);
    }
    return false;
  }

  void logPain() {
    setState(() {
      _isPainShowing = false;
      _isResting = true;
    });
    claudication.add(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()));
  }

  void showPainLevelDialog() {
    int painLevel = 0;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Pain Level'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Please select your pain level (0-10):'),
                  Slider(
                    value: painLevel.toDouble(),
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: painLevel.toString(),
                    onChanged: (double value) {
                      setState(() {
                        painLevel = value.toInt();
                      });
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    setState(() {
                      painLevels.add(painLevel);
                      claudication.add(DateFormat('yyyy-MM-dd HH:mm:ss')
                          .format(DateTime.now()));
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            'Walking Workout',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.transparent,
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
              const SizedBox(height: 75),
              CustomFilledButton(
                onPressed: () {
                  if (!_isWalking) {
                    startWalking();
                  } else if (_isPainShowing) {
                    logPain();
                  } else if (_isResting) {
                    rest();
                  } else {
                    continueWalking();
                  }
                },
                width: 150,
                height: 150,
                buttonColor: const Color(0xFF554EEB),
                borderRadius: BorderRadius.circular(60),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isPainShowing
                            ? Icons.healing_outlined
                            : _isResting
                                ? Icons.pause
                                : Icons.directions_walk,
                        size: 50,
                      ),
                      Text(
                          !_isWalking
                              ? "Start Walking"
                              : _isPainShowing
                                  ? "Pain?"
                                  : _isResting
                                      ? "Rest"
                                      : "Continue",
                          style: const TextStyle(fontSize: 15)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 75),
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
              const SizedBox(height: 75),
              if (_isStopVisible)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomFilledButton(
                      onPressed: showSymptomsBottomSheet,
                      width: 150,
                      height: 150,
                      buttonColor: const Color(0xFFD94C4C),
                      borderRadius: BorderRadius.circular(60),
                      child: const Padding(
                        padding: EdgeInsets.only(bottom: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.close, size: 50),
                            Text("Stop Workout"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
