// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather/consts/constants.dart';
import 'package:weather/consts/http_error_handler.dart';
import 'package:weather/exceptions/weather_exceptions.dart';
import 'package:weather/models/weather.dart';

class WeatherApiServices {
  final http.Client httpClient;
  WeatherApiServices({
    required this.httpClient,
  });
  Future<int> getWoeid(String city) async {
    final Uri uri = Uri(
      scheme: 'https',
      host: kHost,
      path:
          '/api.weatherapi.com/v1/current.json?key=8b51912ee82e4794a8e71437231805&q=$city&aqi=no',
      queryParameters: {'query': city},
    );
    try {
      final http.Response response = await http.get(uri);
      if (response != 200) {
        throw httpErrorHandler(response);
      }
      final responseBody = json.decode(response.body);
      print(responseBody);
      if (responseBody.isEmpty) {
        throw WeatherException('Cannot get the woeid of the$city');
      }
      if (responseBody.length > 1) {
        throw WeatherException(
            'There are multiple candidates for city, please specify furthur');
      }
      return responseBody[0]['woeid'];
    } catch (e) {
      rethrow;
    }
  }

  Future<Weather> getWeather(int woeid) async {
    final Uri uri = Uri(
      scheme: 'https',
      host: kHost,
      path: '/api/location/$woeid',
    );
    try {
      final http.Response response = await http.get(uri);
      if (response.statusCode != 200) {
        throw Exception(httpErrorHandler(response));
      }
      final weatherJson = json.decode(response.body);
      final Weather weather = Weather.fromJson(weatherJson);
      print(weather);
      return weather;
    } catch (e) {
      rethrow;
    }
  }
}
