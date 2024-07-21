import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walking_track/providers/user_data_provider.dart';
import 'package:walking_track/screens/main_dashboard.dart';
import 'package:walking_track/screens/sign_in.dart';
import 'package:walking_track/screens/walking_workout.dart';
import 'package:walking_track/screens/change_password.dart';
import 'package:walking_track/shared/filled_button.dart';
import 'package:url_launcher/url_launcher.dart';

class PreviewDashboardPage extends StatefulWidget {
  const PreviewDashboardPage({super.key});

  @override
  State<PreviewDashboardPage> createState() => _PreviewDashboardPageState();
}

class _PreviewDashboardPageState extends State<PreviewDashboardPage> {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MainDashboardPage()),
                );
                // Navigate to Dashboard
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help'),
              onTap: () => _launchUrl(Uri.parse(
                  'https://www.facebook.com/groups/3350980051814826/?ref=share&mibextid=NSMWBT')),
              // Navigate to Help
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                );
                // Navigate to Change Password
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy'),
              onTap: () => _launchUrl(Uri.parse(
                  'https://www.facebook.com/groups/3350980051814826/?ref=share&mibextid=NSMWBT')),
              // Navigate to Privacy
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () {
                Provider.of<UserDataProvider>(context).clearAccount();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInPage()),
                );
                // Perform Log Out
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Close Account'),
              onTap: () async {
                await Provider.of<UserDataProvider>(context).closeAccount();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInPage()),
                );
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
          'Preview Dashboard',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomFilledButton(
                    onPressed: () {},
                    width: 150,
                    height: 150,
                    buttonColor: const Color(0xFF554EEB),
                    borderRadius: BorderRadius.circular(60),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "4 min 22 sec",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "Caludication\nTime",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  CustomFilledButton(
                    onPressed: () {},
                    width: 150,
                    height: 150,
                    buttonColor: const Color(0xFF554EEB),
                    borderRadius: BorderRadius.circular(60),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "4 min 22 sec",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "Walk to Rest",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomFilledButton(
                    onPressed: () {},
                    width: 150,
                    height: 150,
                    buttonColor: const Color(0xFF554EEB),
                    borderRadius: BorderRadius.circular(60),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "4 min 22 sec",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "Walk no Rest",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  CustomFilledButton(
                    onPressed: () {},
                    width: 150,
                    height: 150,
                    buttonColor: const Color(0xFF554EEB),
                    borderRadius: BorderRadius.circular(60),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "4 min 22 sec",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "Time at Rest",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomFilledButton(
                    onPressed: () {},
                    width: 150,
                    height: 150,
                    buttonColor: const Color(0xFF554EEB),
                    borderRadius: BorderRadius.circular(60),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "4 min 22 sec",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "Actual Walking",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  CustomFilledButton(
                    onPressed: () {},
                    width: 150,
                    height: 150,
                    buttonColor: const Color(0xFF554EEB),
                    borderRadius: BorderRadius.circular(60),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "4 min 22 sec",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "Total Steps",
                          textAlign: TextAlign.center,
                        ),
                      ],
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
                  onPressed: () => _launchUrl(Uri.parse(
                      'https://www.facebook.com/groups/3350980051814826/?ref=share&mibextid=NSMWBT')),
                  buttonColor: const Color(0xFF8A73C7),
                  width: 110,
                  height: 60,
                  borderRadius: BorderRadius.circular(70),
                  child: const Text("Facebook")),
              CustomFilledButton(
                onPressed: () => _launchUrl(Uri.parse(
                    'https://m.me/ch/AbYJJdykvDXgZk7m/?send_source=cm%3Acopy_invite_link')),
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
