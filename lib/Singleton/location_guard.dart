import 'package:geolocator/geolocator.dart';

class LocationGuard {
  // Position: 11.585851,104.899145 Radius: 1270.90 Meters

  static const double shopLat = 11.585851;
  static const double shopLng = 104.899145;
  static const double allowMeter = 1270.90;

  static Future<bool> isInsideShop() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
      return false;
    }

    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    final distance = Geolocator.distanceBetween(position.latitude, position.longitude, shopLat, shopLng);

    return distance <= allowMeter;
  }
}
