import 'package:flutter/material.dart';
import 'package:walking_track/models/sign_up_data.dart';
import 'package:walking_track/services/api_service.dart';

class SignUpProvider with ChangeNotifier {
  SignUpData _signUpData = SignUpData();

  SignUpData get signUpData => _signUpData;

  void updateUserInfo(List<String> userInfo) {
    _signUpData.fname = userInfo[0];
    _signUpData.lname = userInfo[1];
    _signUpData.phone = userInfo[2];
    _signUpData.email = userInfo[3];
    _signUpData.city = userInfo[4];
    _signUpData.state = userInfo[5];
    _signUpData.province = userInfo[6];
    _signUpData.country = userInfo[7];
    _signUpData.postalCode = userInfo[8];
    notifyListeners();
  }

  void updateUserDiagnostics(List<String> userDiagnostics) {
    _signUpData.diagnosed = userDiagnostics[0];
    _signUpData.vSpecialist = userDiagnostics[1];
    _signUpData.vFname = userDiagnostics[2];
    _signUpData.vLname = userDiagnostics[3];
    _signUpData.medicalClear = userDiagnostics[4];
    notifyListeners();
  }

  Future<bool> signUp() async {
    final apiService = ApiService();

    try {
      final response = await apiService.signUp(_signUpData.toJson());

      if (response.statusCode == 200) {
        // Handle successful sign up
        debugPrint(response.data);
        debugPrint('Sign up successful');
        return true;
      } else {
        // Handle sign up error
        debugPrint('Sign up failed: ${response.statusCode} -${response.data}');
        return false;
      }
    } catch (e) {
      // Handle connection error
      debugPrint('Sign up error: $e');
    }
    return false;
  }
}
