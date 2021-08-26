import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
class GoogleMaps extends StatefulWidget {
  final latitude;
  final longitude;
  // final locationName;
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
  // CameraPosition? _kLocation;
  @override
  void initState() {
    super.initState();
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
              zoomGesturesEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex!,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: _markers,
              // gestureRecognizers: Set()
              //   ..add(
              //       Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
              //   ..add(Factory<ScaleGestureRecognizer>(
              //       () => ScaleGestureRecognizer()))
              //   ..add(
              //       Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
              //   ..add(Factory<VerticalDragGestureRecognizer>(
              //       () => VerticalDragGestureRecognizer())),
            )
          : Container(),
    );
  }
}
