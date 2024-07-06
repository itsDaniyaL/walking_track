import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:walking_track/screens/sign_in.dart';
import 'package:walking_track/screens/sign_up_diagnostics.dart';
import 'package:walking_track/shared/filled_button.dart';
import 'package:walking_track/shared/text_field.dart';
import 'package:walking_track/shared/toggle_button.dart';

class SignUpUserInfoPage extends StatefulWidget {
  const SignUpUserInfoPage({super.key});

  @override
  State<SignUpUserInfoPage> createState() => _SignUpUserInfoPageState();
}

class _SignUpUserInfoPageState extends State<SignUpUserInfoPage> {
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomTextField(
                      hintText: "First Name",
                      onChanged: (text) {
                        // setState(() {
                        //   emailText = text;
                        // });
                      },
                      prefixIcon: Icons.person_2_outlined,
                    ),
                    CustomTextField(
                      hintText: "Last Name",
                      onChanged: (text) {
                        // setState(() {
                        //   emailText = text;
                        // });
                      },
                      prefixIcon: Icons.person_2_outlined,
                    ),
                    CustomTextField(
                        hintText: "Cell Phone Number",
                        onChanged: (text) {
                          // setState(() {
                          //   emailText = text;
                          // });
                        },
                        prefixIcon: Icons.call_outlined),
                    CustomTextField(
                      hintText: "Email",
                      onChanged: (text) {
                        // setState(() {
                        //   emailText = text;
                        // });
                      },
                      prefixIcon: Icons.email_outlined,
                    ),
                    CustomTextField(
                      hintText: "City",
                      onChanged: (text) {
                        // setState(() {
                        //   emailText = text;
                        // });
                      },
                    ),
                    CustomTextField(
                      hintText: "State",
                      onChanged: (text) {
                        // setState(() {
                        //   emailText = text;
                        // });
                      },
                    ),
                    CustomTextField(
                      hintText: "Province",
                      onChanged: (text) {
                        // setState(() {
                        //   emailText = text;
                        // });
                      },
                    ),
                    CustomTextField(
                      hintText: "Country",
                      onChanged: (text) {
                        // setState(() {
                        //   emailText = text;
                        // });
                      },
                    ),
                    CustomTextField(
                      hintText: "Postal Code",
                      onChanged: (text) {
                        // setState(() {
                        //   emailText = text;
                        // });
                      },
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
                          builder: (context) => const SignUpDiagnosticsPage()),
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
