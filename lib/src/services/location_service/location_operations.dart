import 'package:geolocator/geolocator.dart';
import 'package:one_km_app/src/models/server_settings.dart';
import 'package:one_km_app/src/models/user.dart';

///GetLocation
//
//

Future<UserModel> getLocation(
    {required String name, required String uid}) async {
  await Geolocator.requestPermission();
  var konum = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation);
  double enlem = konum.latitude;
  double boylam = konum.longitude;
  var userModal = UserModel(boylam, enlem, name, "d", uid);
  return userModal;
}
//
//
///

///CHECK LOCATION DISTANCE
//
//
bool checkLocationDis(double startLat, double startLong, double endLat,
    double endLong, String title, ServerSettings serverSettings) {
  if (title == "Admin") {
    return true;
  } else {
    double distanceInMeters =
        Geolocator.distanceBetween(startLat, startLong, endLat, endLong);

    if (title == "Master") {
      if (distanceInMeters <= serverSettings.masterDistance) {
        return true;
      } else {
        return false;
      }
    } else {
      if (distanceInMeters <= serverSettings.juniorDistance) {
        return true;
      } else {
        return false;
      }
    }
  }
}
//
//
///