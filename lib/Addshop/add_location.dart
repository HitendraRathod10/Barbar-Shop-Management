import 'package:barber_booking_management/NearBy/current_location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class AddLocationToMapScreen extends StatefulWidget {
  const AddLocationToMapScreen({Key? key}) : super(key: key);

  @override
  State<AddLocationToMapScreen> createState() => _AddLocationToMapScreenState();
}

class _AddLocationToMapScreenState extends State<AddLocationToMapScreen> {


  late GoogleMapController mapController;
  LocationData? currentLocation;
  final Set<Marker> markers = {};
  final markerController=TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<LocationData?>(
          future: CurrentLocation.instance.currentLocation(),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return const Center(child: CircularProgressIndicator());
            }
            else{
              markers.add(Marker(
                markerId: const MarkerId("1"),
                onTap: (){},
                infoWindow: const InfoWindow(title: "My Location"),
                position: LatLng(snapshot.data!.latitude!,snapshot.data!.longitude!),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed,
                ),
              ));
              return GoogleMap(
                zoomGesturesEnabled: true,
                myLocationEnabled : true,
                compassEnabled: true,
                mapToolbarEnabled: true,
                tiltGesturesEnabled: true,
                myLocationButtonEnabled: true,
                indoorViewEnabled: true,
                trafficEnabled: true,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(snapshot.data!.latitude!,snapshot.data!.longitude!),
                  zoom: 6
                ),
                markers: markers,
                onTap: (latLng){
                  _handleTap(LatLng(latLng.latitude, latLng.longitude)).then((value) {
                    debugPrint(value);
                    Future.delayed(const Duration(milliseconds: 2000), () {
                        Navigator.pop(context,latLng);
                    });
                  });
                },
              );
            }
          }
      ),
    );
  }

  Future<String> _handleTap(LatLng point) async{
    String str="";
    setState(() {
      markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: const InfoWindow(
          title: 'I am a marker',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
      ));
    });
    return str;
  }
}
