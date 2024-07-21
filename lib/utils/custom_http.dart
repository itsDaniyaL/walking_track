import 'dart:io';
import 'dart:convert';

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
