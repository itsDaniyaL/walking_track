import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:walking_track/screens/sign_in.dart';
import 'package:walking_track/shared/filled_button.dart';
import 'package:walking_track/shared/switch_question.dart';
import 'package:walking_track/shared/text_field.dart';
import 'package:walking_track/shared/toggle_button.dart';
import 'package:walking_track/utils/validators.dart';

class SignUpDiagnosticsPage extends StatefulWidget {
  const SignUpDiagnosticsPage({super.key});

  @override
  State<SignUpDiagnosticsPage> createState() => _SignUpDiagnosticsPageState();
}

class _SignUpDiagnosticsPageState extends State<SignUpDiagnosticsPage> {
  bool padYN = false;
  bool vascularSpecialist = false;
  bool clearForWalking = false;

  String specialistFirstName = "";
  String specialistLastName = "";

  bool validateForm() {
    if (vascularSpecialist) {
      return specialistFirstName.isNotEmpty && specialistLastName.isNotEmpty;
    }
    return true;
  }

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
              height: MediaQuery.of(context).size.height * 0.65,
              width: MediaQuery.of(context).size.width * 0.75,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SwitchQuestion(
                        question: "Have you been diagnosed with PAD Y or N?",
                        switchState: padYN,
                        onChanged: (bool value) {
                          setState(() {
                            padYN = value;
                          });
                        }),
                    SwitchQuestion(
                        question: "Do you have a vascular specialist Y or N?",
                        switchState: vascularSpecialist,
                        onChanged: (bool value) {
                          setState(() {
                            vascularSpecialist = value;
                          });
                        }),
                    if (vascularSpecialist)
                      Column(
                        children: [
                          CustomTextField(
                            hintText: "Vascular Specialist’s First Name",
                            onChanged: (text) {
                              setState(() {
                                specialistFirstName = text;
                              });
                            },
                            prefixIcon: Icons.person_2_outlined,
                          ),
                          CustomTextField(
                            hintText: "Vascular Specialist’s Last Name",
                            onChanged: (text) {
                              setState(() {
                                specialistLastName = text;
                              });
                            },
                            prefixIcon: Icons.person_2_outlined,
                          ),
                          SwitchQuestion(
                              question:
                                  "Are you medically cleared to do a walking program?",
                              switchState: clearForWalking,
                              onChanged: (bool value) {
                                setState(() {
                                  clearForWalking = value;
                                });
                              }),
                        ],
                      ),
                  ],
                ),
              )),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.75,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomFilledButton(
                  onPressed: validateForm()
                      ? () {
                          _dialogBuilder(context);
                        }
                      : null,
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

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          title: const Text(
            'Note',
            style: TextStyle(color: Colors.black),
          ),
          content: const Text(
              "We will have a PAD navigator get in touch with you in the next 24 hours via phone or email to get you onboarded for this free walking program."),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                  foregroundColor: Colors.white),
              child: const Text(
                'Continue',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInPage()),
                );
              },
            ),
          ],
        );
      },
    ).then((value) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignInPage()),
        ));
  }
}
