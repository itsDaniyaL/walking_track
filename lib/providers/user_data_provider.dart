import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walking_track/models/preview_data.dart';
import 'package:walking_track/models/six_minute_enabled.dart';
import 'dart:convert';
import 'package:walking_track/models/user_data.dart';
import 'package:walking_track/services/api_service.dart';

class UserDataProvider with ChangeNotifier {
  UserData? _userData;
  PreviewData? _previewData;
  SixMinuteWalkingData? _sixMinuteWalkingData;

  UserData? get userData => _userData;
  PreviewData? get previewData => _previewData;
  SixMinuteWalkingData? get sixMinuteWalkingEnabled => _sixMinuteWalkingData;

  String? get passwordChanged => _userData?.passwordChanged;

  String? get phone => _userData?.phone;

  Future<bool> signIn(String username, String password) async {
    try {
      final apiService = ApiService();
      final response = await apiService.signIn(username, password);

      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.data}');

      if (response.statusCode == 200) {
        final jsonResponse = response.data;

        if (jsonResponse['success'] == true) {
          final data = jsonResponse['data'];
          // debugPrint("data ${data.}");
          if (data != null) {
            _userData = UserData.fromJson(data);
            debugPrint("_userData ${_userData?.passwordChanged}");
            await saveUserData(_userData!);
            final sixMinuteEnabledResponse =
                await apiService.test6MinWalkingData(username);
            await saveSixMinuteWalkingData(SixMinuteWalkingData.fromJson(
                sixMinuteEnabledResponse.data['data']));
            // notifyListeners();
            return true;
          }
        } else {
          // Handle failure case
          debugPrint('Sign in failed');
        }
      } else {
        // Handle HTTP error
        debugPrint('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exception
      clearAccount();
      debugPrint('Sign in error: $e');
    }
    return false;
  }

  Future<void> saveSixMinuteWalkingData(SixMinuteWalkingData data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data.toJson());
    await prefs.setString('sixMinuteWalkingData', jsonString);
    debugPrint('SixMinuteWalkingData saved: $jsonString');
  }

  Future<void> saveUserData(UserData userData) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(userData.toJson());
    await prefs.setString('userData', jsonString);
    debugPrint('UserData saved: $jsonString');
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.get('userData');
    if (jsonString != null) {
      final jsonMap = jsonDecode(jsonString as String);
      _userData = UserData.fromJson(jsonMap);
      debugPrint("UserData ${_userData?.fname}");
      // notifyListeners();
    }
  }

  Future<void> loadSixMinuteWalkingData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('sixMinuteWalkingData');
    if (jsonString != null) {
      final jsonMap = jsonDecode(jsonString);
      _sixMinuteWalkingData = SixMinuteWalkingData.fromJson(jsonMap);
    }
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
      gPhone: '',
      gEmail: '',
    );
    _clearUserDataFromPreferences();
    return true;
  }

  Future<void> _clearUserDataFromPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
  }

  Future<bool> closeAccount() async {
    final apiService = ApiService();
    final userName = phone;
    debugPrint("userName $userName");
    if (userName != null) {
      final response = await apiService.closeAccount(userName);
      if (response.statusCode == 200) {
        final jsonResponse = response.data;

        if (jsonResponse['success'] == true) {
          return true;
        }
      }
    }
    return false;
  }

  Future<bool> changePassword(password) async {
    final apiService = ApiService();
    final userName = phone;
    if (userName != null) {
      final response = await apiService.changePassword(userName, password);
      if (response.statusCode == 200) {
        final jsonResponse = response.data;

        if (jsonResponse['success'] == true) {
          return true;
        }
      }
    }
    return false;
  }

  // Future<bool> newUserInfo(
  //     String password, String gPhone, String gEmail) async {
  //   final changePasswordStatus = await changePassword(password);
  //   final addSecondaryDayaStatus = await addSecondaryData(gPhone, gEmail);
  //   return changePasswordStatus && addSecondaryDayaStatus;
  // }

  // Future<bool> addSecondaryData(String gPhone, String gEmail) async {
  //   final apiService = ApiService();
  //   final userName = phone;
  //   if (userName != null) {
  //     final response =
  //         await apiService.addSecondaryData(userName, gPhone, gEmail);
  //     if (response.statusCode == 200) {
  //       final jsonResponse = response.data;
  //       if (jsonResponse['success'] == true) {
  //         return true;
  //       }
  //     }
  //   }
  //   return false;
  // }

  Future<bool> forgotPassword(username) async {
    final apiService = ApiService();
    final response = await apiService.forgotPassword(username);
    if (response.statusCode == 200) {
      final jsonResponse = response.data;

      if (jsonResponse['success'] == true) {
        return true;
      }
    }
    return false;
  }

  Future<bool> sixMinuteWalkingData(Map<String, String> data) async {
    final apiService = ApiService();
    final response = await apiService.log6MinWalkingData(data);
    if (response.statusCode == 200) {
      final jsonResponse = response.data;

      if (jsonResponse['success'] == true) {
        return true;
      }
    }
    return false;
  }

  Future<bool> walkingData(Map<String, String> data) async {
    final apiService = ApiService();
    try {
      if (await isConnected()) {
        final response = await apiService.logWalkingData(data);
        if (response.statusCode == 200) {
          final jsonResponse = response.data;

          if (jsonResponse['success'] == true) {
            return true;
          }
        }
        return false;
      } else {
        await saveWalkingDataLocally(data);
        return true;
      }
    } catch (e) {
      debugPrint("Error: $e");
      return false;
    }
  }

  Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> saveWalkingDataLocally(Map<String, String> data) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> offlineData = prefs.getStringList('offlineWalkingData') ?? [];
    offlineData.add(jsonEncode(data));
    await prefs.setStringList('offlineWalkingData', offlineData);
  }

  Future<void> syncWalkingData() async {
    if (await isConnected()) {
      final prefs = await SharedPreferences.getInstance();
      List<String> offlineData =
          prefs.getStringList('offlineWalkingData') ?? [];
      List<String> successfullySyncedData = [];

      for (String data in offlineData) {
        Map<String, String> localWalkingData =
            Map<String, String>.from(jsonDecode(data));
        bool success = await walkingData(localWalkingData);
        if (success) {
          successfullySyncedData.add(data);
        }
      }

      offlineData.removeWhere((data) => successfullySyncedData.contains(data));

      await prefs.setStringList('offlineWalkingData', offlineData);
    } else {
      debugPrint("No internet connection, cannot sync data.");
    }
  }

  Future<bool> reviewWalkingData() async {
    final apiService = ApiService();

    final String? username = phone;
    final endDate = DateTime.now();
    final startDate = endDate.subtract(const Duration(hours: 24));
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final formattedStartDate = formatter.format(startDate);
    final formattedEndDate = formatter.format(endDate);
    try {
      if (username != null) {
        final response = await apiService.reviewWalkingData(
          username,
          formattedStartDate,
          formattedEndDate,
        );
        if (response.statusCode == 200) {
          final jsonResponse = response.data;

          if (jsonResponse['success'] == true) {
            final data = jsonResponse['data'][0];
            _previewData = PreviewData.fromJson(data);
            notifyListeners();
            return true;
          }
        }
      }
    } catch (e) {
      debugPrint('Exception: $e');
    }
    return false;
  }
}
