// right_menu.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walking_track/providers/user_data_provider.dart';
import 'package:walking_track/screens/sign_in.dart';
import 'package:walking_track/shared/notificationservice.dart';

void showRightMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Consumer<UserDataProvider>(
        builder: (context, userDataProvider, child) {
          return FutureBuilder<bool>(
            future: userDataProvider.isConnected(),
            builder: (context, snapshot) {
              bool isConnected = snapshot.data ?? false;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: const Text('Change Password'),
                    onTap: isConnected
                        ? () {
                            Navigator.pushNamed(context, '/changePassword');
                          }
                        : null,
                    enabled: isConnected,
                  ),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip),
                    title: const Text('Privacy'),
                    onTap: isConnected
                        ? () => _launchUrl(Uri.parse(
                            'https://www.thewaytomyheart.org/privacy-policy'))
                        : null,
                    enabled: isConnected,
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Log Out'),
                    onTap: isConnected
                        ? () {
                            NotificationService().cancelAllNotifications();
                            context.read<UserDataProvider>().clearAccount();
                            Navigator.pushNamed(context, '/signIn');
                          }
                        : null,
                    enabled: isConnected,
                  ),
                  ListTile(
                    leading: const Icon(Icons.close),
                    title: const Text('Close Account'),
                    onTap: isConnected
                        ? () async {
                            bool confirmClose = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirm Close Account'),
                                  content: const Text(
                                      'Are you sure you want to close your account? This action cannot be undone.'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop(
                                            false); // Return false on cancel
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Confirm'),
                                      onPressed: () {
                                        Navigator.of(context).pop(
                                            true); // Return true on confirm
                                      },
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirmClose == true) {
                              final bool checkStatus = await context
                                  .read<UserDataProvider>()
                                  .closeAccount();

                              if (checkStatus) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Account Closed'),
                                      content: const Text(
                                          'Your account has been successfully closed.'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SignInPage()),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ).then((_) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignInPage()),
                                  );
                                });
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title:
                                          const Text('Account Closing Failed'),
                                      content: const Text(
                                          'Failed to close your account. Please try again.'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          }
                        : null,
                    enabled: isConnected,
                  ),
                ],
              );
            },
          );
        },
      );
    },
  );
}

Future<void> _launchUrl(Uri _url) async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
