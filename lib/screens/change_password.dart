import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walking_track/providers/user_data_provider.dart';
import 'package:walking_track/screens/sign_in.dart';
import 'package:walking_track/shared/filled_button.dart';
import 'package:walking_track/shared/text_field.dart';
import 'package:walking_track/utils/validators.dart';

import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  String passwordText = '';
  String confirmPasswordText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child: Column(
            children: [
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
              SizedBox(height: 16),
              CustomTextField(
                hintText: "Confirm Password",
                onChanged: (text) {
                  setState(() {
                    confirmPasswordText = text;
                  });
                },
                prefixIcon: Icons.lock_outline,
                suffixIcon: Icons.visibility_outlined,
                isPassword: true,
                validator: (value) {
                  if (value != passwordText) {
                    return 'Passwords do not match';
                  }
                  return Validators.validatePasswordField(value);
                },
              ),
              SizedBox(height: 32),
              CustomFilledButton(
                onPressed: () async {
                  if (Validators.validatePasswordField(passwordText) == null &&
                      passwordText == confirmPasswordText) {
                    final bool changeStatus =
                        await Provider.of<UserDataProvider>(context)
                            .changePassword(passwordText);
                    if (changeStatus) {
                      Provider.of<UserDataProvider>(context).clearAccount();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInPage()),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Password Change Failed'),
                            content: const Text('Unknown error occurred'),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                },
                textColor: Theme.of(context).secondaryHeaderColor,
                buttonColor: Theme.of(context).primaryColorLight,
                child: Text('Change Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
