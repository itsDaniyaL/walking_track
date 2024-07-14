import 'package:flutter/material.dart';
import 'package:walking_track/screens/allow_permissions.dart';
import 'package:walking_track/shared/filled_button.dart';
import 'package:walking_track/shared/text_field.dart';
import 'package:walking_track/utils/validators.dart';

class SignInNewUserPage extends StatefulWidget {
  const SignInNewUserPage({super.key});

  @override
  State<SignInNewUserPage> createState() => _SignInNewUserPageState();
}

class _SignInNewUserPageState extends State<SignInNewUserPage> {
  late String cellPhoneNumber = "",
      email = "",
      password = "",
      confirmPassword = "";

  bool validateForm() {
    return true;
    // Validators.validatorCellPhoneNumber(cellPhoneNumber) &&
    // Validators.validatorEmail(email) &&
    //     Validators.validatorPassword(password) &&
    //     Validators.validatorPassword(confirmPassword) &&
    //     (password == confirmPassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.70,
                width: MediaQuery.of(context).size.width * 0.85,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
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
                          validator: Validators.validateCellPhoneField,
                        ),
                        CustomTextField(
                          hintText: "Email",
                          onChanged: (text) {
                            // setState(() {
                            //   emailText = text;
                            // });
                          },
                          prefixIcon: Icons.email_outlined,
                          validator: Validators.validateEmailField,
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
                          validator: Validators.validatePasswordField,
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
                          validator: Validators.validatePasswordField,
                        ),
                      ],
                    ),
                  ),
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width * 0.75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomFilledButton(
                    onPressed: validateForm()
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AllowPermissionsPage()),
                            );
                          }
                        : null,
                    textColor: Theme.of(context).secondaryHeaderColor,
                    buttonColor: Theme.of(context).primaryColorLight,
                    child: const Icon(Icons.arrow_forward_ios_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
