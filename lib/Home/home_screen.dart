import 'dart:async';
import 'package:barber_booking_management/Home/widget/best_salon_service_widget.dart';
import 'package:barber_booking_management/Home/widget/choose_barber_widget.dart';
import 'package:barber_booking_management/Home/widget/popular_category_widget.dart';
import 'package:barber_booking_management/Profile/screen/edit_profile_screen.dart';
import 'package:barber_booking_management/utils/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Addshop/add_shop_screen.dart';
import '../Firebase/firebase_collection.dart';
import '../utils/app_font.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   debugPrint("onBackgroundMessage: $message");
// }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String? userName,userImage,userType,userEmail;

  Future shopDetailsCheck() async{
    print("USER TYPE 2 ${FirebaseAuth.instance.currentUser?.email}");

    var shopQuerySnapshot = await FirebaseCollection().userCollection.where('userEmail',
        isEqualTo: FirebaseAuth.instance.currentUser?.email).get();
   print("USER TYPE 3");

   for(var snapShot in shopQuerySnapshot.docChanges){
      setState(() {
        userName = snapShot.doc.get('userName');
        userImage = snapShot.doc.get('userImage');
        userEmail = snapShot.doc.get('userEmail');
        userType = snapShot.doc.get('userType');
        print("USER TYPE 4 $userType");
      });
    }
  }

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
  void initState() {
    super.initState();
    print("USER TYPE 1");
    shopDetailsCheck();
    print("USER TYPE 5");

  }

  @override
  Widget build(BuildContext context) {
    var hour = DateTime.now().hour;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children:  [
              Stack(
                children: [
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      // color: AppColor.appColorPink,
                      borderRadius:  const BorderRadius.only(
                          bottomLeft: Radius.circular(50),bottomRight: Radius.circular(50)),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [AppColor.appColor,AppColor.appColorPink.withOpacity(0.4)]
                        )
                    ),
                  ),
                  Positioned(
                    top: 20,left: 20,right: 1,
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(userName == null ? '' : 'Hi, ${capitalizeAllWord(userName!)}'
                                      ,style: const TextStyle(fontSize: 12,fontFamily: AppFont.bold),),
                                    const SizedBox(height: 3),
                                    Text(hour < 12 ? 'Good Morning' :
                                    hour < 17 ? 'Good Afternoon' : 'Good Evening',
                                        style: const TextStyle(fontSize: 16,color: AppColor.appColor,fontFamily: AppFont.bold)),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  showDialog(context: context, builder: (BuildContext context){
                                    return AlertDialog(
                                      actionsAlignment: MainAxisAlignment.center,
                                      actions: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                ClipOval(
                                                    child: userImage == "" ? Container(
                                                        color: AppColor.appColor,
                                                        height: 40,width: 40,child: Center(
                                                      child: Text('${userName?.substring(0,1).toUpperCase()}',
                                                        style: const TextStyle(color: AppColor.whiteColor,fontFamily: AppFont.regular),
                                                      ),) ):
                                                    userImage != null ? Image.network(
                                                        '$userImage',
                                                        height: 40,
                                                        width: 40,
                                                        fit: BoxFit.fill) : const SizedBox()
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(20.0,0,10,0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Text(capitalizeAllWord(userName!),style: const TextStyle(fontFamily: AppFont.regular),),
                                                        const SizedBox(height: 3,),
                                                        Text('${FirebaseAuth.instance.currentUser?.email}'
                                                          ,style: const TextStyle(fontSize: 12,fontFamily: AppFont.regular),),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 20),
                                            GestureDetector(
                                                onTap: (){
                                                  Navigator.pop(context);
                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const EditProfileScreen()));
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                                  decoration: BoxDecoration(
                                                    color: AppColor.appColor,
                                                    borderRadius: BorderRadius.circular(10)
                                                  ),
                                                  child: const Text('Edit Your Profile',
                                                  style: TextStyle(fontSize: 12,fontFamily: AppFont.regular,color: AppColor.whiteColor),textAlign: TextAlign.center,),
                                                )),
                                            const SizedBox(height: 10),
                                          ],
                                        )
                                      ],
                                    );
                                  });
                                },
                                child: ClipOval(
                                    child: userImage == "" ? Container(
                                        color: AppColor.appColor,
                                        height: 40,width: 40,child: Center(
                                      child: Text('${userName?.substring(0,1).toUpperCase()}',
                                        style: const TextStyle(color: AppColor.whiteColor,fontFamily: AppFont.regular),
                                      ),) ):
                                    userImage != null ? Image.network(
                                        '$userImage',
                                        height: 55,
                                        width: 55,
                                        fit: BoxFit.cover) : const SizedBox()
                                ),
                              ),

                            ],
                          ),
                        ),
                        const SizedBox(width: 15,),
                      ],
                    ),
                  ),
                ],
              ),
              const BestSalonServiceWidget(),
              const ChooseBarberWidget(),
              const PopularCategoryWidget()
            ],
          ),
        ),
        floatingActionButton: Visibility(
          visible: userType == 'Shop Owner' ? true : false,
          // child: Visibility(
          //visible: currentUserShop != FirebaseAuth.instance.currentUser?.email ? true : false,
          child: FloatingActionButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddShopScreen()));
            },
            child: const Icon(Icons.add),
          ),
          //  ),
        ),
      ),
    );
  }
}
