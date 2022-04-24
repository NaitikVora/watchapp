import 'package:location/location.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:geocoder/geocoder.dart';

Future<Address> getCurrentLocation() async {
  var first, lat, long, addresses;

// Platform messages may fail, so we use a try/catch PlatformException.
  try {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {}
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {}
    }

    _locationData = await location.getLocation();

    lat = _locationData.latitude;
    long = _locationData.longitude;
    final coordinates = new Coordinates(lat, long);
    addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);

    first = addresses.first;
    //print("${first.featureName} : ${first.addressLine}");

    //print(first);
  } catch (e) {
    //print(e);
  }
  return first;
}
