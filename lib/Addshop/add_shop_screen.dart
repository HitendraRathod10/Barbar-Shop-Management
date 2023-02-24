import 'dart:io';
import 'package:barber_booking_management/Addshop/add_location.dart';
import 'package:barber_booking_management/Addshop/firebase/add_shop_details.dart';
import 'package:barber_booking_management/Addshop/provider/add_shop_provider.dart';
import 'package:barber_booking_management/Firebase/firebase_collection.dart';
import 'package:barber_booking_management/Login/provider/loading_provider.dart';
import 'package:barber_booking_management/Login/provider/login_provider.dart';
import 'package:barber_booking_management/NearBy/current_location.dart';
import 'package:barber_booking_management/mixin/button_mixin.dart';
import 'package:barber_booking_management/mixin/textfield_mixin.dart';
import 'package:barber_booking_management/utils/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../utils/app_utils.dart';
import '../widget/bottom_nav_bar.dart';

class AddShopScreen extends StatefulWidget {

  const AddShopScreen({Key? key}) : super(key: key);

  @override
  State<AddShopScreen> createState() => _AddShopScreenState();
}

class _AddShopScreenState extends State<AddShopScreen> {

  TextEditingController shopNameController = TextEditingController();
  TextEditingController shopDescriptionController = TextEditingController();
  TextEditingController ratingController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  //TextEditingController openingHourController = TextEditingController();
  TextEditingController barberNameController = TextEditingController();
  TextEditingController hairCategoryController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController barberContactController = TextEditingController();
  TextEditingController shopEmailController = TextEditingController();
  File? barberFile,shopImageFile,coverShopImageFile;
  String coverShopImageName ='';
  String barberImageName ='';
  String shopImageName ='';

