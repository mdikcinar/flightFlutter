import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'flight_map_model.dart';
import 'google_maps_view_model.dart';

class GoogleMapsView extends GoogleMapsViewModel {
  @override
  Widget build(BuildContext context) {
    // Replace this with your build function
    return Scaffold(
      //floatingActionButton: buildFloatingActionButton(),
      body: Stack(
        children: [
          buildGoogleMap,
          Positioned(
            height: pageHeight(context) * 0.15,
            top: 20,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Hello',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          bottomListView(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => initMapItemList());
  }

  Positioned bottomListView() {
    return Positioned(
      bottom: 20,
      left: -pageWidth(context) * 0.05,
      right: 5,
      height: 100,
      child: flightList.isEmpty ? loadingWidget : listViewFlights(),
    );
  }

  Widget get loadingWidget => Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.blue),
        ),
      );

  Widget listViewFlights() {
    return PageView.builder(
      controller: PageController(viewportFraction: 0.8),
      scrollDirection: Axis.horizontal,
      itemCount: flightList.length,
      onPageChanged: (index) => navigateToRoot(index),
      itemBuilder: (context, index) {
        return SizedBox(
          width: MediaQuery.of(context).size.width - 100,
          child: Card(
            child: ListTile(
              //onTap: () => navigateToRoot(index),
              title: Text(flightList[index].country),
            ),
          ),
        );
      },
    );
  }

  Widget get buildGoogleMap => GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: kLake,
        onMapCreated: (map) async {
          controller = map;
          await createMarkerImageFromAsset(context);
        },
        markers: createMarker(),
      );

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        controller.animateCamera(CameraUpdate.newLatLng(LatLng(40.9906621, 29.0200943)));
      },
    );
  }
}

extension _GoogleMapMarker on GoogleMapsView {
  Set<Marker> createMarker() {
    return flightList
        .map((e) => Marker(
              markerId: MarkerId(e.hashCode.toString()),
              position: e.latlong,
              icon: dogIcon,
              zIndex: 10,
              infoWindow: InfoWindow(title: e.country),
            ))
        .toSet();
  }

  Future<void> createMarkerImageFromAsset(BuildContext context) async {
    final ImageConfiguration imageConfiguration = createLocalImageConfiguration(context);
    var bitmap = await BitmapDescriptor.fromAssetImage(imageConfiguration, 'assets/images/dog.png');
    dogIcon = bitmap;
    setState(() {});
  }
}
