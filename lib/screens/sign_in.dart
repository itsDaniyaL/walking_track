import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:walking_track/screens/sign_in_new_user.dart';
import 'package:walking_track/screens/sign_up_description.dart';
import 'package:walking_track/shared/filled_button.dart';
import 'package:walking_track/shared/text_field.dart';
import 'package:walking_track/shared/toggle_button.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.40,
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
                      // setState(() {
                      //   emailText = text;
                      // });
                    },
                    prefixIcon: Icons.person_2_outlined,
                  ),
                  CustomTextField(
                    hintText: "Password",
                    onChanged: (text) {
                      // setState(() {
                      //   passwordText = text;
                      // });
                    },
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: Icons.visibility_outlined,
                    isPassword: true,
                  ),
                  // if (selectedMode == "sign_up")
                  //   CustomTextField(
                  //     hintText: "Confirm Password",
                  //     onChanged: (text) {
                  //       setState(() {
                  //         confirmPasswordText = text;
                  //       });
                  //     },
                  //     prefixIcon: Icons.lock,
                  //     suffixIcon: Icons.visibility,
                  //     isPassword: true,
                  //   ),
                ],
              )),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.20,
            width: MediaQuery.of(context).size.width * 0.75,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomFilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInNewUserPage()),
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInPage()),
                    );
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
            height: MediaQuery.of(context).size.height * 0.10,
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
                          builder: (context) => const SignUpDescriptionPage()),
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
      )),
    );
  }
}
