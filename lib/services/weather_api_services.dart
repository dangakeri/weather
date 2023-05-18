// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather/consts/constants.dart';
import 'package:weather/consts/http_error_handler.dart';

class WeatherApiServices {
  final http.Client httpClient;
  WeatherApiServices({
    required this.httpClient,
  });
  Future<int> getWoeid(String city) async {
    final Uri uri = Uri(
      scheme: 'https',
      host: kHost,
      path: '/api/location/search/',
      queryParameters: {'query': city},
    );
    try {
      final http.Response response = await http.get(uri);
      if (response != 200) {
        throw httpErrorHandler(response);
      }
      final responseBody = json.decode(response.body);
    } catch (e) {
      print(e);
    }
  }
}
