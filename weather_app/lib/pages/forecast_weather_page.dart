import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_batch04/providers/location_provider.dart';
import 'package:weather_app_batch04/providers/weather_provider.dart';
import 'package:weather_app_batch04/widgets/forecast_item.dart';

class ForecastWeatherPage extends StatefulWidget {
  @override
  _ForecastWeatherPageState createState() => _ForecastWeatherPageState();
}

class _ForecastWeatherPageState extends State<ForecastWeatherPage> {
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    final position = Provider.of<LocationProvider>(context, listen: false).currentPosition;
    Provider.of<WeatherProvider>(context,listen: false).getForecastData(position).then((_) {
      setState(() {
        isLoading = false;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, child) =>
      isLoading ? Center(child: CircularProgressIndicator(),) : 
          ListView.builder(
              itemBuilder: (context, index) => ForecastItem(provider.forecastData.list[index]),
            itemCount: provider.forecastData.list.length,
          )
    );
  }
}
