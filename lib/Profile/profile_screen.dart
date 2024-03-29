import 'package:barber_booking_management/Appointment/Screen/appointment_screen.dart';
import 'package:barber_booking_management/Firebase/firebase_collection.dart';
import 'package:barber_booking_management/Profile/screen/edit_profile_screen.dart';
import 'package:barber_booking_management/Profile/screen/my_shop_screen.dart';
import 'package:barber_booking_management/utils/app_font.dart';
import 'package:barber_booking_management/utils/app_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Login/provider/login_provider.dart';
import '../Login/screen/login_screens_with_tabs.dart';
import '../utils/app_color.dart';
import '../utils/app_utils.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  String capitalizeAllWord(String value) {
    var result = value[0].toUpperCase();
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " ") {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: StreamBuilder(
                stream: FirebaseCollection().userCollection.doc(FirebaseAuth.instance.currentUser?.email).snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot<Object?>> snapshot){
                  if (snapshot.hasError) {
                    return const Center(child: Text("Something went wrong",style: TextStyle(fontFamily: AppFont.regular),));
                  }
                  else if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  else if(snapshot.requireData.exists){
                    Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                    return data['shopName'] != '' ?
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                             const SizedBox(
                              height: 300,width: double.infinity,
                            ),
                            Image.network(
                                data['coverPageImage'],
                                height: 170,
                                width: double.infinity,
                                fit: BoxFit.cover),
                            Positioned(
                              left: 0,right: 0,top: 130,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2,
                                          color: AppColor.whiteColor,
                                        ),
                                        borderRadius: BorderRadius.circular(100)
                                    ),
                                    child: ClipOval(
                                        child:
                                        data['userImage'] == "" ? Container(
                                          color: AppColor.appColor,
                                          height: 80,width: 80,child: Center(
                                          child: Text('${data['userName']?.substring(0,1).toUpperCase()}',
                                              style: const TextStyle(color: AppColor.whiteColor,fontSize: 25,fontFamily: AppFont.regular)),
                                        ),) :
                                        Image.network(
                                            '${data['userImage']}',
                                            height: 80,
                                            width: 80,
                                            fit: BoxFit.fill)
                                    ),
                                  ),
                                  Text(data['userName'],style: const TextStyle(fontSize: 16,color: AppColor.blackColor,fontFamily: AppFont.bold)),
                                  Text(data['shopName'],style: const TextStyle(fontFamily: AppFont.semiBold),),
                                  const SizedBox(height: 5),
                                  /*RatingBar.builder(
                                    initialRating: data['rating'],
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    ignoreGestures : true,
                                    itemSize: 20,
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      debugPrint('$rating');
                                    },
                                  )*/
                                ],
                              ),
                            ),
                            Positioned(
                                right: 5,
                                child: GestureDetector(
                                  onTap: (){},
                                  child: PopupMenuButton<int>(
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 1,
                                        child: Row(
                                          children: [
                                            Image.network('https://cdn-icons-png.flaticon.com/128/8188/8188360.png',scale: 5),
                                            // Icon(Icons.person_outline,color: AppColor.appColor,size: 20),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            const Text("Edit Profile",style: TextStyle(fontSize: 13,fontFamily: AppFont.regular))
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 2,
                                        child: Row(
                                          children: [
                                            Image.network('https://cdn-icons-png.flaticon.com/128/8391/8391024.png',scale: 5,),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            const Text("My Shop",style: TextStyle(fontSize: 13,fontFamily: AppFont.regular))
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 3,
                                        child: Row(
                                          children: [
                                            Image.network('https://cdn-icons-png.flaticon.com/128/1827/1827490.png',scale: 5,),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            const Text("My Appointment",style: TextStyle(fontSize: 13,fontFamily: AppFont.regular))
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 4,
                                        child: Row(
                                          children: [
                                            Image.network('https://cdn-icons-png.flaticon.com/128/4212/4212182.png',scale: 5,),
                                            // Icon(Icons.logout,color: AppColor.appColor,size: 20,),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            const Text("Logout",style: TextStyle(fontSize: 13,fontFamily: AppFont.regular))
                                          ],
                                        ),
                                      ),
                                    ],
                                    offset: const Offset(0, 37),
                                    icon: Image.asset(AppImage.menu,height: 20,width: 17,color: AppColor.whiteColor,),
                                    color: Colors.white,
                                    elevation: 2,
                                    onSelected: (value) {
                                      // if value 1 show dialog
                                      if (value == 1) {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context)=>const EditProfileScreen()));
                                        // if value 2 show dialog
                                      } else if (value == 2) {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context)=>const MyShopScreen()));
                                      }else if (value == 3) {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context)=>const AppointmentScreen()));
                                      }
                                      else if (value == 4) {
                                        FirebaseAuth.instance.signOut()
                                            .then((value){
                                          LoginProvider().addUserDetail(
                                              uId: data['uid'],
                                              userName: data['userName'],
                                              userEmail: data['userEmail'], userMobile: data['userMobile'],
                                              fcmToken: '',
                                              userImage: data['userImage'], timestamp: Timestamp.now(),
                                              shopDescription: data['shopDescription'], barberImage: data['barberImage'],
                                              webSiteUrl: data['webSiteUrl'],
                                              status: data['shopStatus'], barberName: data['barberName'],
                                              gender: data['gender'], longitudeShop: data['longitude'],
                                              shopImage: data['shopImage'], address: data['address'],
                                              rating: data['rating'], shopName: data['shopName'],
                                              hairCategory: data['hairCategory'], currentUser: data['currentUser'],
                                              latitudeShop: data['latitude'], openingHour: data['openingHour'],
                                              coverPageImage: data['coverPageImage'], contactNumber: data['contactNumber'],
                                              price: data['price'],
                                              userType: data['userType'], closingHour: data['closingHour']);

                                        });
                                        AppUtils.instance.clearPref().then((value) =>
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(builder: (BuildContext context) => const LoginScreensWithTabs()),
                                                ModalRoute.withName('/')
                                            ));
                                      }
                                    },
                                  ),
                                )
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0,right: 20,bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('About',style: TextStyle(color: AppColor.greyColor,fontFamily: AppFont.semiBold)),
                              const SizedBox(height: 5),
                              Text(data['shopDescription'],style: const TextStyle(fontSize: 10,fontFamily: AppFont.regular)),

                              Visibility(
                                  visible: data['openingHour'] == '' && data['closingHour'] == '' ? false : true,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10),
                                      const Text('Timing',style: TextStyle(color: AppColor.greyColor,fontFamily: AppFont.semiBold)),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          const Text('Sun - Sun',style: TextStyle(fontSize: 12,fontFamily: AppFont.regular)),
                                          const SizedBox(width: 10),
                                          Text('${data['openingHour']} - ${data['closingHour']}',style: const TextStyle(fontSize: 12,fontFamily: AppFont.regular)),
                                        ],
                                      ),
                                    ],
                                  )),
                              const SizedBox(height: 10),
                              const Text('Address',style:  TextStyle(color: AppColor.greyColor,fontFamily: AppFont.semiBold)),
                              const SizedBox(height: 5),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.location_on,color: AppColor.appColor,),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 00),
                                      child: Text(data['address'],style: const TextStyle(height: 1.3,fontSize: 12,fontFamily: AppFont.regular)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ) :
                    Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 150,
                              // color: AppColor.appColor.withOpacity(0.8),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [AppColor.appColorPink.withOpacity(0.8),AppColor.appColor.withOpacity(0.8)]
                                  )
                              ),
                            ),
                            Positioned(
                              left: 0,right: 0,
                              child: Column(
                                children: [
                                  const SizedBox(height: 30,),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2,
                                          color: AppColor.whiteColor,
                                        ),
                                        borderRadius: BorderRadius.circular(100)
                                    ),
                                    child: ClipOval(
                                        child:
                                        data['userImage'] == "" ? Container(
                                          color: AppColor.whiteColor,
                                          height: 70,width: 70,child: Center(
                                          child: Text('${data['userName']?.substring(0,1).toUpperCase()}',
                                              style: const TextStyle(color: AppColor.appColor,fontSize: 24,fontFamily: AppFont.regular)),
                                        ),) :
                                        Image.network(
                                            '${data['userImage']}',
                                            height: 70,
                                            width: 70,
                                            fit: BoxFit.cover)
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                                right: 5,
                                child: GestureDetector(
                                  onTap: (){},
                                  child: PopupMenuButton<int>(
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 1,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.network('https://cdn-icons-png.flaticon.com/128/8188/8188360.png',scale: 5),
                                            // Icon(Icons.person_outline,color: AppColor.appColor,size: 20),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            const Text("Edit Profile",style: TextStyle(fontSize: 13,fontFamily: AppFont.regular))
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 2,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.network('https://cdn-icons-png.flaticon.com/128/1827/1827490.png',scale: 5,),
                                            // Image.asset(AppImage.appointment,height: 20,width: 20,),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            const Text("My Appointment",style: TextStyle(fontSize: 13,fontFamily: AppFont.regular))
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 3,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.network('https://cdn-icons-png.flaticon.com/128/4212/4212182.png',scale: 5,),
                                            // Icon(Icons.logout,color: AppColor.appColor,size: 20,),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            const Text("Logout",style: TextStyle(fontSize: 13,fontFamily: AppFont.regular))
                                          ],
                                        ),
                                      ),
                                    ],
                                    offset: const Offset(0, 37),
                                    icon: Image.asset(AppImage.menu,height: 20,width: 17,color: AppColor.whiteColor,),
                                    color: Colors.white,
                                    elevation: 2,
                                    onSelected: (value) {
                                      if (value == 1) {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context)=>const EditProfileScreen()));
                                      }else if (value == 2) {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context)=>const AppointmentScreen()));
                                      } else if (value == 3) {
                                        FirebaseAuth.instance.signOut().then((value){
                                          LoginProvider().addUserDetail(
                                              uId: data['uid'],
                                              userName: data['userName'],
                                              userEmail: data['userEmail'], userMobile: data['userMobile'],
                                              fcmToken: '',
                                              userImage: data['userImage'], timestamp: Timestamp.now(),
                                              shopDescription: data['shopDescription'], barberImage: data['barberImage'],
                                              webSiteUrl: data['webSiteUrl'],
                                              status: data['shopStatus'], barberName: data['barberName'],
                                              gender: data['gender'], longitudeShop: data['longitude'],
                                              shopImage: data['shopImage'], address: data['address'],
                                              rating: data['rating'], shopName: data['shopName'],
                                              hairCategory: data['hairCategory'], currentUser: data['currentUser'],
                                              latitudeShop: data['latitude'], openingHour: data['openingHour'],
                                              coverPageImage: data['coverPageImage'], contactNumber: data['contactNumber'],
                                              price: data['price'],
                                              userType: data['userType'], closingHour: data['closingHour']);
                                        });
                                        AppUtils.instance.clearPref().then((value) =>
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(builder: (BuildContext context) => const LoginScreensWithTabs()),
                                                ModalRoute.withName('/')
                                            ));
                                      }
                                    },
                                  ),
                                )
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20,right: 20,top: 40),
                          child: Column(
                            children: [
                              Card(
                                child: Row(
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.only(top: 10,bottom: 10),
                                        margin: const EdgeInsets.only(left: 10,right: 10),
                                        child: Image.network('https://cdn-icons-png.flaticon.com/128/1077/1077114.png',height: 25,width: 25,)),
                                        // child: const Icon(Icons.date_range_outlined,color: AppColor.appColor)),
                                    const SizedBox(height: 5),
                                    Expanded(
                                      child: Container(
                                          padding: const EdgeInsets.only(top: 10,bottom: 10),
                                          margin: const EdgeInsets.only(left: 10,right: 10),
                                          child: Text(capitalizeAllWord(data['userName']),style: const TextStyle(fontSize: 12,fontFamily: AppFont.regular),
                                            maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Card(
                                child: Row(
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.only(top: 10,bottom: 10),
                                        margin: const EdgeInsets.only(left: 10,right: 10),
                                        child: Image.network('https://cdn-icons-png.flaticon.com/128/9775/9775791.png',height: 25,width: 25,)),
                                        // child: const Icon(Icons.email_outlined,color: AppColor.appColor,)),
                                    const SizedBox(height: 5,),
                                    Expanded(
                                      child: Container(
                                          padding: const EdgeInsets.only(top: 10,bottom: 10),
                                          margin: const EdgeInsets.only(left: 10,right: 10),
                                          child: Text(data['userEmail'],style: const TextStyle(fontSize: 12,fontFamily: AppFont.regular),
                                            maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Card(
                                child: Row(
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.only(top: 10,bottom: 10),
                                        margin: const EdgeInsets.only(left: 10,right: 10),
                                        child: Image.network('https://cdn-icons-png.flaticon.com/128/9637/9637721.png',height: 25,width: 25,)),
                                        // child: const Icon(Icons.phone_android_outlined,color: AppColor.appColor,)),
                                    const SizedBox(height: 5,),
                                    Container(
                                        padding: const EdgeInsets.only(top: 10,bottom: 10),
                                        margin: const EdgeInsets.only(left: 10,right: 10),
                                        child: Text(data['userMobile'],style: const TextStyle(fontSize: 12,fontFamily: AppFont.regular))),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        )
                      ],
                    );
                  }
                  else {
                    return const Center(child: CircularProgressIndicator());
                  }
              }
            ),
          )
        )
      );
  }
}
