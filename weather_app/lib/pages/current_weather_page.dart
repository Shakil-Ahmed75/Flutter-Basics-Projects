import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_batch04/providers/location_provider.dart';
import 'package:weather_app_batch04/providers/weather_provider.dart';
import 'package:weather_app_batch04/styles/text_styles.dart';
import 'package:weather_app_batch04/utils/weather_utils.dart';

class CurrentWeatherPage extends StatefulWidget {
  @override
  _CurrentWeatherPageState createState() => _CurrentWeatherPageState();
}

class _CurrentWeatherPageState extends State<CurrentWeatherPage> {
  bool isLoading = true;
  String unitSymbol = 'C';

  @override
  void initState() {

    super.initState();
  }

  @override
  void didChangeDependencies() {
    final position = Provider.of<LocationProvider>(context).currentPosition;
    Provider.of<WeatherProvider>(context, listen: false).getCurrentData(position).then((_) {
      setState(() {
        isLoading = false;
      });
    });
    getTempStatus().then((value) {
      setState(() {
        unitSymbol = value ? 'F' : 'C';
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, child) =>
      Center(child: isLoading ? CircularProgressIndicator()
          : Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('${provider.currentData.name}, ${provider.currentData.sys.country}', style: labelText,),
          Text(getFormattedDate(provider.currentData.dt, 'hh:mm a, EEEE, MMMM dd, yyyy'), style: sub1,),
          //implicit animation
          TweenAnimationBuilder(
            curve: Curves.easeInOutCubic,
            duration: Duration(seconds: 2),
              tween: Tween(begin: 0.0, end: provider.currentData.main.temp),
              builder: (context, value, child) =>
                  Text('${value.round()}\u00B0$unitSymbol', style: bigText,)
          ),
          Text('Feels like: ${provider.currentData.main.feelsLike.round()}\u00B0$unitSymbol', style: sub1,),
        ],
      )
      )

    );
  }
}
