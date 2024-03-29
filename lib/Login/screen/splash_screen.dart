import 'dart:async';
import 'package:barber_booking_management/widget/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
import '../../utils/app_image.dart';
import '../../utils/app_prefrence_key.dart';
import '../../utils/app_utils.dart';
import 'login_screens_with_tabs.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>{

  bool isUserLogin=false;
  String? email;

  getPreferenceData()async{
    isUserLogin= await AppUtils.instance.getPreferenceValueViaKey(PreferenceKey.prefLogin)??false;
    email=await AppUtils.instance.getPreferenceValueViaKey(PreferenceKey.prefEmail)?? "";
    setState(() {});
    Timer(
        const Duration(seconds: 3), (){
        if(isUserLogin){
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) =>  const BottomNavBarScreen()));
        } else{
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) =>  const LoginScreensWithTabs()));
        }
    });
  }

  @override
  void initState() {
    super.initState();
    getPreferenceData();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColor.appColor,
      body: Center(
        child:Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Image.asset(AppImage.appIcon,height: 200,width: 200,fit: BoxFit.fill),
              const Text('The Barber Shop - Hair Salon',textAlign: TextAlign.center,style: TextStyle(color: Color(0xffFDE2EA),fontSize: 18,fontFamily: AppFont.bold))
            ],
          ),
        ),
      ),
    );
  }
}