import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walking_track/providers/user_data_provider.dart';
import 'package:walking_track/screens/allow_permissions.dart';
import 'package:walking_track/screens/sign_in_new_user.dart';
import 'package:walking_track/screens/sign_up_description.dart';
import 'package:walking_track/shared/filled_button.dart';
import 'package:walking_track/shared/notificationservice.dart';
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
  late bool loading = false;

  bool validateForm() {
    return Validators.validatorUserName(userNameText) &&
        Validators.validatorPassword(passwordText);
  }

  bool checkNewUser(BuildContext context) {
    try {
      final userDataProvider =
          Provider.of<UserDataProvider>(context, listen: false);
      final passwordChanged = userDataProvider.passwordChanged;
      debugPrint(passwordChanged);
      return passwordChanged == "1";
    } catch (e) {
      debugPrint('Error during sign in: $e');
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
                    onPressed: validateForm() && !loading
                        ? () async {
                            setState(() {
                              loading = true;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Loading...'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                            bool isConnected =
                                await checkInternetConnection(context);
                            if (!isConnected) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      const Text('Turn on internet connection'),
                                  duration: const Duration(seconds: 4),
                                ),
                              );
                              setState(() {
                                loading = false;
                              });
                              return;
                            }

                            final checkStatus = await context
                                .read<UserDataProvider>()
                                .signIn(userNameText, passwordText);
                            if (checkStatus) {
                              await NotificationService().showDailyAtSevenAM(
                                  0,
                                  'Daily Reminder',
                                  'This is your daily reminder to track your steps');
                              NotificationService().showNotification(
                                  1,
                                  "Reminder Alert",
                                  "You will be receiving daily reminder at 7 A.M");
                              final bool isNewUser = checkNewUser(context);
                              if (!isNewUser) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignInNewUserPage(),
                                      fullscreenDialog: true),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AllowPermissionsPage(),
                                      fullscreenDialog: true),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                      'Sign In Failed. Please check Username and Password'),
                                  duration: const Duration(seconds: 4),
                                ),
                              );
                            }
                            setState(() {
                              loading = false;
                            });
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
                      Navigator.pushNamed(context, '/signIn');
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
                      Navigator.pushNamed(context, '/signUpDescription');
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
    late bool loading = false;

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
              onPressed: !loading
                  ? () async {
                      setState(() {
                        loading = true;
                      });
                      final bool changeStatus;
                      changeStatus = await context
                          .read<UserDataProvider>()
                          .forgotPassword(usernameText);
                      Navigator.of(context).pop();
                      if (changeStatus) {
                        _showSuccessDialog(context);
                      }
                      setState(() {
                        loading = false;
                      });
                    }
                  : null,
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

  Future<bool> checkInternetConnection(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('No Internet Connection'),
          content: Text('Please ensure you are connected to the internet.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return false;
    }
    return true;
  }
}
