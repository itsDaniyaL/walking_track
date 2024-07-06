import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:walking_track/screens/allow_permissions.dart';
import 'package:walking_track/screens/sign_in.dart';
import 'package:walking_track/screens/sign_up_diagnostics.dart';
import 'package:walking_track/shared/filled_button.dart';
import 'package:walking_track/shared/text_field.dart';
import 'package:walking_track/shared/toggle_button.dart';

class SignInNewUserPage extends StatefulWidget {
  const SignInNewUserPage({super.key});

  @override
  State<SignInNewUserPage> createState() => _SignInNewUserPageState();
}

class _SignInNewUserPageState extends State<SignInNewUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New/Returning User',
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
              width: MediaQuery.of(context).size.width * 0.85,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Please provide contact info")),
                    CustomTextField(
                      hintText: "Cell Phone Number",
                      onChanged: (text) {
                        // setState(() {
                        //   emailText = text;
                        // });
                      },
                      prefixIcon: Icons.call_outlined,
                    ),
                    CustomTextField(
                      hintText: "Email",
                      onChanged: (text) {
                        // setState(() {
                        //   emailText = text;
                        // });
                      },
                      prefixIcon: Icons.email_outlined,
                    ),
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Change Password")),
                    CustomTextField(
                      hintText: "Password",
                      onChanged: (text) {
                        // setState(() {
                        //   emailText = text;
                        // });
                      },
                      prefixIcon: Icons.lock_outline,
                      suffixIcon: Icons.visibility_outlined,
                      isPassword: true,
                    ),
                    CustomTextField(
                      hintText: "Confirm Password",
                      onChanged: (text) {
                        // setState(() {
                        //   emailText = text;
                        // });
                      },
                      prefixIcon: Icons.lock_outline,
                      suffixIcon: Icons.visibility_outlined,
                      isPassword: true,
                    ),
                  ],
                ),
              )),
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
                          builder: (context) => const AllowPermissionsPage()),
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
