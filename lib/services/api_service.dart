import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://padwalk.org/api/user';
  final clientId = dotenv.env['CLIENT_ID'];
  final clientSecret = dotenv.env['CLIENT_SECRET'];
  final apiKey = dotenv.env['API_KEY'];

  Future<String?> getToken() async {
    // Logic to get the token from the API
    final uri = Uri.parse(
        '$baseUrl/token.php?client_id=098zyx765wvu432tsr109qpo876nml543kji210hgf987edc654cba321&client_secret=654lmn321kjih098gfe765dcb432zyx109wvu876tsr543qpo210nml987');

    final response = await http.post(uri);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['token'];
    } else {
      // Print error response for debugging
      print('Token request failed with status: ${response.statusCode}');
      print('Token request response body: ${response.body}');
      return null;
    }
  }

  Future<http.Response> signIn(String username, String password) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception("Failed to get token");
      }
      final uri = Uri.parse('$baseUrl/login.php');
      final headers = {
        'Api-Key': apiKey!,
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      };

      final body = jsonEncode({'username': username, 'password': password});

      await Future.delayed(Duration(seconds: 5));
      final response = await http.post(uri, headers: headers, body: body);

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      return response;
    } catch (e) {
      print('Exception: $e');
      rethrow;
    }
  }

  Future<http.Response> signUp(Map<String, String> userDetails) async {
    final token = await getToken();
    if (token == null) {
      throw Exception("Token is null");
    }

    final uri = Uri.parse('$baseUrl/create-user.php');
    final headers = {
      'Api-Key': apiKey!,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    final body = jsonEncode(userDetails);
    return await http.post(uri, headers: headers, body: body);
  }

  Future<http.Response> forgotPassword(String username) async {
    final token = await getToken();
    if (token == null) {
      throw Exception("Token is null");
    }

    final uri = Uri.parse('$baseUrl/user-forgot-password.php');
    final headers = {'Api-Key': apiKey!, 'Authorization': 'Bearer $token'};
    final body = jsonEncode({'username': username});
    return await http.post(uri, headers: headers, body: body);
  }

  Future<http.Response> changePassword(
      String username, String newPassword) async {
    final token = await getToken();
    if (token == null) {
      throw Exception("Token is null");
    }

    final uri = Uri.parse('$baseUrl/change-password.php');
    final headers = {'Api-Key': apiKey!, 'Authorization': 'Bearer $token'};
    final body =
        jsonEncode({'username': username, 'new_password': newPassword});
    return await http.post(uri, headers: headers, body: body);
  }

  Future<http.Response> closeAccount(String username) async {
    final token = await getToken();
    if (token == null) {
      throw Exception("Token is null");
    }

    final uri = Uri.parse('$baseUrl/close-account.php');
    final headers = {'Api-Key': apiKey!, 'Authorization': 'Bearer $token'};
    final body = jsonEncode({'username': username});
    return await http.post(uri, headers: headers, body: body);
  }

  Future<http.Response> logWalkingData(Map<String, String> walkingData) async {
    final token = await getToken();
    if (token == null) {
      throw Exception("Token is null");
    }

    final uri = Uri.parse('$baseUrl/log-walking-data.php');
    final headers = {'Api-Key': apiKey!, 'Authorization': 'Bearer $token'};
    final body = jsonEncode(walkingData);
    return await http.post(uri, headers: headers, body: body);
  }

  Future<http.Response> log6MinWalkingData(
      Map<String, String> walkingData) async {
    final token = await getToken();
    if (token == null) {
      throw Exception("Token is null");
    }

    final uri = Uri.parse('$baseUrl/log-6min-walking-data.php');
    final headers = {'Api-Key': apiKey!, 'Authorization': 'Bearer $token'};
    final body = jsonEncode(walkingData);
    return await http.post(uri, headers: headers, body: body);
  }
}

class CustomHttpClient {
  Future<HttpClientResponse> post(
      Uri url, Map<String, String> headers, String body) async {
    final client = HttpClient();
    final request = await client.postUrl(url);

    headers.forEach((key, value) {
      request.headers.set(key, value);
    });

    request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
    request.add(utf8.encode(body));

    return await request.close();
  }
}
