import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:walking_track/providers/user_data_provider.dart';
import 'package:walking_track/services/api_service.dart';
import 'package:walking_track/shared/filled_button.dart';

class AllowPermissionsPage extends StatefulWidget {
  const AllowPermissionsPage({super.key});

  @override
  State<AllowPermissionsPage> createState() => _AllowPermissionsPageState();
}

class _AllowPermissionsPageState extends State<AllowPermissionsPage> {
  late bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Allow Permissions',
          style: TextStyle(color: Colors.black),
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
                    setState(() {
                      loading = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Loading...'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    await _checkPermissions(context);
                    setState(() {
                      loading = false;
                    });
                  },
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
    PermissionStatus activityOrSensorsPermission = Platform.isIOS
        ? await Permission.sensors.status
        : await Permission.activityRecognition.status;

    bool permissionsGranted = await _requestPermissionsSequentially(
        notificationPermission, activityOrSensorsPermission);

    if (permissionsGranted) {
      ApiService apiService = ApiService();
      final userDataProvider =
          Provider.of<UserDataProvider>(context, listen: false);
      final username = userDataProvider.phone;
      if (username != null) {
        final response = await apiService.test6MinWalkingData(username);
        if (response.data['data']['counter'] == 0) {
          Navigator.pushNamed(context, '/sixMinuteWalking');
        } else {
          Navigator.pushNamed(context, '/mainDashboard');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('User not Found'),
            duration: const Duration(seconds: 3),
          ),
        );
        context.read<UserDataProvider>().clearAccount();
        Navigator.pushNamed(context, '/signIn');
      }
    } else {
      _showPermissionDialog(context);
    }
  }

  Future<bool> _requestPermissionsSequentially(
      PermissionStatus notificationPermission,
      PermissionStatus activityOrSensorsPermission) async {
    if (!notificationPermission.isGranted) {
      notificationPermission = await Permission.notification.request();
    }

    if (!activityOrSensorsPermission.isGranted) {
      activityOrSensorsPermission = Platform.isIOS
          ? await Permission.sensors.request()
          : await Permission.activityRecognition.request();
    }

    return notificationPermission.isGranted &&
        activityOrSensorsPermission.isGranted;
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permissions required'),
        content: const Text(
            'Notification and physical activity permissions are required to proceed.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
