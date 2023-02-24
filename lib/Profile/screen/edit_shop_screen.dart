import 'dart:io';
import 'package:barber_booking_management/Addshop/firebase/add_shop_details.dart';
import 'package:barber_booking_management/Addshop/provider/add_shop_provider.dart';
import 'package:barber_booking_management/Firebase/firebase_collection.dart';
import 'package:barber_booking_management/Login/provider/login_provider.dart';
import 'package:barber_booking_management/mixin/button_mixin.dart';
import 'package:barber_booking_management/mixin/textfield_mixin.dart';
import 'package:barber_booking_management/utils/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../Appointment/firebase/rating_auth.dart';


class EditShopScreen extends StatefulWidget {

  var snapshotData;

  EditShopScreen({Key? key,required this.snapshotData}) : super(key: key);

  @override
  State<EditShopScreen> createState() => _EditShopScreenState();
}

class _EditShopScreenState extends State<EditShopScreen> {

  TextEditingController shopNameController = TextEditingController();
  TextEditingController shopDescriptionController = TextEditingController();
  TextEditingController ratingController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController barberNameController = TextEditingController();
  TextEditingController hairCategoryController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController barberContactController = TextEditingController();
  TextEditingController shopEmailController = TextEditingController();

  late File barberImage,shopImage,shopCoverPage;
  final _formKey = GlobalKey<FormState>();
  final addPlaceController=TextEditingController();
  final Set<Marker> markers = {};
  late GoogleMapController mapController;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Shop'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Consumer<AddShopProvider>(
                builder: (BuildContext context, snapshot, Widget? child) {
                  return Column(
                    children: [
                      TextFieldMixin().textFieldWidget(
                        cursorColor: Colors.black,
                        controller: shopNameController..text = widget.snapshotData['shopName'],
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        hintText: "Enter Shop name",
                        prefixIcon: const Icon(Icons.shopping_basket_outlined,color: AppColor.appColor,size: 20),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().isEmpty) {
                            return 'Please enter shop name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFieldMixin().textFieldWidget(
                        cursorColor: Colors.black,
                        controller: barberNameController..text = widget.snapshotData['barberName'],
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        hintText: "Enter barber name",
                        prefixIcon: const Icon(Icons.person_outline,color: AppColor.appColor,size: 20),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().isEmpty) {
                            return 'Please enter barber name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFieldMixin().textFieldWidget(
                        cursorColor: Colors.black,
                        controller: shopEmailController..text = widget.snapshotData['shopEmail'],
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        hintText: "Enter shop email",
                        prefixIcon: const Icon(Icons.email_outlined,color: AppColor.appColor,size: 20),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().isEmpty) {
                            return 'Please enter shop email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFieldMixin().textFieldWidget(
                        cursorColor: Colors.black,
                        controller: contactController..text = widget.snapshotData['contactNumber'],
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        hintText: "Enter Contact Number",
                        prefixIcon: const Icon(Icons.phone_android_outlined,color: AppColor.appColor,size: 20),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().isEmpty) {
                            return 'Please enter phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFieldMixin().textFieldWidget(
                        cursorColor: Colors.black,
                        maxLines: 4,
                        controller: shopDescriptionController..text = widget.snapshotData['shopDescription'],
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        hintText: "Enter Shop Description",
                        prefixIcon: const Icon(Icons.description_outlined,color: AppColor.appColor,size: 20),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().isEmpty) {
                            return 'Please enter shop description';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 10),
                      TextFieldMixin().textFieldWidget(
                        cursorColor: Colors.black,
                        controller: websiteController..text = widget.snapshotData['webSiteUrl'],
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        hintText: "Enter shop website url",
                        prefixIcon: const Icon(Icons.web_outlined,color: AppColor.appColor,size: 20),
                      ),
                      const SizedBox(height: 10),
                      TextFieldMixin().textFieldWidget(
                        cursorColor: Colors.black,
                        controller: addressController..text = widget.snapshotData['address'],
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        hintText: "Enter address",
                        prefixIcon: const Icon(Icons.location_on_outlined,color: AppColor.appColor,size: 20,),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().isEmpty) {
                            return 'Please enter address';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 10),
                      TextFieldMixin().textFieldWidget(
                        cursorColor: Colors.black,
                        controller: priceController..text = widget.snapshotData['price'],
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        hintText: "Enter price",
                        prefixIcon: const Icon(Icons.price_change,color: AppColor.appColor,size: 20,),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().isEmpty) {
                            return 'Please enter price';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                          onTap: () async{
                            if(_formKey.currentState!.validate())
                            {
                              var querySnapshot = await FirebaseCollection().
                              userRatingCollection.where('shopName',isEqualTo: widget.snapshotData['shopName']).get();

                              var barberQuerySnapshot = await FirebaseCollection().
                              barberCollection.where('currentUser',isEqualTo: widget.snapshotData['currentUser']).
                              where('barberName',isEqualTo: widget.snapshotData['barberName']).get();

                              var userQuerySnapshot = await FirebaseCollection().
                              userCollection.where('userEmail',isEqualTo: FirebaseAuth.instance.currentUser?.email).get();

                              print("1111... ${FirebaseAuth.instance.currentUser?.email}  000  ${widget.snapshotData['hairCategory']}");
                              AddShopDetailFirebase().
                              addShopDetail(
                                  shopName: shopNameController.text,
                                  shopDescription: shopDescriptionController.text,
                                  rating: widget.snapshotData['rating'],
                                  uId: widget.snapshotData['uid'],
                                  userName: widget.snapshotData['userName'],
                                  status: widget.snapshotData['shopStatus'],
                                  openingHour: widget.snapshotData['openingHour'],
                                  closingHour: widget.snapshotData['closingHour'],
                                  barberName: barberNameController.text,
                                  currentUser: '${FirebaseAuth.instance.currentUser?.email}',
                                  hairCategory: widget.snapshotData['hairCategory'],
                                  price: priceController.text,
                                  longitudeShop: widget.snapshotData['longitude'],
                                  latitudeShop: widget.snapshotData['latitude'],
                                  contactNumber: contactController.text,
                                  webSiteUrl: websiteController.text,
                                  gender: widget.snapshotData['gender'],
                                  address: addressController.text,
                                  coverPageImage: widget.snapshotData['coverPageImage'],
                                  barberImage: widget.snapshotData['barberImage'],
                                  shopImage: widget.snapshotData['shopImage'],
                                  timestamp: Timestamp.now(), shopEmail: shopEmailController.text);

                              for(var ratingSnapshot in querySnapshot.docChanges){
                                FirebaseCollection().userRatingCollection.doc('${ratingSnapshot.doc.get("currentUser")} ${widget.snapshotData['shopName']}').delete();
                                RatingAuth().userRating(
                                    shopName: shopNameController.text,
                                    barberName: barberNameController.text,
                                    currentUser: ratingSnapshot.doc.get("currentUser"),
                                    currentDate: DateTime.now().toString().substring(0,10),
                                    userRating: ratingSnapshot.doc.get("shopRating"),
                                    userExprience: ratingSnapshot.doc.get("userExprience"),
                                    timestamp: Timestamp.now(),
                                    userName: ratingSnapshot.doc.get('userName'),
                                    userImage: ratingSnapshot.doc.get('userImage'),
                                );
                              }

                              for(var barberSnapshot in barberQuerySnapshot.docChanges){
                                FirebaseCollection().barberCollection.doc('${barberSnapshot.doc.get("currentUser")}${widget.snapshotData['barberName']}').delete();
                                AddShopDetailFirebase().addBarberDetail(
                                    shopName: shopNameController.text,
                                    shopDescription: shopDescriptionController.text,
                                    rating: widget.snapshotData['rating'],
                                    uId: widget.snapshotData['uid'],
                                    userName: widget.snapshotData['userName'],
                                    status: widget.snapshotData['shopStatus'],
                                    openingHour: widget.snapshotData['openingHour'],
                                    closingHour: widget.snapshotData['closingHour'],
                                    barberName: barberNameController.text,
                                    currentUser: '${FirebaseAuth.instance.currentUser?.email}',
                                    hairCategory: widget.snapshotData['hairCategory'],
                                    price: priceController.text,
                                    longitudeShop: widget.snapshotData['longitude'],
                                    latitudeShop: widget.snapshotData['latitude'],
                                    contactNumber: contactController.text,
                                    webSiteUrl: websiteController.text,
                                    gender: widget.snapshotData['gender'],
                                    address: addressController.text,
                                    coverPageImage: widget.snapshotData['coverPageImage'],
                                    barberImage: widget.snapshotData['barberImage'],
                                    shopImage: widget.snapshotData['shopImage'],
                                    timestamp: Timestamp.now(), shopEmail: shopEmailController.text
                                );
                              }

                              for(var userSnapshot in userQuerySnapshot.docChanges){
                                LoginProvider().addUserDetail(
                                    uId: userSnapshot.doc.get('uid'),
                                    userName: userSnapshot.doc.get('userName'),
                                    userEmail: userSnapshot.doc.get('userEmail'),
                                    userMobile: userSnapshot.doc.get('userMobile'),
                                    fcmToken: userSnapshot.doc.get("fcmToken"),
                                    userImage: userSnapshot.doc.get('userImage'),
                                    userType: userSnapshot.doc.get('userType'),
                                    shopName: shopNameController.text,
                                    shopDescription: shopDescriptionController.text,
                                    rating: widget.snapshotData['rating'],
                                    status: widget.snapshotData['shopStatus'],
                                    openingHour: widget.snapshotData['openingHour'],
                                    closingHour: widget.snapshotData['closingHour'],
                                    barberName: barberNameController.text,
                                    currentUser: '${FirebaseAuth.instance.currentUser?.email}',
                                    hairCategory: widget.snapshotData['hairCategory'],
                                    price: priceController.text,
                                    longitudeShop: widget.snapshotData['longitude'],
                                    latitudeShop: widget.snapshotData['latitude'],
                                    contactNumber: contactController.text,
                                    webSiteUrl: websiteController.text,
                                    gender: widget.snapshotData['gender'],
                                    address: addressController.text,
                                    coverPageImage: widget.snapshotData['coverPageImage'],
                                    barberImage: widget.snapshotData['barberImage'],
                                    shopImage: widget.snapshotData['shopImage'],
                                    timestamp: Timestamp.now(),
                                );
                             }
                              Navigator.pop(context);
                            }
                          },
                          child: ButtonMixin().appButton(text: 'Edit Shop'))
                    ],
                  );
                }
            ),
          ),
        ),
      ),
    );
  }
}
