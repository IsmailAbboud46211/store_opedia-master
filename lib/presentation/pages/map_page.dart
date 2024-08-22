import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shopesapp/data/models/shop.dart';
import 'package:shopesapp/logic/cubites/shop/store_cubit.dart';
import 'package:shopesapp/main.dart';
import 'package:shopesapp/presentation/shared/extensions.dart';

import '../widgets/location/location_service.dart';

class MapPage extends StatefulWidget {
  final LocationData currentLocation;
  const MapPage({Key? key, required this.currentLocation}) : super(key: key);

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  late CameraPosition initalCameraPosition;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  initState() {
    initalCameraPosition = CameraPosition(
      target: LatLng(widget.currentLocation.latitude ?? 37.43296265331129,
          widget.currentLocation.longitude ?? -122.08832357078792),
      zoom: 7.4746,
    );

    selectedLocation = LatLng(
        widget.currentLocation.latitude ?? 37.43296265331129,
        widget.currentLocation.longitude ?? -122.08832357078792);
    LocationService()
        .getAddressInfo(LocationData.fromMap({
          'latitude': selectedLocation.latitude,
          'longitude': selectedLocation.longitude,
        }))
        .then(
          (value) => selectedLocationAddress =
              '${value?.administrativeArea ?? ''}-${value?.street ?? ''}',
        );
    markers.add(Marker(
        icon: customIcon ?? BitmapDescriptor.defaultMarker,
        markerId: const MarkerId('Current'),
        position: LatLng(widget.currentLocation.latitude ?? 37.43296265331129,
            widget.currentLocation.longitude ?? -122.08832357078792)));
    BlocProvider.of<StoreCubit>(context).locationFilterStores(
      id: globalSharedPreference.getString("ID") ?? '0',
      longitude: selectedLocation.longitude,
      latitude: selectedLocation.latitude,
    );
    List<dynamic> shops = BlocProvider.of<StoreCubit>(context).shops;

    for (var element in shops) {
      element = Shop.fromMap(element);
      markers.add(Marker(
          markerId: MarkerId(element.ownerID + element.shopID),
          position: LatLng(element.latitude ?? 37.43296265331129,
              element.longitude ?? -122.08832357078792)));
    }
    super.initState();
  }

  Set<Marker> markers = {};

  late LatLng selectedLocation;
  String selectedLocationAddress = '';
  Future<void> loadcustomIcon() async {
    setState(() async {
      customIcon = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(), 'assets/map-marker.png');
    });
  }

  BitmapDescriptor? customIcon;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initalCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);

          setState(() {});
        },
        markers: markers,
        onTap: (latlong) {
          setState(() async {
            selectedLocation = latlong;
            changeStoreLoaction();
            markers.add(Marker(
                markerId: const MarkerId('Current'),
                position: LatLng(latlong.latitude, latlong.longitude)));
          });
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsetsDirectional.only(start: 20.0),
        child: Align(
          alignment: AlignmentDirectional.bottomStart,
          child: FloatingActionButton.extended(
            onPressed: () => context.pop(selectedLocation),
            label: Text(selectedLocationAddress),
            icon: const Icon(Icons.directions_boat),
          ),
        ),
      ),
    );
  }

  void changeStoreLoaction() {
    setState(() {
      LocationService()
          .getAddressInfo(LocationData.fromMap({
            'latitude': selectedLocation.latitude,
            'longitude': selectedLocation.longitude,
          }))
          .then(
            (value) => selectedLocationAddress =
                '${value?.administrativeArea ?? ''}-${value?.street ?? ''}',
          );
    });
    setState(() {});
  }
}
