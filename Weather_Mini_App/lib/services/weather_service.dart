import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherException implements Exception {
  final String message;
  WeatherException(this.message);
}

class WeatherService {
  // 🔑 REPLACE WITH YOUR OWN API KEY from openweathermap.org
  static const String _apiKey = '0fabd591213a79f03cf3f6d37f3ee9a3';
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherModel> fetchWeather(String cityName) async {
    if (cityName.trim().isEmpty) {
      throw WeatherException('Please enter a city name.');
    }

    try {
      final uri = Uri.parse(
          '$_baseUrl?q=${Uri.encodeComponent(cityName)}&appid=$_apiKey&units=metric');

      final response = await http.get(uri).timeout(
            const Duration(seconds: 10),
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return WeatherModel.fromJson(data);
      } else if (response.statusCode == 401) {
        throw WeatherException(
            'Invalid API Key. Please check your API key in weather_service.dart');
      } else if (response.statusCode == 404) {
        throw WeatherException(
            'City "$cityName" not found. Please check the city name and try again.');
      } else {
        final data = jsonDecode(response.body);
        throw WeatherException(data['message'] ?? 'Unknown error occurred.');
      }
    } on SocketException {
      throw WeatherException(
          'No internet connection. Please check your network and try again.');
    } on HttpException {
      throw WeatherException('Could not connect to the weather service.');
    } on FormatException {
      throw WeatherException('Failed to parse weather data.');
    } catch (e) {
      if (e is WeatherException) rethrow;
      throw WeatherException('An unexpected error occurred: ${e.toString()}');
    }
  }
}
