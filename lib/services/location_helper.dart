import 'package:geolocator/geolocator.dart';

class LocationHelper {
  static Future<bool> isNearCampus(double campusLat, double campusLon, {double radiusMeters = 50}) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    if (permission == LocationPermission.deniedForever) return false;

    final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final distance = Geolocator.distanceBetween(pos.latitude, pos.longitude, campusLat, campusLon);
    return distance <= radiusMeters;
  }
}