  //File? barberImage,shopImage,shopCoverPage;
  final _formKey = GlobalKey<FormState>();
  final addPlaceController=TextEditingController();
  final Set<Marker> markers = {};
  late GoogleMapController mapController;
  TimeOfDay? pickedOpeningTime,pickedClosingTime;


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void selectBarberImage(BuildContext context) async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.image
    );
    if(result == null) return;
    final filePath = result.files.single.path;
    File compressImage = await Provider.of<AddShopProvider>(context,listen: false).imageSizeCompress(image: File(filePath!));
    setState(() {
      barberFile = compressImage;
      barberImageName = result.files.first.name;
    });
  }

  void selectCoverShopImage(BuildContext context) async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.image
    );
    if(result == null) return;
    final filePath = result.files.single.path;
    File compressImage = await Provider.of<AddShopProvider>(context,listen: false).imageSizeCompress(image: File(filePath!));
    setState(() {
      coverShopImageFile = compressImage;
      coverShopImageName = result.files.first.name;
    });
  }

  void selectShopImage(BuildContext context) async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.image
    );
    if(result == null) return;
    final filePath = result.files.single.path;
    File compressImage = await Provider.of<AddShopProvider>(context,listen: false).imageSizeCompress(image: File(filePath!));
    setState(() {
      shopImageFile = compressImage;
      shopImageName = result.files.first.name;
    });
  }

  void uploadFile(context) async {
    Provider.of<LoadingProvider>(context,listen: false).startLoading();
    var providerData = Provider.of<AddShopProvider>(context,listen: false);
    //Store Image in firebase database
    if (barberFile == null) return;
    final barberImageDestination = 'barber/${barberImageName}';
    final shopDestination = 'shop/${shopImageName}';
    final shopCoverDestination = 'coverShop/${coverShopImageName}';
    try {
      final barberRef = FirebaseStorage.instance.ref().child(barberImageDestination);
      final shopRef = FirebaseStorage.instance.ref().child(shopDestination);
      final coverShopRef = FirebaseStorage.instance.ref().child(shopCoverDestination);
      UploadTask barberUploadTask =  barberRef.putFile(barberFile!);
      UploadTask shopUploadTask =  shopRef.putFile(shopImageFile!);
      UploadTask coverUploadTask =  coverShopRef.putFile(coverShopImageFile!);
      final snapshot1 = await barberUploadTask.whenComplete(() {});
      final snapshot2 = await shopUploadTask.whenComplete(() {});
      final snapshot3 = await coverUploadTask.whenComplete(() {});
      final barberImageUrl = await snapshot1.ref.getDownloadURL().whenComplete(() {
        // Provider.of<LoadingProvider>(context,listen: false).startLoading();
      });
      final shopImageUrl = await snapshot2.ref.getDownloadURL().whenComplete(() {
        // Provider.of<LoadingProvider>(context,listen: false).startLoading();
      });
      final coverImageUrl = await snapshot3.ref.getDownloadURL().whenComplete(() {
        // Provider.of<LoadingProvider>(context,listen: false).startLoading();
      });
      AppUtils.instance.showToast(toastMessage: "Added Shop Successfully");

      var userSnapShot = await FirebaseCollection().userCollection.
      where('userEmail',isEqualTo: FirebaseAuth.instance.currentUser?.email).get();

      for (var snapshot in userSnapShot.docChanges) {
        LoginProvider().addUserDetail(
            shopName: shopNameController.text,
            shopDescription: shopDescriptionController.text,
            rating: 1.0,
            status: 'Open',
            openingHour: pickedOpeningTime!.format(context).toString(),
            closingHour: pickedClosingTime!.format(context).toString(),
            barberName: barberNameController.text,
            currentUser: FirebaseCollection.userCollectionName,
            hairCategory: Provider.of<AddShopProvider>(context,listen: false).selectHairStyle.toString(),
            price: priceController.text,
            longitudeShop: Provider.of<AddShopProvider>(context,listen: false).longitude,
            latitudeShop: Provider.of<AddShopProvider>(context,listen: false).latitude,
            contactNumber: contactController.text,
            webSiteUrl: websiteController.text,
            gender: Provider.of<AddShopProvider>(context,listen: false).selectGender.toString(),
            address: addressController.text,
            coverPageImage: coverImageUrl,
            barberImage: barberImageUrl, shopImage: shopImageUrl,
            timestamp: Timestamp.now(),
            userName: snapshot.doc.get('userName'),
            userEmail: '${FirebaseAuth.instance.currentUser?.email}',
            uId: snapshot.doc.get('uid'),
            fcmToken: snapshot.doc.get('fcmToken'),
            userMobile: snapshot.doc.get('userMobile'),
            userImage: snapshot.doc.get('userImage'),
            userType: snapshot.doc.get('userType')
        );

        AddShopDetailFirebase().
        addShopDetail(
            uId: FirebaseAuth.instance.currentUser!.uid,
            userName: snapshot.doc.get('userName'),
            shopName: shopNameController.text,
            shopDescription: shopDescriptionController.text,
            rating: 1.0,
            status: 'OPEN',
            openingHour: pickedOpeningTime!.format(context).toString(),
            closingHour: pickedClosingTime!.format(context).toString(),
            barberName: barberNameController.text,
            currentUser: '${FirebaseAuth.instance.currentUser?.email}',
            hairCategory: Provider.of<AddShopProvider>(context,listen: false).selectHairStyle.toString(),
            price: priceController.text,
            longitudeShop: Provider.of<AddShopProvider>(context,listen: false).longitude,
            latitudeShop: Provider.of<AddShopProvider>(context,listen: false).latitude,
            contactNumber: contactController.text,
            webSiteUrl: websiteController.text,
            gender: Provider.of<AddShopProvider>(context,listen: false).selectGender.toString(),
            address: addressController.text,
            coverPageImage: coverImageUrl,
            barberImage: barberImageUrl, shopImage: shopImageUrl,
            timestamp: Timestamp.now(), shopEmail: shopEmailController.text);

        AddShopDetailFirebase().
        addBarberDetail(
            uId: FirebaseAuth.instance.currentUser!.uid,
            userName: snapshot.doc.get('userName'),
            shopName: shopNameController.text,
            shopDescription: shopDescriptionController.text,
            rating: 1.0,
            status: 'OPEN',
            openingHour: pickedOpeningTime!.format(context).toString(),
            closingHour: pickedClosingTime!.format(context).toString(),
            barberName: barberNameController.text,
            currentUser: '${FirebaseAuth.instance.currentUser?.email}',
            hairCategory: Provider.of<AddShopProvider>(context,listen: false).selectHairStyle.toString(),
            price: priceController.text,
            longitudeShop: Provider.of<AddShopProvider>(context,listen: false).longitude,
            latitudeShop: Provider.of<AddShopProvider>(context,listen: false).latitude,
            contactNumber: contactController.text,
            webSiteUrl: websiteController.text,
            gender: 'Male',
            address: addressController.text,
            coverPageImage: coverImageUrl,
            barberImage: barberImageUrl, shopImage: shopImageUrl,
            timestamp: Timestamp.now(), shopEmail: shopEmailController.text);
      }
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) =>
          const BottomNavBarScreen()), (Route<dynamic> route) => false);
      Provider.of<LoadingProvider>(context,listen: false).stopLoading();
    } catch (e) {
      debugPrint('Failed to upload image');
      Provider.of<LoadingProvider>(context,listen: false).stopLoading();
    }
  }

  Future<void> selectOpeningTime(BuildContext context) async {
    pickedOpeningTime = await showTimePicker(
        context: context,
        initialEntryMode: TimePickerEntryMode.input,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light().copyWith(
                primary: AppColor.appColor,
              ),
            ),
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
              child: child!,
            ),
          );
        }
    );

    if (pickedOpeningTime != null && pickedOpeningTime != Provider.of<AddShopProvider>(context,listen: false).selectedOpeningTime ) {
      Provider.of<AddShopProvider>(context,listen: false).selectedOpeningTime = pickedOpeningTime!;
      setState((){});
    }
  }

  Future<void> selectClosingTime(BuildContext context) async {
    pickedClosingTime = await showTimePicker(
        context: context,
        initialEntryMode: TimePickerEntryMode.input,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light().copyWith(
                primary: AppColor.appColor,
              ),
            ), child: MediaQuery(
            data:
            MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          ),
          );
        }
    );

    if (pickedClosingTime != null && pickedClosingTime != Provider.of<AddShopProvider>(context,listen: false).selectedClosingTime ) {
      Provider.of<AddShopProvider>(context,listen: false).selectedClosingTime = pickedClosingTime!;
      setState((){});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    Provider.of<AddShopProvider>(context,listen: false).selectHairStyle = null;
    Provider.of<AddShopProvider>(context,listen: false).selectGender = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Detail'),
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
                        controller: shopNameController,
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
                        controller: barberNameController,
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
                        controller: shopEmailController,
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
                        controller: contactController,
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
                        controller: shopDescriptionController,
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
                        controller: websiteController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        hintText: "Enter shop website url",
                        prefixIcon: const Icon(Icons.web_outlined,color: AppColor.appColor,size: 20),
                      ),
                      const SizedBox(height: 10),
                      TextFieldMixin().textFieldWidget(
                        cursorColor: Colors.black,
                        controller: addressController,
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
                        controller: priceController,
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

                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.only(left: 20,top: 5,bottom: 5,right: 20),
                        decoration: BoxDecoration(
                            color: AppColor.textFieldColor,
                            borderRadius: BorderRadius.circular(10)
                        ),

                        child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                              border: UnderlineInputBorder(borderSide: BorderSide.none)),
                          value: snapshot.selectHairStyle,
                          validator: (value) {
                            if (value == null) {
                              return 'This field is required';
                            }
                            return null;
                          },
                          hint: const Text('Select Hair Category',style: TextStyle(fontSize: 13)),
                          isExpanded: true,
                          isDense: true,
                          style: TextStyle(color: AppColor.blackColor.withOpacity(0.5),fontSize: 13),
                          icon: const Icon(Icons.arrow_drop_down,color: AppColor.appColor),
                          onChanged: (String? newValue) {
                            snapshot.selectHairStyle = newValue!;
                            snapshot.getHairCategory;
                          },
                          items: AddShopProvider().selectHairStyleList
                              .map<DropdownMenuItem<String>>((String leaveName) {
                            return DropdownMenuItem<String>(
                                value: leaveName,
                                child: Row(
                                  children: [
                                    Text(leaveName)
                                  ],
                                )
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.only(left: 20,top: 5,bottom: 5,right: 20),
                        decoration: BoxDecoration(
                            color: AppColor.textFieldColor,
                            borderRadius: BorderRadius.circular(10)
                        ),

                        child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                              border: UnderlineInputBorder(borderSide: BorderSide.none)),
                          value: snapshot.selectGender,
                          validator: (value) {
                            if (value == null) {
                              return 'This field is required';
                            }
                            return null;
                          },
                          hint: const Text('Select Gender',style: TextStyle(fontSize: 13)),
                          isExpanded: true,
                          isDense: true,
                          style: TextStyle(color: AppColor.blackColor.withOpacity(0.5),fontSize: 13),
                          icon: const Icon(Icons.arrow_drop_down,color: AppColor.appColor,),
                          onChanged: (String? newValue) {
                            snapshot.selectGender = newValue!;
                            snapshot.getGender;
                          },
                          items: AddShopProvider().selectGenderList
                              .map<DropdownMenuItem<String>>((String gender) {
                            return DropdownMenuItem<String>(
                                value: gender,
                                child: Row(
                                  children: [
                                    Text(gender)
                                  ],
                                )
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap : () {
                              selectOpeningTime(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColor.textFieldColor,
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              padding: const EdgeInsets.only(top:15,bottom: 15,left: 10,right: 10),
                              child: Text(pickedOpeningTime == null ? "Opening Hour" :
                              Provider.of<AddShopProvider>(context,listen: false).selectedOpeningTime.format(context),
                                style: TextStyle(color: AppColor.blackColor.withOpacity(0.5)),),
                            ),
                          ),
                          GestureDetector(
                            onTap : () {
                              selectClosingTime(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColor.textFieldColor,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              padding: const EdgeInsets.only(top:15,bottom: 15,left: 10,right: 10),
                              child: Text(pickedClosingTime == null ? "Closing Hour" :
                              Provider.of<AddShopProvider>(context,listen: false).selectedClosingTime.format(context),
                                  style: TextStyle(color: AppColor.blackColor.withOpacity(0.5))),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: GestureDetector(
                                onTap: (){
                                  selectBarberImage(context);
                                },
                                child: barberFile == null ?
                                Container(
                                    padding: const EdgeInsets.all(10),
                                    color: AppColor.textFieldColor,
                                    height: MediaQuery.of(context).size.height/8,
                                    width: MediaQuery.of(context).size.height/8,
                                    child:  Center(child: Text('Pick barber Image',style: TextStyle(color: AppColor.blackColor.withOpacity(0.5)),textAlign: TextAlign.center,))) :
                                Image.file(
                                  barberFile!,
                                  height: MediaQuery.of(context).size.height/8,
                                  width: MediaQuery.of(context).size.height/8,
                                  fit: BoxFit.fill,)
                            ),
                          ),

                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: GestureDetector(
                                onTap: (){
                                  selectShopImage(context);
                                },
                                child: shopImageFile == null ?
                                Container(
                                    padding: const EdgeInsets.all(10),
                                    color: AppColor.textFieldColor,
                                    height: MediaQuery.of(context).size.height/8,
                                    width: MediaQuery.of(context).size.height/8,
                                    child: Center(child: Text('Pick Shop Image',style: TextStyle(color: AppColor.blackColor.withOpacity(0.5)),textAlign: TextAlign.center,))) :
                                Image.file(
                                  shopImageFile!,
                                  height: MediaQuery.of(context).size.height/8,
                                  width: MediaQuery.of(context).size.height/8,
                                  fit: BoxFit.fill,)
                            ),
                          ),

                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: GestureDetector(
                                onTap: (){
                                  selectCoverShopImage(context);
                                },
                                child: coverShopImageFile == null ?
                                Container(
                                    padding: const EdgeInsets.all(10),
                                    color: AppColor.textFieldColor,
                                    height: MediaQuery.of(context).size.height/8,
                                    width: MediaQuery.of(context).size.height/8,
                                    child: Center(child: Text('Pick Cover Image',style: TextStyle(color: AppColor.blackColor.withOpacity(0.5)),textAlign: TextAlign.center,))) :
                                Image.file(
                                  coverShopImageFile!,
                                  height: MediaQuery.of(context).size.height/8,
                                  width: MediaQuery.of(context).size.height/8,
                                  fit: BoxFit.fill,)
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      FutureBuilder<LocationData?>(
                          future: CurrentLocation.instance.currentLocation(),
                          builder: (context, locationSnapshot) {
                            if(!locationSnapshot.hasData){
                              return const Center(child: CircularProgressIndicator());
                            }
                            else if(locationSnapshot.connectionState == ConnectionState.done){
                              if(locationSnapshot.hasData){
                                markers.add(Marker(
                                  markerId: const MarkerId("1"),
                                  onTap: (){},
                                  infoWindow: const InfoWindow(title: "Current Location"),
                                  position: LatLng(locationSnapshot.data!.latitude!,locationSnapshot.data!.longitude!),
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                    BitmapDescriptor.hueRed,
                                  ),
                                ));
                                return Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20)
                                      ),
                                      height: 150,width: double.infinity,
                                      child: GoogleMap(
                                        zoomControlsEnabled: false,
                                        onMapCreated: _onMapCreated,
                                        initialCameraPosition: CameraPosition(
                                          target: LatLng(locationSnapshot.data!.latitude!,locationSnapshot.data!.longitude!),
                                          zoom: 11.0,
                                        ),
                                        markers: markers,
                                      ),
                                    ),

                                    Positioned(
                                      bottom: 10,left: 10,
                                      child: InkWell(
                                          child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: Colors.white),
                                              height: 40,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: const [
                                                  Icon(Icons.add_location_alt_outlined,color: AppColor.appColor,size: 18,),
                                                  SizedBox(width: 5),
                                                  Text("Edit From Here",style: TextStyle(fontSize: 12)),
                                                ],
                                              )),
                                          onTap: ()=>
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                              const AddLocationToMapScreen())).then((value) {
                                                snapshot.latitude=value.latitude.toString();
                                                snapshot.longitude=value.longitude.toString();
                                              })
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return const Center(child: CircularProgressIndicator());
                              }
                            }
                            else {
                              return const Center(child: CircularProgressIndicator());
                            }
                          }
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                          onTap: () {
                            if(_formKey.currentState!.validate())
                            {
                              if(barberFile != null && shopImageFile != null && coverShopImageFile != null
                                  && Provider.of<AddShopProvider>(context,listen: false).longitude != '' &&
                                  Provider.of<AddShopProvider>(context,listen: false).latitude != ''){
                                uploadFile(context);
                              } else {
                                AppUtils.instance.showToast(toastMessage: 'All field is required');
                              }
                            }
                          },
                          child: ButtonMixin().appButton(text: 'Add Shop'))

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