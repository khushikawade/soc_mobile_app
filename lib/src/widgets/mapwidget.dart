import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMaps extends StatefulWidget {
  var latitude;
  var longitude;
  // var locationName;
  GoogleMaps({
    Key? key,
    required this.latitude,
    required this.longitude,
    // required this.locationName
  }) : super(key: key);

  @override
  State<GoogleMaps> createState() => GoogleMapsState();
}

class GoogleMapsState extends State<GoogleMaps> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition? _kGooglePlex;
  final Set<Marker> _markers = {};
  CameraPosition? _kLocation;
  @override
  void initState() {
    super.initState();
    print("init");
    _kGooglePlex = CameraPosition(
      target: LatLng(widget.latitude, widget.longitude),
      zoom: 14.4746,
    );

    _markers.add(Marker(
      markerId: MarkerId(widget.latitude.toString()),
      position: LatLng(widget.latitude, widget.longitude),
      // infoWindow: InfoWindow(
      //   title: widget.locationName,
      // ),
      icon: BitmapDescriptor.defaultMarker,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: widget.latitude != null && widget.longitude != null
          ? GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex!,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: _markers,
            )
          : Container(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _gotoLocation,
      //   // label: Text('our location'),
      //   child: Icon(Icons.location_city),
      // ),
    );
  }

  // Future<void> _gotoLocation() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLocation!));
  // }
}
