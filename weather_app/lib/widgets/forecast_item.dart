import 'package:flutter/material.dart';
import 'package:weather_app_batch04/models/forecast_weather_response.dart';
import 'package:weather_app_batch04/utils/weather_utils.dart';

class ForecastItem extends StatelessWidget {
  final ListElement forecastElement;
  ForecastItem(this.forecastElement);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network('$ICON_PREFIX${forecastElement.weather[0].icon}$ICON_SUFFIX'),
      title: Text('${forecastElement.temp.max.round()}/${forecastElement.temp.min.round()}\u00B0'),
      subtitle: Text(forecastElement.weather[0].description),
    );
  }
}
