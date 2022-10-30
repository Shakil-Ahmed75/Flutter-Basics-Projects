import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_batch04/pages/current_weather_page.dart';
import 'package:weather_app_batch04/pages/forecast_weather_page.dart';
import 'package:weather_app_batch04/pages/settings_page.dart';
import 'package:weather_app_batch04/providers/location_provider.dart';
import 'package:weather_app_batch04/utils/weather_utils.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  @override
  void initState() {
    _getLocation();
    super.initState();
  }

  void _getLocation() {
    getUserCurrentPosition().then((position) {
      print('lat: ${position.latitude}, lng: ${position.longitude}');
      setState(() {
        isLoading = false;
      });
      Provider.of<LocationProvider>(context, listen: false).setNewPosition(position);
    });
  }

  void _getWeatherByCity(String city, BuildContext ctx) {
    Geolocator().placemarkFromAddress(city).then((placeList) {
      if(placeList != null) {
        final pos = placeList[0].position;
        Provider.of<LocationProvider>(context, listen: false).setNewPosition(pos);
        setState(() {
          isLoading = false;
        });
      }
    }). catchError((error) {
      setState(() {
        isLoading = false;
      });
      Scaffold.of(ctx).showSnackBar(SnackBar(content: Text('Invalid city name'),));
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Weather App'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.my_location),
              onPressed: _getLocation,
            ),
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: CitySearchDelegate()).then((city) {
                      //print(city);
                    if(city != null) {
                      setState(() {
                        isLoading = true;
                      });
                      _getWeatherByCity(city, context);
                    }
                  });
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SettingsPage()
              )).then((_) {
                _getLocation();
              }),
            ),
          ],
          bottom: TabBar(
            tabs: <Widget>[
              Tab(child: Text('Today'),),
              Tab(child: Text('7 Days'),),
            ],
          ),
        ),
        body: isLoading ? Center(child: Text('Please wait'),) : TabBarView(
          children: <Widget>[
            CurrentWeatherPage(),
            ForecastWeatherPage()
          ],
        ),
      ),
    );
  }
}

class CitySearchDelegate extends SearchDelegate<String> {

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () => query = '',
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListTile(
      onTap: () {
        close(context, query);
      },
      title: Text(query),
      leading: Icon(Icons.search),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var suggestionsList = query == null ? cities
        : cities.where((c) => c.toLowerCase().startsWith(query.toLowerCase())).toList();
    return ListView.builder(
        itemBuilder: (context, index) => ListTile(
          onTap: () {
            query = suggestionsList[index];
            close(context, query);
          },
          title: Text(suggestionsList[index]),
        ),
      itemCount: suggestionsList.length,
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    // TODO: implement appBarTheme
    return Theme.of(context);
  }

}
