// To parse this JSON data, do
//
//     final forecastWeatherResponse = forecastWeatherResponseFromJson(jsonString);

import 'dart:convert';

ForecastWeatherResponse forecastWeatherResponseFromJson(String str) => ForecastWeatherResponse.fromJson(json.decode(str));

String forecastWeatherResponseToJson(ForecastWeatherResponse data) => json.encode(data.toJson());

class ForecastWeatherResponse {
  ForecastWeatherResponse({
    this.city,
    this.cod,
    this.message,
    this.cnt,
    this.list,
  });

  City city;
  String cod;
  double message;
  int cnt;
  List<ListElement> list;

  factory ForecastWeatherResponse.fromJson(Map<String, dynamic> json) => ForecastWeatherResponse(
    city: City.fromJson(json["city"]),
    cod: json["cod"],
    message: json["message"].toDouble(),
    cnt: json["cnt"],
    list: List<ListElement>.from(json["list"].map((x) => ListElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "city": city.toJson(),
    "cod": cod,
    "message": message,
    "cnt": cnt,
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
  };
}

class City {
  City({
    this.id,
    this.name,
    this.coord,
    this.country,
    this.population,
    this.timezone,
  });

  int id;
  String name;
  Coord coord;
  String country;
  int population;
  int timezone;

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json["id"],
    name: json["name"],
    coord: Coord.fromJson(json["coord"]),
    country: json["country"],
    population: json["population"],
    timezone: json["timezone"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "coord": coord.toJson(),
    "country": country,
    "population": population,
    "timezone": timezone,
  };
}

class Coord {
  Coord({
    this.lon,
    this.lat,
  });

  double lon;
  double lat;

  factory Coord.fromJson(Map<String, dynamic> json) => Coord(
    lon: json["lon"].toDouble(),
    lat: json["lat"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lon": lon,
    "lat": lat,
  };
}

class ListElement {
  ListElement({
    this.dt,
    this.sunrise,
    this.sunset,
    this.temp,
    this.feelsLike,
    this.pressure,
    this.humidity,
    this.weather,
    this.speed,
    this.deg,
    this.clouds,
    this.pop,
    this.rain,
  });

  int dt;
  int sunrise;
  int sunset;
  Temp temp;
  FeelsLike feelsLike;
  int pressure;
  int humidity;
  List<Weather> weather;
  double speed;
  int deg;
  int clouds;
  double pop;
  double rain;

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
    dt: json["dt"],
    sunrise: json["sunrise"],
    sunset: json["sunset"],
    temp: Temp.fromJson(json["temp"]),
    feelsLike: FeelsLike.fromJson(json["feels_like"]),
    pressure: json["pressure"],
    humidity: json["humidity"],
    weather: List<Weather>.from(json["weather"].map((x) => Weather.fromJson(x))),
    speed: json["speed"].toDouble(),
    deg: json["deg"],
    clouds: json["clouds"],
    pop: json["pop"].toDouble(),
    rain: json["rain"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "dt": dt,
    "sunrise": sunrise,
    "sunset": sunset,
    "temp": temp.toJson(),
    "feels_like": feelsLike.toJson(),
    "pressure": pressure,
    "humidity": humidity,
    "weather": List<dynamic>.from(weather.map((x) => x.toJson())),
    "speed": speed,
    "deg": deg,
    "clouds": clouds,
    "pop": pop,
    "rain": rain,
  };
}

class FeelsLike {
  FeelsLike({
    this.day,
    this.night,
    this.eve,
    this.morn,
  });

  double day;
  double night;
  double eve;
  double morn;

  factory FeelsLike.fromJson(Map<String, dynamic> json) => FeelsLike(
    day: json["day"].toDouble(),
    night: json["night"].toDouble(),
    eve: json["eve"].toDouble(),
    morn: json["morn"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "night": night,
    "eve": eve,
    "morn": morn,
  };
}

class Temp {
  Temp({
    this.day,
    this.min,
    this.max,
    this.night,
    this.eve,
    this.morn,
  });

  double day;
  double min;
  double max;
  double night;
  double eve;
  double morn;

  factory Temp.fromJson(Map<String, dynamic> json) => Temp(
    day: json["day"].toDouble(),
    min: json["min"].toDouble(),
    max: json["max"].toDouble(),
    night: json["night"].toDouble(),
    eve: json["eve"].toDouble(),
    morn: json["morn"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "min": min,
    "max": max,
    "night": night,
    "eve": eve,
    "morn": morn,
  };
}

class Weather {
  Weather({
    this.id,
    this.main,
    this.description,
    this.icon,
  });

  int id;
  String main;
  String description;
  String icon;

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
    id: json["id"],
    main: json["main"],
    description: json["description"],
    icon: json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "main": main,
    "description": description,
    "icon": icon,
  };
}
