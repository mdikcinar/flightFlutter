import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../core/device/constants.dart';
import 'model/flight_map_model.dart';
import 'service/google_firebase_service.dart';
import 'view/google_maps.dart';

abstract class GoogleMapsViewModel extends State<GoogleMaps> {
  // Add your state and logic here
  final GoogleFirebaseService _firebaseService = GoogleFirebaseService();
  BitmapDescriptor dogIcon;
  GoogleMapController controller;
  final CameraPosition kLake = CameraPosition(target: AppConstant.TURKEY_CENTER_LAT_LONG, zoom: 10);

  List<FlightMap> flightList = [];

  void navigateToRoot(int index) {
    controller.animateCamera(CameraUpdate.newLatLng(flightList[index].latlong));
  }

  double pageWidth(BuildContext context) => MediaQuery.of(context).size.width;
  double pageHeight(BuildContext context) => MediaQuery.of(context).size.height;

  Future initMapItemList() async {
    flightList = await _firebaseService.initMapItemList();
    await controller.animateCamera(CameraUpdate.newLatLng(flightList.first.latlong));
    setState(() {});
  }
}
