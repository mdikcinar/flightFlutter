import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/view/widgets/cards/pet_card.dart';
import '../../core/view/widgets/divider/row_divider.dart';
import '../../core/view/widgets/image/cached_image.dart';
import '../google_maps_view_model.dart';
import '../model/flight_map_model.dart';
import '../vm/maps_vm.dart';

class GoogleMapsView extends GoogleMapsViewModel {
  final MapsViewModel mapsViewModel = MapsViewModel();
  @override
  Widget build(BuildContext context) {
    // Replace this with your build function
    return Scaffold(
      //floatingActionButton: buildFloatingActionButton(),
      body: Stack(
        children: [
          buildGoogleMap,
          buildPositionedAppBar(context),
          bottomListView(),
        ],
      ),
    );
  }

  Positioned buildPositionedAppBar(BuildContext context) {
    return Positioned(
      height: pageHeight(context) * 0.15,
      top: 20,
      left: 0,
      right: 0,
      child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Observer(
            builder: (_) => Text(
              mapsViewModel.title ?? 'Hello',
              style: TextStyle(color: Colors.black),
            ),
          )),
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
      onPageChanged: (index) {
        mapsViewModel.changeAppBarName(flightList[index].country);
        navigateToRoot(index);
      },
      itemBuilder: (context, index) {
        return buildPetCard(flightList[index]);
      },
    );
  }

  Widget buildPetCard(FlightMap flightMap) {
    return PetCard(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
          builder: (context) => _bottomSheet(flightMap.detail),
        );
      },
      title: flightMap.country,
      imageUrl: flightMap.detail.photoUrl,
    );
  }

  Widget _bottomSheet(Detail detail) => Column(
        children: [
          RowDivider(indent: 0.3),
          FlightCachedImage(
            imageUrl: detail.photoUrl,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: AutoSizeText(
                detail.description,
                maxFontSize: 15,
                minFontSize: 10,
              ),
            ),
          ),
        ],
      );

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
