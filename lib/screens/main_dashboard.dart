import 'package:flutter/material.dart';
import 'package:walking_track/screens/walking_workout.dart';
import 'package:walking_track/shared/filled_button.dart';

class MainDashboardPage extends StatefulWidget {
  const MainDashboardPage({super.key});

  @override
  State<MainDashboardPage> createState() => _MainDashboardPageState();
}

class _MainDashboardPageState extends State<MainDashboardPage> {
  void _showLeftMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.directions_walk),
              title: const Text('6 Minute Walking Test'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to 6 Minute Walking Test
              },
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to Dashboard
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to Help
              },
            ),
          ],
        );
      },
    );
  }

  void _showRightMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to Change Password
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to Privacy
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () {
                Navigator.pop(context);
                // Perform Log Out
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Close Account'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to Close Account
              },
            ),
          ],
        );
      },
    );
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
          onPressed: _showLeftMenu,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: _showRightMenu,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WalkingWorkoutPage()),
                  );
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
                onPressed: () {},
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
                  _dialogBuilder(context);
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
                  onPressed: () {},
                  buttonColor: const Color(0xFF8A73C7),
                  width: 110,
                  height: 60,
                  borderRadius: BorderRadius.circular(70),
                  child: const Text("Facebook")),
              CustomFilledButton(
                onPressed: () {},
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
