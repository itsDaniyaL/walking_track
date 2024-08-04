import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walking_track/models/six_minute_enabled.dart';
import 'package:walking_track/models/user_data.dart';
import 'package:walking_track/providers/sign_up_provider.dart';
import 'package:walking_track/providers/user_data_provider.dart';
import 'package:walking_track/screens/allow_permissions.dart';
import 'package:walking_track/screens/change_password.dart';
import 'package:walking_track/screens/main_dashboard.dart';
import 'package:walking_track/screens/preview_dashboard.dart';
import 'package:walking_track/screens/sign_in.dart';
import 'package:walking_track/screens/sign_in_new_user.dart';
import 'package:walking_track/screens/sign_up_description.dart';
import 'package:walking_track/screens/sign_up_diagnostics.dart';
import 'package:walking_track/screens/sign_up_user_info.dart';
import 'package:walking_track/screens/six_minute_walking.dart';
import 'package:walking_track/screens/walking_workout.dart';
import 'package:walking_track/shared/notificationservice.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  void handleNotificationTap() {
    debugPrint("Notification tapped!");
  }

  NotificationService().initNotification(handleNotificationTap);
  await NotificationService().requestExactAlarmPermission();
  // await NotificationService().showDailyAtTime();
  await dotenv.load(fileName: ".env");

  // Initialize and load user data
  final userDataProvider = UserDataProvider();
  await userDataProvider.loadUserData();
  await userDataProvider.loadSixMinuteWalkingData();
  userDataProvider.syncWalkingData();
  // Set preferred orientations to portrait only
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black,
    systemNavigationBarColor: Colors.transparent,
  ));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SignUpProvider()),
        ChangeNotifierProvider<UserDataProvider>.value(value: userDataProvider),
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
    final userData = context.select<UserDataProvider, UserData?>((value) {
      return value.userData;
    });
    final sixMinuteEnabled =
        context.select<UserDataProvider, SixMinuteWalkingData?>((value) {
      return value.sixMinuteWalkingEnabled;
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Walking Track',
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
      routes: {
        '/signIn': (context) => const SignInPage(),
        '/signInNewUser': (context) => const SignInNewUserPage(),
        '/allowPermissions': (context) => const AllowPermissionsPage(),
        '/sixMinuteWalking': (context) => SixMinuteWalkingPage(),
        '/mainDashboard': (context) => const MainDashboardPage(),
        '/previewDashboard': (context) => const PreviewDashboardPage(),
        '/walkingWorkout': (context) => const WalkingWorkoutPage(),
        '/changePassword': (context) => ChangePasswordPage(),
        '/signUpDescription': (context) => const SignUpDescriptionPage(),
        '/signUpUserInfo': (context) => const SignUpUserInfoPage(),
        '/signUpDiagnostics': (context) => const SignUpDiagnosticsPage(),
      },
      home: Consumer<UserDataProvider>(
        builder: (context, userDataProvider, child) {
          final userData = userDataProvider.userData;

          if (userData != null) {
            // UserData exists, check if password has changed
            if (userData.passwordChanged == "1") {
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
                      if (sixMinuteEnabled!.counter > 0) {
                        Future.delayed(Duration.zero, () async {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Welcome Back, ${userData.fname}')),
                          );
                          final prefs = await SharedPreferences.getInstance();
                          List<String> offlineData =
                              prefs.getStringList('offlineWalkingData') ?? [];

                          if (offlineData.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: const [
                                    CircularProgressIndicator(),
                                    SizedBox(width: 10),
                                    Text('Syncing offline walking data...'),
                                  ],
                                ),
                              ),
                            );

                            // Sync the offline data
                            await userDataProvider.syncWalkingData();
                          }
                        });
                        return const MainDashboardPage();
                      }
                    } else {
                      return const AllowPermissionsPage();
                    }
                  }
                  return const SignInPage();
                },
              );
            } else {
              return const SignInNewUserPage();
            }
          } else {
            return const SignInPage();
          }
        },
      ),
    );
  }
}
