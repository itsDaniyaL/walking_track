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
      final response = await ApiService().signIn(username, password);
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(responseBody);

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
}
