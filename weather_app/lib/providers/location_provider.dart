import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider with ChangeNotifier{
  Position _position = Position(latitude: 0.0, longitude: 0.0);
  Position get currentPosition => _position;

  void setNewPosition(Position position) {
    this._position = position;
    notifyListeners();
  }
}