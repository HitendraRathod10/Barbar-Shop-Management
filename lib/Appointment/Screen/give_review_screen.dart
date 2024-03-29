import 'package:barber_booking_management/mixin/textfield_mixin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../Addshop/firebase/add_shop_details.dart';
import '../../Firebase/firebase_collection.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
import '../../utils/app_utils.dart';
import '../firebase/rating_auth.dart';
//ignore: must_be_immutable
class GiveReviewScreen extends StatefulWidget {
  dynamic snapshotData;
  GiveReviewScreen({Key? key,required this.snapshotData}) : super(key: key);

  @override
  State<GiveReviewScreen> createState() => _GiveReviewScreenState();
}

class _GiveReviewScreenState extends State<GiveReviewScreen> {

  TextEditingController reviewController = TextEditingController();
  bool buttonVisible = false;
  double userRating = 0;
  double rating = 0;
  int userLength = 0;
  double sum = 0.0;
  List ratingList = [];

  late String uId,userName,shopName, shopDescription,status,
  openingHour,closingHour,shopEmail,
  barberName, currentUser,
  hairCategory,price,
  longitudeShop, latitudeShop,
  contactNumber, webSiteUrl,
  gender,
  address,coverPageImage,
  barberImage,shopImage;

  late Timestamp timestamp;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    methodForTest();
  }
  methodForTest()async{
    var queryUserRatingSnapshots = await FirebaseCollection().userRatingCollection.
    where('shopName',isEqualTo: widget.snapshotData['shopName']).get();
    debugPrint("queryUserRatingSnapshots $queryUserRatingSnapshots");
    for (var snapshot in queryUserRatingSnapshots.docChanges) {
      debugPrint("snapshot ${snapshot.doc.get("shopRating")}");
      ratingList.add(snapshot.doc.get("shopRating"));
      debugPrint("rating list init $ratingList");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.snapshotData['shopName'],style: const TextStyle(fontFamily: AppFont.bold),),
        actions: [
          Visibility(
            visible: buttonVisible,
            child: TextButton(
               onPressed: () async {
                ratingList.clear();
                debugPrint("ratingList $ratingList");
                debugPrint("userRating $userRating");
                debugPrint("rating $rating");
                var querySnapShot = await FirebaseCollection().userCollection.
                where('userEmail',isEqualTo: FirebaseAuth.instance.currentUser?.email).get();

                // var queryUserRatingSnapshots = await FirebaseCollection().userRatingCollection.
                // where('shopName',isEqualTo: widget.snapshotData['shopName']).get();

                var queryShopSnapshots = await FirebaseCollection().shopCollection.
                where('shopName',isEqualTo: widget.snapshotData['shopName']).get();

                for (var snapshot in querySnapShot.docChanges) {
                  RatingAuth().userRating(
                      shopName: widget.snapshotData['shopName'],
                      barberName: widget.snapshotData['barberName'],
                      currentUser: FirebaseAuth.instance.currentUser!.email.toString(),
                      currentDate: DateTime.now().toString().substring(0,10),
                      userRating: userRating,
                      userExprience: reviewController.text,
                      timestamp: Timestamp.now(),
                      userName: snapshot.doc.get('userName'),
                      userImage: snapshot.doc.get('userImage'),
                  ).whenComplete(() async{
                    AppUtils.instance.showToast(toastMessage: 'Your review will be post');
                    setState(() {});
                    var queryUserRatingSnapshots = await FirebaseCollection().userRatingCollection.
                    where('shopName',isEqualTo: widget.snapshotData['shopName']).get();
                    for (var snapshot in queryUserRatingSnapshots.docChanges) {
                      // for(int i = 0;i<1;i++){
                        userRating = snapshot.doc.get('shopRating');
                        ratingList.add(snapshot.doc.get('shopRating'));
                        sum = ratingList.reduce((a, b) => a + b);
                        userLength = queryUserRatingSnapshots.docs.length;
                        rating = sum/userLength;
                        // debugPrint('User Rating in for in => $sum = $userLength = $rating = $userRating');
                        // break;
                      // }
                    }
                    for(var shopSnapshot in queryShopSnapshots.docChanges){
                      uId = snapshot.doc.get('uid');
                      userName = shopSnapshot.doc.get('userName');
                      shopName = shopSnapshot.doc.get('shopName');
                      shopDescription = shopSnapshot.doc.get('shopDescription');
                      status = shopSnapshot.doc.get('shopStatus');
                      openingHour= shopSnapshot.doc.get('openingHour');
                      closingHour= shopSnapshot.doc.get('closingHour');
                      shopEmail= shopSnapshot.doc.get('shopEmail');
                      barberName= shopSnapshot.doc.get('barberName');
                      hairCategory= shopSnapshot.doc.get('hairCategory');
                      price= shopSnapshot.doc.get('price');
                      longitudeShop= shopSnapshot.doc.get('longitude');
                      latitudeShop= shopSnapshot.doc.get('latitude');
                      gender= shopSnapshot.doc.get('gender');
                      contactNumber= shopSnapshot.doc.get('contactNumber');
                      timestamp= shopSnapshot.doc.get('timeStamp');
                      address = shopSnapshot.doc.get('address');
                      coverPageImage = shopSnapshot.doc.get('coverPageImage');
                      barberImage = shopSnapshot.doc.get('barberImage');
                      shopImage = shopSnapshot.doc.get('shopImage');
                      currentUser = shopSnapshot.doc.get('currentUser');
                      webSiteUrl= shopSnapshot.doc.get('webSiteUrl');
                    }
                    AddShopDetailFirebase().addShopDetail(
                      userName: userName,uId: uId,
                        shopName: shopName, shopDescription: shopDescription,
                        rating: rating, status: status,
                        openingHour: openingHour, closingHour: closingHour,
                        shopEmail: shopEmail,
                        barberName: barberName,
                        currentUser: currentUser,
                        hairCategory: hairCategory, price: price,
                        longitudeShop: longitudeShop, latitudeShop: latitudeShop,
                        contactNumber: contactNumber, webSiteUrl: webSiteUrl,
                        gender: gender,
                        address: address, coverPageImage: coverPageImage,
                        barberImage: barberImage, shopImage: shopImage,
                        timestamp: timestamp);
                    debugPrint("edit shop screen ${widget.snapshotData['barberName']}");
                    debugPrint("edit shop screen ${widget.snapshotData['shopEmail']}");
                    // var barberQuerySnapshot = await FirebaseCollection().barberCollection.
                    // where('currentUser',isEqualTo: widget.snapshotData['currentUser']).where('barberName',isEqualTo: widget.snapshotData['barberName']).get();
                    // for(var barberSnapshot in barberQuerySnapshot.docChanges){
                    debugPrint("edit shop screen ${widget.snapshotData['shopEmail']} ${widget.snapshotData['barberName']}");
                      FirebaseCollection().barberCollection.doc('${widget.snapshotData['shopEmail']}${widget.snapshotData['barberName']}').delete();
                      AddShopDetailFirebase().addBarberDetail(
                          uId: uId,
                          userName: userName,
                          shopName: shopName,
                          shopDescription: shopDescription,
                          rating: rating,
                          shopEmail: shopEmail,
                          status: status,
                          openingHour: openingHour,
                          closingHour: closingHour,
                          barberName: barberName,
                          currentUser: currentUser,
                          hairCategory: hairCategory,
                          price: price,
                          longitudeShop: longitudeShop,
                          latitudeShop: latitudeShop,
                          contactNumber: contactNumber,
                          webSiteUrl: webSiteUrl,
                          gender: gender,
                          address: address,
                          coverPageImage: coverPageImage,
                          barberImage: barberImage,
                          shopImage: shopImage,
                          timestamp: timestamp,
                          checkB: true,
                          bName: widget.snapshotData['shopEmail'],
                          bMail: widget.snapshotData['barberName']
                      );
                    if (!mounted) return;
                    // }
                    Navigator.pop(context);
                  });
                }
            }, child: const Text('POST',style: TextStyle(color: AppColor.blackColor,fontFamily: AppFont.regular),)),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StreamBuilder(
                      stream:  FirebaseCollection().userRatingCollection.
                      where('shopName',isEqualTo: widget.snapshotData['shopName']).
                      where('currentUser',isEqualTo: FirebaseAuth.instance.currentUser?.email).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                        if(!snapshot.hasData || snapshot.requireData.docChanges.isEmpty){
                          return RatingBar.builder(
                            initialRating: 0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemSize: 30,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              debugPrint('$rating');
                              setState(() {
                                userRating = 0;
                                buttonVisible = true;
                                ratingList.clear();
                                userRating = rating;
                                debugPrint('first time user Rating in ratingBar => $userRating');
                                debugPrint('first time user Rating in ratingBar rating list => $ratingList');
                              });

                            },
                          );
                        }
                        else if(snapshot.hasData){
                          return RatingBar.builder(
                            initialRating: snapshot.data?.docs[0]['shopRating'],
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemSize: 30,
                            ignoreGestures: false,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) async {
                              setState(() {
                                buttonVisible = true;
                                userRating = 0;
                                ratingList.clear();
                                userRating = rating;
                                debugPrint('user Rated already and change it => $userRating');
                                debugPrint('user Rated already  => ${snapshot.data?.docs[0]['shopRating']}');
                              });

                            },
                          );
                        }
                        else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextFieldMixin().textFieldWidget(
                hintText: 'Describe your experience (Optional)',
                controller: reviewController
              )
            ],
          ),
        ),
      ),
    );
  }
}
