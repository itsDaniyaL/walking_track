// left_menu.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walking_track/providers/user_data_provider.dart';

void showLeftMenu(BuildContext context, bool isSixMinuteEnabled) {
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
                  GestureDetector(
                    onTap: () {
                      if (!isSixMinuteEnabled) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                                '6 Minute Walking Test available after 3 months'),
                            duration: const Duration(seconds: 4),
                          ),
                        );
                      } else {
                        Navigator.pushNamed(
                          context,
                          '/sixMinuteWalking',
                        );
                      }
                    },
                    child: Opacity(
                      opacity: !isSixMinuteEnabled ? 0.5 : 1.0,
                      child: ListTile(
                        leading: const Icon(Icons.directions_walk),
                        title: const Text('6 Minute Walking Test'),
                        enabled: isSixMinuteEnabled,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.dashboard),
                    title: const Text('Dashboard'),
                    onTap: isConnected
                        ? () {
                            if (ModalRoute.of(context)?.settings.name ==
                                '/mainDashboard') {
                              Navigator.pop(context);
                            } else {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/mainDashboard',
                                (Route<dynamic> route) => route.isFirst,
                              );
                            }
                          }
                        : null,
                    enabled: isConnected,
                  ),
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: const Text('Help'),
                    onTap: isConnected
                        ? () => _launchUrl(
                            Uri.parse('https://walkingsupportgroup.com'))
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
