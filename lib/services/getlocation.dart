import 'package:feel_safe/services/locationinfo.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';

class GetLocation {
  static var z;
  static String getLocation() {
    getCurrentLocation().then((address) {
      z = address.subLocality.toString();
      //print(z);
      return z;
    });
    return z;
  }
}
