import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:weather_app_batch04/models/current_weather_model.dart';
import 'package:weather_app_batch04/models/forecast_weather_response.dart';
import 'package:weather_app_batch04/utils/weather_utils.dart';


class WeatherProvider with ChangeNotifier {
  CurrentWeatherResponse _currentWeatherResponse;
  ForecastWeatherResponse _forecastWeatherResponse;

  CurrentWeatherResponse get currentData => _currentWeatherResponse;
  ForecastWeatherResponse get forecastData => _forecastWeatherResponse;

  Future<void> getCurrentData(Position position) async {
    final status = await getTempStatus();
    final unit = status ? 'imperial' : 'metric';
    final url = 'http://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&units=$unit&appid=$api_key';
    try {
      final response = await get(url);
      final map = json.decode(response.body);
      _currentWeatherResponse = CurrentWeatherResponse.fromJson(map);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getForecastData(Position position) async {
    final status = await getTempStatus();
    final unit = status ? 'imperial' : 'metric';
    final url = 'http://api.openweathermap.org/data/2.5/forecast/daily?lat=${position.latitude}&lon=${position.longitude}&cnt=16&units=$unit&appid=$api_key';
    try {
      final response = await get(url);
      final map = json.decode(response.body);
      _forecastWeatherResponse = ForecastWeatherResponse.fromJson(map);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }


}