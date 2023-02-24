import 'package:barber_booking_management/NearBy/current_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../Firebase/firebase_collection.dart';
import '../utils/app_color.dart';

class NearbyScreen extends StatefulWidget {
  const NearbyScreen({Key? key}) : super(key: key);

  @override
  State<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {

  late GoogleMapController mapController;
  final Set<Marker> markers = {};

  String? userName,userImage,userType,userEmail;

  @override
  void initState() {
    super.initState();
    markerLocation();
  }

  Future markerLocation() async{
    var shopQuerySnapshot = await FirebaseCollection().shopCollection.get();
    for(var snapShot in shopQuerySnapshot.docChanges){
      markers.add(Marker(
          markerId: MarkerId(snapShot.doc.get('shopName')),
          onTap: (){
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return Wrap(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(10,10,10,20),
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColor.whiteColor
                      ),
                      child:  Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(snapShot.doc.get('shopImage'),
                                height: 90,width: 90,fit: BoxFit.fill),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:  [
                                  const SizedBox(height: 2),
                                  Text(snapShot.doc.get('shopName'),
                                      style : const TextStyle(color: AppColor.appColor,fontWeight: FontWeight.bold,fontSize: 16),maxLines: 1,overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 2),
                                  Text(snapShot.doc.get('hairCategory'),
                                      style : const TextStyle(fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      RatingBar.builder(
                                        initialRating: 5,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        ignoreGestures : true,
                                        itemSize: 18,
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          debugPrint('$rating');
                                        },
                                      ),
                                      const SizedBox(width: 5,),
                                      Text('(${snapShot.doc.get('rating').toString().substring(0,3)} review)',
                                          style:  const TextStyle(fontWeight: FontWeight.w500,fontSize: 12),
                                          maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                );
              },
            );
          },
          position: LatLng(double.parse(snapShot.doc.get('latitude')),double.parse(snapShot.doc.get('longitude'))),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed,
          )));
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:  FutureBuilder<LocationData?>(
            future: CurrentLocation.instance.currentLocation(),
            builder: (context,AsyncSnapshot snapshot) {
              if(!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none){
                return const Center(child: CircularProgressIndicator());
              }
              else if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasData){
                  markers.add(Marker(
                    markerId: const MarkerId("1"),
                    infoWindow: const InfoWindow(title: "My Location"),
                    position: LatLng(snapshot.data!.latitude!,snapshot.data!.longitude!),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure,
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
                    onTap: (latLng){},
                  );
                } else{
                  return const Center(child: CircularProgressIndicator());
                }
              }
              else{
                return const Center(child: CircularProgressIndicator());
              }
            }
        ),
      ),
    );
  }
}
