import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walking_track/providers/sign_up_provider.dart';
import 'package:walking_track/screens/sign_in.dart';
import 'package:walking_track/shared/filled_button.dart';
import 'package:walking_track/shared/switch_question.dart';
import 'package:walking_track/shared/text_field.dart';

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
      resizeToAvoidBottomInset: false,
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
              height: MediaQuery.of(context).size.height * 0.75,
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
                    CustomFilledButton(
                      onPressed: validateForm()
                          ? () async {
                              final String tempPadYN = padYN ? '1' : '0';
                              final String tempVascularSpecialist =
                                  vascularSpecialist ? '1' : '0';
                              final String tempClearForWalking =
                                  clearForWalking ? '1' : '0';
                              final userDiagnostics = [
                                tempPadYN,
                                tempVascularSpecialist,
                                specialistFirstName,
                                specialistLastName,
                                tempClearForWalking,
                              ];
                              context
                                  .read<SignUpProvider>()
                                  .updateUserDiagnostics(userDiagnostics);
                              final checkStatus =
                                  await context.read<SignUpProvider>().signUp();
                              if (checkStatus) {
                                _dialogBuilder(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                        'Sign up failed. Please try again later!'),
                                    duration: const Duration(seconds: 4),
                                  ),
                                );
                              }
                            }
                          : null,
                      textColor: Theme.of(context).secondaryHeaderColor,
                      buttonColor: Theme.of(context).primaryColorLight,
                      child: const Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  ],
                ),
              )),
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
                    Navigator.pushNamed(context, '/signIn');
                  },
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
                Navigator.pushNamed(context, '/signIn');
              },
            ),
          ],
        );
      },
    ).then((value) => Navigator.pushNamed(context, '/signIn'));
  }
}
