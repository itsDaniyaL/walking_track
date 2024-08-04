import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walking_track/providers/user_data_provider.dart';
import 'package:walking_track/services/api_service.dart';
import 'package:walking_track/shared/filled_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walking_track/shared/left_menu.dart';
import 'package:walking_track/shared/notificationservice.dart';
import 'package:walking_track/shared/right_menu.dart';

class MainDashboardPage extends StatefulWidget {
  const MainDashboardPage({super.key});

  @override
  State<MainDashboardPage> createState() => _MainDashboardPageState();
}

class _MainDashboardPageState extends State<MainDashboardPage> {
  final NotificationService _notificationService = NotificationService();
  bool isSixMinuteEnabled = false;
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    checkSixMinuteEnabled();
    checkConnection();
  }

  Future<void> checkConnection() async {
    isConnected = await context.read<UserDataProvider>().isConnected();
  }

  Future<void> checkSixMinuteEnabled() async {
    ApiService apiService = ApiService();
    final userDataProvider =
        Provider.of<UserDataProvider>(context, listen: false);
    final username = userDataProvider.phone;
    if (username != null) {
      if (await userDataProvider.isConnected()) {
        final response = await apiService.test6MinWalkingData(username);
        if (response.statusCode == 200) {
          final jsonResponse = response.data;
          bool enableStatus = jsonResponse['data']['enabled'] &&
              jsonResponse['data']['counter'] > 0;
          setState(() {
            isSixMinuteEnabled = enableStatus;
          });
        }
      }
    }
  }

  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<void> refreshContent() async {
    checkSixMinuteEnabled();
    checkConnection();
    context.read<UserDataProvider>().syncWalkingData();
    context.read<UserDataProvider>().reviewWalkingData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Main Dashboard',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => showLeftMenu(context, isSixMinuteEnabled),
        ),
        actions: [
          if (!isConnected)
            IconButton(
              icon: const Icon(Icons.signal_wifi_bad),
              onPressed: () async {
                await refreshContent();

                bool isConnected =
                    await context.read<UserDataProvider>().isConnected();

                if (isConnected) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('You are online now!'),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('No internet connection!'),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              },
            ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => showRightMenu(context),
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomFilledButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/walkingWorkout');
                },
                width: 150,
                height: 150,
                buttonColor: const Color(0xFF554EEB),
                borderRadius: BorderRadius.circular(60),
                child: const Text(
                  "Walking\nWorkout",
                  textAlign: TextAlign.center,
                ),
              ),
              CustomFilledButton(
                onPressed: () async {
                  if (isConnected) {
                    await context.read<UserDataProvider>().reviewWalkingData();
                    Navigator.pushNamed(context, '/previewDashboard');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Turn on Internet connection!'),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                },
                width: 150,
                height: 150,
                buttonColor: const Color(0xFF554EEB),
                borderRadius: BorderRadius.circular(60),
                child: const Text(
                  "Review\nDashboard",
                  textAlign: TextAlign.center,
                ),
              ),
              CustomFilledButton(
                onPressed: () {
                  if (isConnected) {
                    _dialogBuilder(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Turn on Internet connection!'),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                },
                width: 150,
                height: 150,
                buttonColor: const Color(0xFF554EEB),
                borderRadius: BorderRadius.circular(60),
                child: const Text(
                  "Community\nSupport",
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          title: const Text(
            'Community Support',
            style: TextStyle(color: Colors.black),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomFilledButton(
                  onPressed: () =>
                      _launchUrl(Uri.parse('https://walkingsupportgroup.com')),
                  buttonColor: const Color(0xFF8A73C7),
                  width: 110,
                  height: 60,
                  borderRadius: BorderRadius.circular(70),
                  child: const Text("Facebook")),
              CustomFilledButton(
                onPressed: () =>
                    _launchUrl(Uri.parse('https://m.me/ch/AbZF4gbTsLnnKYCB/')),
                buttonColor: const Color(0xFF8A73C7),
                width: 110,
                height: 60,
                borderRadius: BorderRadius.circular(70),
                child: const Text("Chat"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                  foregroundColor: Colors.white),
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
