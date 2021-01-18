import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'google_maps_view_model.dart';

class GoogleMapsView extends GoogleMapsViewModel {
  @override
  Widget build(BuildContext context) {
    // Replace this with your build function
    return Scaffold(
      //floatingActionButton: buildFloatingActionButton(),
      body: Stack(
        children: [buildGoogleMap, bottomListView()],
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
      left: 20,
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

  ListView listViewFlights() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: flightList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SizedBox(
          width: MediaQuery.of(context).size.width - 100,
          child: Card(
            child: ListTile(
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
          //await createMarkerImageFromAsset(context);
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
    return <Marker>[
      Marker(
        markerId: MarkerId('asdad'),
        position: kLake.target,
        //icon: dogIcon,
        zIndex: 10,
        //infoWindow: InfoWindow(title: 'Hello Dog'),
      )
    ].toSet();
  }

  Future<void> createMarkerImageFromAsset(BuildContext context) async {
    final ImageConfiguration imageConfiguration = createLocalImageConfiguration(context);
    var bitmap = await BitmapDescriptor.fromAssetImage(imageConfiguration, 'assets/images/dog.png');
    dogIcon = bitmap;
    setState(() {});
  }
}
