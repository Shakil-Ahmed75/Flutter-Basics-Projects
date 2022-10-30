
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

const api_key = 'd5d08859ea4bef197027d118779b438f';
const ICON_PREFIX = 'https://openweathermap.org/img/wn/';
const ICON_SUFFIX = '@2x.png';

final cities = ['Athen','Dhaka','Cairo','Dublin','London','Sydney','Karachi','Delhi','Colombo','Beijing','New York', 'Chittagong'];

Future<Position> getUserCurrentPosition() async {
  return await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
}

String getFormattedDate(int dt, String format) => DateFormat(format).format(DateTime.fromMillisecondsSinceEpoch(dt * 1000));

Future<void> saveTempStatus(bool status) async {
  try{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool('status', status);
  } catch (error) {
    throw error;
  }
}

Future<bool> getTempStatus() async {
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getBool('status') ?? false;
}