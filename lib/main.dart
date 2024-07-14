import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:walking_track/screens/sign_in.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      systemNavigationBarColor: Colors.transparent));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        home: AnimatedSplashScreen(
            duration: 1000,
            splash: Image(
                image: const AssetImage("assets/Splash_Image.png"),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height),
            nextScreen: const SignInPage(),
            splashTransition: SplashTransition.fadeTransition,
            // pageTransitionType: PageTransitionType.scale,
            backgroundColor: Colors.white));
  }
}
