import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:walking_track/models/user_data.dart';
import 'package:walking_track/services/api_service.dart';

class UserDataProvider with ChangeNotifier {
  UserData? _userData;

  UserData? get userData => _userData;

  String? get passwordChanged => _userData?.passwordChanged;

  String? get phone => _userData?.phone;

  Future<void> signIn(String username, String password) async {
    try {
      final apiService = ApiService();
      final response = await apiService.signIn(username, password);

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['success'] == true) {
          final data = jsonResponse['data'];
          if (data != null) {
            _userData = UserData.fromJson(data);
            print(_userData);
            await saveUserData(_userData!);
            notifyListeners();
          }
        } else {
          // Handle failure case
          print('Sign in failed');
        }
      } else {
        // Handle HTTP error
        print('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exception
      print('Sign in error: $e');
    }
  }

  Future<void> saveUserData(UserData userData) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(userData.toJson());
    await prefs.setString('userData', jsonString);
    print('UserData saved: $jsonString');
  }

  Future<UserData?> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('userData');
    if (jsonString != null) {
      final jsonMap = jsonDecode(jsonString);
      _userData = UserData.fromJson(jsonMap);
      notifyListeners();
      print('UserData loaded: $jsonMap');
      return _userData;
    }
    return null;
  }

  Future<bool> isPasswordChanged() async {
    await loadUserData();
    return _userData?.passwordChanged == '1';
  }

  bool clearAccount() {
    _userData = UserData(
      fname: '',
      lname: '',
      phone: '',
      email: '',
      state: '',
      province: '',
      country: '',
      diagnosed: '',
      vSpecialist: '',
      vFname: '',
      vLname: '',
      medicalClear: '',
      active: '',
      passwordChanged: '',
      city: '',
      postalCode: '',
    );
    return true;
  }

  Future<bool> closeAccount() async {
    final apiService = ApiService();
    await apiService.closeAccount(_userData!.phone);
    return true;
  }

  Future<bool> changePassword(password) async {
    final apiService = ApiService();
    final userName = passwordChanged;

    if (userName != null) {
      final response = await apiService.changePassword(userName, password);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['success'] == true) {
          return true;
        }
      }
    }
    return false;
  }

  Future<bool> forgotPassword(username) async {
    final apiService = ApiService();
    await apiService.forgotPassword(username);
    return true;
  }
}
