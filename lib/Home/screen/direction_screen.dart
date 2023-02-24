import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionScreen extends StatefulWidget {

  String latitude,longitude,shopName,shopAddress;
  DirectionScreen({Key? key,required this.latitude,required this.longitude,
    required this.shopName,required this.shopAddress}) : super(key: key);

  @override
  State<DirectionScreen> createState() => _DirectionScreenState();
}

class _DirectionScreenState extends State<DirectionScreen> {

  late GoogleMapController mapController;
  final Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {

    Set<Marker> getMarkers() {
      setState(() {
        markers.add(Marker(
          markerId: MarkerId(LatLng(double.parse(widget.latitude),double.parse(widget.longitude)).toString()),
          position: LatLng(double.parse(widget.latitude),double.parse(widget.longitude)),
          infoWindow: InfoWindow(
            title: widget.shopName,
            snippet: widget.shopAddress,
          ),
          icon: BitmapDescriptor.defaultMarker,
        ));
      });
      return markers;
    }

    return SafeArea(
      child: Scaffold(
        body:  Stack(
          children: [
            GoogleMap(
              zoomGesturesEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(double.parse(widget.latitude),double.parse(widget.longitude)),
                zoom: 20.0,
              ),
              markers: getMarkers(),
              mapType: MapType.hybrid,
              onMapCreated: (controller) {
                setState(() {
                  mapController = controller;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
