import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:walking_track/screens/sign_in.dart';
import 'package:walking_track/screens/sign_up_user_info.dart';
import 'package:walking_track/shared/filled_button.dart';
import 'package:walking_track/shared/text_field.dart';
import 'package:walking_track/shared/toggle_button.dart';

class SignUpDescriptionPage extends StatefulWidget {
  const SignUpDescriptionPage({super.key});

  @override
  State<SignUpDescriptionPage> createState() => _SignUpDescriptionPageState();
}

class _SignUpDescriptionPageState extends State<SignUpDescriptionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New User',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
          child: Column(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.70,
              width: MediaQuery.of(context).size.width * 0.75,
              child: const Text(
                  "Welcome to the free My Steps Walking Program, designed specifically to help PAD patients track their progress.\nPlease fill out the request form to join the program and a PAD Navigator will be in touch through phone or email to complete the process so we can send you a username and password")),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.75,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomFilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpUserInfoPage()),
                    );
                  },
                  // validateForm()
                  //     ? () {
                  //         authenticateUser();
                  //       }
                  //     : null,
                  textColor: Theme.of(context).secondaryHeaderColor,
                  buttonColor: Theme.of(context).primaryColorLight,
                  child: const Icon(Icons.arrow_forward_ios_rounded),
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
                const Text(
                  "Already a user?",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                CustomFilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInPage()),
                    );
                  },
                  // validateForm()
                  //     ? () {
                  //         authenticateUser();
                  //       }
                  //     : null,
                  textColor: Theme.of(context).secondaryHeaderColor,
                  buttonColor: const Color(0xFFE1E1E1),
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
