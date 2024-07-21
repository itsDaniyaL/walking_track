import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:walking_track/providers/user_data_provider.dart';
import 'package:walking_track/screens/allow_permissions.dart';
import 'package:walking_track/screens/preview_dashboard.dart';
import 'package:walking_track/screens/sign_in_new_user.dart';
import 'package:walking_track/screens/sign_up_description.dart';
import 'package:walking_track/screens/six_minute_walking.dart';
import 'package:walking_track/services/api_service.dart';
import 'package:walking_track/shared/filled_button.dart';
import 'package:walking_track/shared/text_field.dart';
import 'package:walking_track/utils/validators.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late String userNameText = "";
  late String passwordText = "";

  bool validateForm() {
    return Validators.validatorUserName(userNameText) &&
        Validators.validatorPassword(passwordText);
  }

  Future<bool> checkNewUser(BuildContext context) async {
    try {
      final userDataProvider =
          Provider.of<UserDataProvider>(context, listen: false);
      print("Checking again");
      await userDataProvider.signIn(userNameText, passwordText);
      final passwordChanged = userDataProvider.passwordChanged;
      print("Checking");
      print(passwordChanged);
      return passwordChanged == "1";
    } catch (e) {
      print('Error during sign in: $e');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Sign In',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
          child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.30,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image(
                    image: const AssetImage("assets/sign_in_page_cover.png"),
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.5),
              ),
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.30,
                child: Column(
                  children: [
                    CustomTextField(
                      hintText: "Username",
                      onChanged: (text) {
                        setState(() {
                          userNameText = text;
                        });
                      },
                      prefixIcon: Icons.person_2_outlined,
                      validator: Validators.validateUsernameField,
                    ),
                    CustomTextField(
                      hintText: "Password",
                      onChanged: (text) {
                        setState(() {
                          passwordText = text;
                        });
                      },
                      prefixIcon: Icons.lock_outline,
                      suffixIcon: Icons.visibility_outlined,
                      isPassword: true,
                      validator: Validators.validatePasswordField,
                    ),
                  ],
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width * 0.75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomFilledButton(
                    onPressed: validateForm()
                        ? () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AllowPermissionsPage()),
                            );
                            return;
                            print("Checking");
                            final bool isNewUser = await checkNewUser(context);

                            PermissionStatus notificationPermission =
                                await Permission.notification.status;
                            PermissionStatus activityPermission =
                                await Permission.activityRecognition.status;
                            if (!isNewUser) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignInNewUserPage()),
                              );
                            } else if (notificationPermission.isGranted &&
                                activityPermission.isGranted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SixMinuteWalkingPage()),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AllowPermissionsPage()),
                              );
                            }
                          }
                        : null,
                    textColor: Theme.of(context).secondaryHeaderColor,
                    buttonColor: Theme.of(context).primaryColorLight,
                    child: const Icon(Icons.arrow_forward_ios_rounded),
                  ),
                  GestureDetector(
                    onTap: () {
                      _forgotPasswordDialogBuilder(context);
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInPage()),
                      );
                    },
                    child: const Text(
                      "Are you a new user?",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  CustomFilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const SignUpDescriptionPage()),
                      );
                    },
                    textColor: Theme.of(context).secondaryHeaderColor,
                    buttonColor: const Color(0xFFE1E1E1),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

  Future<void> _forgotPasswordDialogBuilder(BuildContext context) {
    late String usernameText = '';

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Forgot Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                hintText: "Username",
                onChanged: (text) {
                  setState(() {
                    usernameText = text;
                  });
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            CustomFilledButton(
              onPressed: () async {
                final changeStatus = true;
                // await Provider.of<UserDataProvider>(context)
                //     .forgotPassword(usernameText);
                Navigator.of(context).pop();
                if (changeStatus) {
                  _showSuccessDialog(context);
                }
              },
              textColor: Theme.of(context).secondaryHeaderColor,
              buttonColor: Theme.of(context).primaryColorLight,
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Password reset was successful. Check mail'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
