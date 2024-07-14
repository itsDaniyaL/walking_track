import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:walking_track/screens/six_minute_walking.dart';
import 'package:walking_track/shared/filled_button.dart';

class AllowPermissionsPage extends StatefulWidget {
  const AllowPermissionsPage({super.key});

  @override
  State<AllowPermissionsPage> createState() => _AllowPermissionsPageState();
}

class _AllowPermissionsPageState extends State<AllowPermissionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Allow Permissions',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
          child: Column(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width * 0.75,
              child: const Text(
                  "In order to monitor steps and keep you updated, the app requires access to certain permissions.\n\nPlease continue to provide access.")),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.75,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomFilledButton(
                  onPressed: () async {
                    await _checkPermissions(context);
                  },
                  // validateForm()
                  //     ? () {
                  //         authenticateUser();
                  //       }
                  //     : null,
                  textColor: Theme.of(context).secondaryHeaderColor,
                  buttonColor: Theme.of(context).primaryColorLight,
                  child: const Icon(Icons.arrow_forward_ios_rounded),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  Future<void> _checkPermissions(BuildContext context) async {
    PermissionStatus notificationPermission =
        await Permission.notification.status;
    PermissionStatus activityPermission =
        await Permission.activityRecognition.status;

    if (notificationPermission.isGranted && activityPermission.isGranted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SixMinuteWalkingPage(),
        ),
      );
    } else {
      // Request permissions if not granted
      if (!notificationPermission.isGranted) {
        notificationPermission = await Permission.notification.request();
      }
      if (!activityPermission.isGranted) {
        activityPermission = await Permission.activityRecognition.request();
      }

      // After requesting, check again if permissions are granted
      if (notificationPermission.isGranted && activityPermission.isGranted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SixMinuteWalkingPage(),
          ),
        );
      } else {
        // Handle the case where permissions are not granted
        // For example, show a dialog to inform the user
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Permissions required'),
            content: Text(
                'Notification and physical activity permissions are required to proceed.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
}
