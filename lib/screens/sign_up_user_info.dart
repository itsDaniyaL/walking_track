import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walking_track/providers/sign_up_provider.dart';
import 'package:walking_track/screens/sign_in.dart';
import 'package:walking_track/screens/sign_up_diagnostics.dart';
import 'package:walking_track/shared/filled_button.dart';
import 'package:walking_track/shared/text_field.dart';
import 'package:walking_track/utils/validators.dart';

class SignUpUserInfoPage extends StatefulWidget {
  const SignUpUserInfoPage({super.key});

  @override
  State<SignUpUserInfoPage> createState() => _SignUpUserInfoPageState();
}

class _SignUpUserInfoPageState extends State<SignUpUserInfoPage> {
  late String firstName = "",
      lastName = "",
      cellPhoneNumber = "",
      city = "",
      email = "",
      state = "",
      province = "",
      country = "",
      postalCode = "";

  bool validateForm() {
    return Validators.validateNameField(firstName, "First Name") == null &&
        Validators.validateNameField(lastName, "Last Name") == null &&
        Validators.validateCellPhoneField(cellPhoneNumber) == null &&
        Validators.validateEmailField(email) == null &&
        Validators.validateGenericFields(city, "City") == null &&
        Validators.validateGenericFields(state, "State") == null &&
        Validators.validateGenericFields(province, "Province") == null &&
        Validators.validateGenericFields(country, "Country") == null &&
        Validators.validateGenericFields(postalCode, "Postal Code") == null;
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
          child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomTextField(
                        hintText: "First Name",
                        onChanged: (text) {
                          setState(() {
                            firstName = text;
                          });
                        },
                        prefixIcon: Icons.person_2_outlined,
                        validator: (value) =>
                            Validators.validateNameField(value!, "First Name"),
                      ),
                      CustomTextField(
                        hintText: "Last Name",
                        onChanged: (text) {
                          setState(() {
                            lastName = text;
                          });
                        },
                        prefixIcon: Icons.person_2_outlined,
                        validator: (value) =>
                            Validators.validateNameField(value!, "Last Name"),
                      ),
                      CustomTextField(
                        hintText: "Cell Phone Number",
                        onChanged: (text) {
                          setState(() {
                            cellPhoneNumber = text;
                          });
                        },
                        prefixIcon: Icons.call_outlined,
                        validator: Validators.validateCellPhoneField,
                        maxLength: 11,
                      ),
                      CustomTextField(
                        hintText: "Email",
                        onChanged: (text) {
                          setState(() {
                            email = text;
                          });
                        },
                        prefixIcon: Icons.email_outlined,
                        validator: Validators.validateEmailField,
                      ),
                      CustomTextField(
                        hintText: "City",
                        onChanged: (text) {
                          setState(() {
                            city = text;
                          });
                        },
                        prefixIcon: Icons.location_city_outlined,
                        validator: (value) =>
                            Validators.validateGenericFields(value!, "City"),
                      ),
                      CustomTextField(
                        hintText: "State",
                        onChanged: (text) {
                          setState(() {
                            state = text;
                          });
                        },
                        prefixIcon: Icons.location_city_outlined,
                        validator: (value) =>
                            Validators.validateGenericFields(value!, "State"),
                      ),
                      CustomTextField(
                        hintText: "Province",
                        onChanged: (text) {
                          setState(() {
                            province = text;
                          });
                        },
                        prefixIcon: Icons.location_city_outlined,
                        validator: (value) => Validators.validateGenericFields(
                            value!, "Province"),
                      ),
                      CustomTextField(
                        hintText: "Country",
                        onChanged: (text) {
                          setState(() {
                            country = text;
                          });
                        },
                        prefixIcon: Icons.location_city_outlined,
                        validator: (value) =>
                            Validators.validateGenericFields(value!, "Country"),
                      ),
                      CustomTextField(
                        hintText: "Postal Code",
                        onChanged: (text) {
                          setState(() {
                            postalCode = text;
                          });
                        },
                        prefixIcon: Icons.email_outlined,
                        validator: (value) => Validators.validateGenericFields(
                            value!, "Postal Code"),
                      ),
                      CustomFilledButton(
                        onPressed: validateForm()
                            ? () {
                                final userInfo = [
                                  firstName,
                                  lastName,
                                  cellPhoneNumber,
                                  email,
                                  city,
                                  state,
                                  province,
                                  country,
                                  postalCode,
                                ];
                                context
                                    .read<SignUpProvider>()
                                    .updateUserInfo(userInfo);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpDiagnosticsPage()),
                                );
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInPage()),
                      );
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
        ),
      )),
    );
  }
}
