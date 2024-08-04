import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://padwalk.org/api/user';
  final clientId = dotenv.env['CLIENT_ID'];
  final clientSecret = dotenv.env['CLIENT_SECRET'];
  final apiKey = dotenv.env['API_KEY'];
  final token = dotenv.env['TOKEN'];

  Future<String?> getToken() async {
    // Logic to get the token from the API
    // final uri = Uri.parse(
    //     '$baseUrl/token.php?client_id=$clientId&client_secret=$clientSecret');

    // final response = await http.post(uri);

    // if (response.statusCode == 200) {
    //   final jsonResponse = jsonDecode(response.body);
    //   return jsonResponse['token'];
    // } else {
    //   // Print error response for debugging
    //   print('Token request failed with status: ${response.statusCode}');
    //   print('Token request response body: ${response.body}');
    //   return null;
    // }
    return token;
  }

  Future<Response> signIn(String username, String password) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception("Failed to get token");
      }

      final dio = Dio();
      final uri = '$baseUrl/login.php';
      final headers = {
        'Api-Key': apiKey!,
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      };

      final body = jsonEncode({'username': username, 'password': password});

      await Future.delayed(Duration(seconds: 5));

      print('Request Headers: $headers');
      print('Request Body: $body');

      final response = await dio.post(
        uri,
        options: Options(
          headers: headers,
          preserveHeaderCase: true,
        ),
        data: body,
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');

      return response;
    } on DioException catch (e) {
      print('Error: ${e.response?.statusCode} ${e.response?.data}');
      throw e;
    } catch (e) {
      print('Exception: $e');
      rethrow;
    }
  }

  Future<Response> signUp(Map<String, String> userDetails) async {
    final token = await getToken();
    if (token == null) {
      throw Exception("Token is null");
    }
    print('token is: $token');

    final dio = Dio();
    final uri = '$baseUrl/create-user.php';
    final headers = {
      // 'Api-Key': apiKey!,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    print(headers);
    final body = jsonEncode(userDetails);
    print(body);

    try {
      return await dio.post(
        uri,
        options: Options(headers: headers, preserveHeaderCase: true),
        data: body,
      );
    } on DioException catch (e) {
      // Handle Dio error here
      print('Error: ${e.response?.statusCode} ${e.response?.data}');
      throw e;
    }
  }

  Future<Response> forgotPassword(String username) async {
    final token = await getToken();
    if (token == null) {
      throw Exception("Token is null");
    }

    final dio = Dio();
    final uri = '$baseUrl/user-forgot-password.php';
    final headers = {
      'Api-Key': apiKey!,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    final body = jsonEncode({'username': username});

    try {
      return await dio.post(
        uri,
        options: Options(
          headers: headers,
          preserveHeaderCase: true,
        ),
        data: body,
      );
    } on DioException catch (e) {
      print('Error: ${e.response?.statusCode} ${e.response?.data}');
      throw e;
    }
  }

  Future<Response> changePassword(String username, String newPassword) async {
    final token = await getToken();
    if (token == null) {
      throw Exception("Token is null");
    }

    final dio = Dio();
    final uri = '$baseUrl/change-password.php';
    final headers = {
      'Api-Key': apiKey!,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    final body = jsonEncode({'username': username, 'password': newPassword});

    try {
      return await dio.post(
        uri,
        options: Options(
          headers: headers,
          preserveHeaderCase: true,
        ),
        data: body,
      );
    } on DioException catch (e) {
      print('Error: ${e.response?.statusCode} ${e.response?.data}');
      throw e;
    }
  }

  Future<Response> addSecondaryData(
      String username, String gPhone, String gEmail) async {
    final token = await getToken();
    if (token == null) {
      throw Exception("Token is null");
    }

    final dio = Dio();
    final uri = '$baseUrl/update-info.php';
    final headers = {
      'Api-Key': apiKey!,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    final body = jsonEncode(
        {'username': username, 'g_phone': gPhone, 'g_email': gEmail});

    try {
      return await dio.post(
        uri,
        options: Options(
          headers: headers,
          preserveHeaderCase: true,
        ),
        data: body,
      );
    } on DioException catch (e) {
      print('Error: ${e.response?.statusCode} ${e.response?.data}');
      throw e;
    }
  }

  Future<Response> closeAccount(String username) async {
    final token = await getToken();
    if (token == null) {
      throw Exception("Token is null");
    }

    final dio = Dio();
    final uri = '$baseUrl/close-account.php';
    final headers = {
      'Api-Key': apiKey!,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    final body = jsonEncode({'username': username});

    try {
      return await dio.post(
        uri,
        options: Options(
          headers: headers,
          preserveHeaderCase: true,
        ),
        data: body,
      );
    } on DioException catch (e) {
      print('Error: ${e.response?.statusCode} ${e.response?.data}');
      throw e;
    }
  }

  Future<Response> logWalkingData(Map<String, String> walkingData) async {
    final token = await getToken();
    if (token == null) {
      throw Exception("Token is null");
    }

    final dio = Dio();
    final uri = '$baseUrl/log-symptom.php';
    final headers = {
      'Api-Key': apiKey!,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    final body = jsonEncode(walkingData);

    try {
      return await dio.post(
        uri,
        options: Options(
          headers: headers,
          preserveHeaderCase: true,
        ),
        data: body,
      );
    } on DioException catch (e) {
      print('Error: ${e.response?.statusCode} ${e.response?.data}');
      throw e;
    }
  }

  Future<Response> log6MinWalkingData(Map<String, String> walkingData) async {
    final token = await getToken();
    if (token == null) {
      throw Exception("Token is null");
    }

    final dio = Dio();
    final uri = '$baseUrl/6-min.php';
    final headers = {
      'Api-Key': apiKey!,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    final body = jsonEncode(walkingData);
    print('$walkingData');
    try {
      return await dio.post(
        uri,
        options: Options(
          headers: headers,
          preserveHeaderCase: true,
        ),
        data: body,
      );
    } on DioException catch (e) {
      print('Error: ${e.response?.statusCode} ${e.response?.data}');
      throw e;
    }
  }

  Future<Response> test6MinWalkingData(String username) async {
    final token = await getToken();
    if (token == null) {
      throw Exception("Token is null");
    }

    final dio = Dio();
    final uri = '$baseUrl/6-min-test.php';
    final headers = {
      'Api-Key': apiKey!,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    final body = jsonEncode({'username': username});

    try {
      return await dio.post(
        uri,
        options: Options(
          headers: headers,
          preserveHeaderCase: true,
        ),
        data: body,
      );
    } on DioException catch (e) {
      print('Error: ${e.response?.statusCode} ${e.response?.data}');
      throw e;
    }
  }

  Future<Response> reviewWalkingData(
      String username, String startDate, String endDate) async {
    final token = await getToken();
    if (token == null) {
      throw Exception("Token is null");
    }

    final dio = Dio();
    final uri =
        '$baseUrl/walking-data.php?username=$username&start_date=$startDate&end_date=$endDate';
    final headers = {
      'Api-Key': apiKey!,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      return await dio.get(
        uri,
        options: Options(
          headers: headers,
          preserveHeaderCase: true,
        ),
      );
    } on DioException catch (e) {
      print('Error: ${e.response?.statusCode} ${e.response?.data}');
      throw e;
    }
  }
}
