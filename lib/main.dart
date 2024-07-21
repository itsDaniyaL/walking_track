import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:walking_track/models/user_data.dart';
import 'package:walking_track/providers/sign_up_provider.dart';
import 'package:walking_track/providers/user_data_provider.dart';
import 'package:walking_track/screens/allow_permissions.dart';
import 'package:walking_track/screens/sign_in.dart';
import 'package:walking_track/screens/sign_in_new_user.dart';
import 'package:walking_track/screens/six_minute_walking.dart';

Future main() async {
  await dotenv.load(fileName: ".env");

  final userDataProvider = UserDataProvider();
  await userDataProvider.loadUserData();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      systemNavigationBarColor: Colors.transparent));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SignUpProvider()),
        ChangeNotifierProvider(create: (context) => UserDataProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Map<Permission, PermissionStatus>> requestPermissions() async {
    final notificationPermission = await Permission.notification.request();
    final activityPermission = await Permission.activityRecognition.request();

    return {
      Permission.notification: notificationPermission,
      Permission.activityRecognition: activityPermission,
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Havoc',
      theme: ThemeData(
        primaryColorLight: const Color(0xFFF75555),
        secondaryHeaderColor: const Color(0xFFFFFFFF),
        primaryColor: const Color(0xFF060171),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple)
            .copyWith(error: const Color(0xFFAE0909)),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF2C4A85),
        secondaryHeaderColor: const Color(0xFF212121),
      ),
      themeMode: ThemeMode.light,
      home: Consumer<UserDataProvider>(
        builder: (context, userDataProvider, child) {
          if (userDataProvider.userData != null) {
            // UserData exists, check additional conditions
            return FutureBuilder<bool>(
              future: userDataProvider.isPasswordChanged(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData && snapshot.data!) {
                  return FutureBuilder<Map<Permission, PermissionStatus>>(
                    future: requestPermissions(),
                    builder: (context, permissionsSnapshot) {
                      if (permissionsSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (permissionsSnapshot.hasData) {
                        final permissions = permissionsSnapshot.data!;
                        final notificationPermission =
                            permissions[Permission.notification]!;
                        final activityPermission =
                            permissions[Permission.activityRecognition]!;

                        if (notificationPermission.isGranted &&
                            activityPermission.isGranted) {
                          return SixMinuteWalkingPage();
                        } else {
                          return const AllowPermissionsPage();
                        }
                      }

                      return const SignInPage(); // Fallback in case of error
                    },
                  );
                } else {
                  return const SignInNewUserPage();
                }
              },
            );
          } else {
            return const SignInPage();
          }
        },
      ),
    );
  }
}
