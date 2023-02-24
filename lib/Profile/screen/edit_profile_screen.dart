import 'dart:io';
import 'package:barber_booking_management/Login/provider/login_provider.dart';
import 'package:barber_booking_management/utils/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:provider/provider.dart';

import '../../Firebase/firebase_collection.dart';
import '../../Login/provider/loading_provider.dart';
import '../../mixin/button_mixin.dart';
import '../../mixin/textfield_mixin.dart';
import '../../utils/app_utils.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  //TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();


  File? file;
  var url = '';

  @override
  Widget build(BuildContext context) {

    final formKey = GlobalKey<FormState>();

    Future<File> imageSizeCompress({required File image, quality = 100, percentage = 10}) async {
      var path = await FlutterNativeImage.compressImage(image.absolute.path,quality: 100,percentage: 60);
      return path;
    }

    void selectImage(BuildContext context) async{
      //Pick Image File
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.image
      );
      if(result == null) return;
      final filePath = result.files.single.path;
      File compressImage = await imageSizeCompress(image: File(filePath!));
      setState((){
        file = compressImage;
      });
    }

    void uploadFile() async {
      //_selectProfileImage(context);
      //Store Image in firebase database
      Provider.of<LoadingProvider>(context,listen: false).startLoading();
      if (file == null) return;
      final fireauth = FirebaseAuth.instance.currentUser?.email;
      final destination = 'images/$fireauth';
      try {
        final ref = FirebaseStorage.instance.ref().child(destination);
        UploadTask uploadsTask =  ref.putFile(file!);
        final snapshot = await uploadsTask.whenComplete(() {});
        final imageUrl = await snapshot.ref.getDownloadURL().whenComplete(() {});

        var snapshotData = await FirebaseCollection().userCollection.
        where('userEmail',isEqualTo: FirebaseAuth.instance.currentUser?.email).get();
        for(var data in snapshotData.docChanges){
          debugPrint('User Name ${data.doc.get('userEmail')}');
          LoginProvider().addUserDetail(
              userName: nameController.text, userEmail: data.doc.get('userEmail'),
              userMobile: mobileController.text, userImage: imageUrl,
              uId: data.doc.get("uid"),
              fcmToken: data.doc.get("fcmToken"),
              shopName: data.doc.get("shopName"), shopDescription: data.doc.get('shopDescription'),
              rating: data.doc.get('rating'), status: data.doc.get('shopStatus'),
              openingHour: data.doc.get('openingHour'),
              closingHour: data.doc.get('closingHour'), barberName: data.doc.get('barberName'),
              currentUser: data.doc.get('currentUser'), hairCategory: data.doc.get('hairCategory'),
              price: data.doc.get('price'), longitudeShop: data.doc.get('longitude'),
              latitudeShop: data.doc.get('latitude'),
              contactNumber: data.doc.get('contactNumber'), webSiteUrl: data.doc.get('webSiteUrl'),
              gender: data.doc.get('gender'),
              address: data.doc.get('address'), coverPageImage: data.doc.get('coverPageImage'),
              barberImage: data.doc.get('barberImage'), shopImage: data.doc.get('shopImage'),
              userType: data.doc.get('userType'), timestamp: data.doc.get('timeStamp'));
          AppUtils.instance.showToast(toastMessage: "Update Profile");
        }
        Provider.of<LoadingProvider>(context,listen: false).stopLoading();
        Navigator.pop(context);
        debugPrint("Image URL = $imageUrl");
      } catch (e) {
        print('Failed to upload image');
        Provider.of<LoadingProvider>(context,listen: false).stopLoading();

      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: StreamBuilder(
            stream: FirebaseCollection().userCollection.doc(FirebaseAuth.instance.currentUser?.email).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text("Something went wrong"));
              } else if (!snapshot.hasData || !snapshot.data!.exists) {
                print('Document does not exist');
                return const Center(child: CircularProgressIndicator());
              }
              else if(snapshot.requireData.exists){
                Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Stack(
                        clipBehavior: Clip.none,
                        children : [
                          GestureDetector(
                            onTap: (){
                              selectImage(context);
                            },
                            child: ClipOval(
                              child: file == null ?
                              data['userImage'] == "" ? Container(
                                color: AppColor.appColor,
                                height: 80,width: 80,child: Center(
                                child: Text('${data['userName']?.substring(0,1).toUpperCase()}',
                                    style: const TextStyle(color: AppColor.whiteColor,fontSize: 20)),
                              ),) :
                              Image.network(
                                  '${data['userImage']}',
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.fill) :
                              Image.file(
                                file!,
                                height: 80,width: 80,
                                fit: BoxFit.fill,),
                            ),
                          ),
                          Positioned(
                            left: 50,
                            top: 50,
                            child: ClipOval(child: Container(
                              height: 30,width: 30,
                              color:AppColor.whiteColor,child: const Icon(Icons.camera_alt,color: AppColor.appColor,size: 20))),
                          )
                        ]
                    ),
                    Container(
                      margin: const EdgeInsets.only(top:5),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          TextFieldMixin().textFieldWidget(
                            controller: nameController..text = data['userName'],
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            hintText: "Enter Name",
                            prefixIcon: const Icon(Icons.person_outline,color: AppColor.appColor),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().isEmpty) {
                                return 'Please enter name';
                              }
                              return null;
                            },
                          ),
                          // const SizedBox(height: 10,),
                          // TextFieldMixin().textFieldWidget(
                          //   controller: emailController..text = data['userEmail'],
                          //   readOnly: true,
                          //   textInputAction: TextInputAction.next,
                          //   keyboardType: TextInputType.emailAddress,
                          //   hintText: "Enter email",
                          //   prefixIcon: const Icon(Icons.email_outlined,color: AppColor.appColor),
                          //   validator: (value) {
                          //     if (value!.isEmpty ||
                          //         value.trim().isEmpty ||
                          //         !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@"
                          //         r"[a-zA-Z0-9]+\.[a-zA-Z]+")
                          //             .hasMatch(value)) {
                          //       return 'Enter a valid email';
                          //     }
                          //     return null;
                          //   },
                          // ),
                          const SizedBox(height: 10,),
                          TextFieldMixin().textFieldWidget(
                            controller: mobileController..text = data['userMobile'],
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.phone,
                            hintText: "Enter Phone Number",
                            prefixIcon: const Icon(Icons.phone_android_outlined,color: AppColor.appColor),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().isEmpty) {
                                return 'Please enter phone number';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () async {
                                if(formKey.currentState!.validate() ) {
                                  if(file != null){
                                    uploadFile();
                                  } else{
                                    LoginProvider().addUserDetail(
                                        userName: nameController.text, userEmail: data['userEmail'],
                                        userMobile: mobileController.text, userImage: data['userImage'],
                                        uId: data['uid'],
                                        fcmToken: data['fcmToken'],
                                        shopName: data['shopName'], shopDescription: data['shopDescription'],
                                        rating: data['rating'], status: data['shopStatus'], openingHour: data['openingHour'],
                                        closingHour: data['closingHour'], barberName: data['barberName'],
                                        currentUser: data['currentUser'], hairCategory: data['hairCategory'],
                                        price: data['price'], longitudeShop: data['longitude'], latitudeShop: data['latitude'],
                                        contactNumber: data['contactNumber'], webSiteUrl: data['webSiteUrl'], gender: data['gender'],
                                        address: data['address'], coverPageImage: data['coverPageImage'],
                                        barberImage: data['barberImage'], shopImage: data['shopImage'],
                                        userType: data['userType'], timestamp: data['timeStamp']);
                                    Navigator.pop(context);
                                    //Navigator.push(context, MaterialPageRoute(builder: (context)=>const BottomNavBarScreen()));
                                  }
                                }
                              },
                              child: ButtonMixin()
                                  .appButton(onPress: () {}, text: 'Edit Profile'),
                            ),
                          ),
                          const SizedBox(height: 20)
                        ],
                      ),
                    ),
                  ],
                );
              }
              else if (snapshot.connectionState == ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              } else{
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
