import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:shopesapp/presentation/shared/utils.dart';

class LocationSevice extends StatefulWidget {
  const LocationSevice({Key? key}) : super(key: key);

  @override
  State<LocationSevice> createState() => _LocationSeviceState();
}

class _LocationSeviceState extends State<LocationSevice> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class LocationService {
  Location location = Location();

  Future<LocationData?> getUserCurrentLocation(
      {bool hideLoader = false}) async {
    LocationData locationData;

    if (!await isLocationEnabeld()) {
      return null;
    }

    if (!await isPermissionGranted()) {
      return null;
    }

    if (!hideLoader) customLoader(const Size(400, 1200));

    locationData = await location.getLocation();

    if (hideLoader) BotToast.closeAllLoading();

    return locationData;
  }

  Future<geo.Placemark?> getAddressInfo(LocationData locationData,
      {bool showLoader = true}) async {
    // if (showLoader) customLoader(const Size(400, 1200));

    List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        locationData.latitude ?? 0.0, locationData.longitude ?? 0.0);

    // BotToast.closeAllLoading();

    if (placemarks.isNotEmpty) {
      return placemarks[0];
    } else {
      return null;
    }
  }

  Future<geo.Placemark?> getCurrentAddressInfo() async {
    LocationData loc = await getUserCurrentLocation(hideLoader: false) ??
        LocationData.fromMap({});
    return await getAddressInfo(loc, showLoader: false);
  }

  Future<bool> isLocationEnabeld() async {
    bool serviceEnabled;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        // CustomToast.showMessage(message: 'enable the location', size: null);

        return false;
      }
    }

    return serviceEnabled;
  }

  Future<bool> isPermissionGranted() async {
    PermissionStatus permissionGranted;

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    return permissionGranted == PermissionStatus.granted;
  }
}
