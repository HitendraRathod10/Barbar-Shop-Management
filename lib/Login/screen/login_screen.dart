import 'package:barber_booking_management/Login/provider/loading_provider.dart';
import 'package:barber_booking_management/Login/provider/login_provider.dart';
import 'package:barber_booking_management/Login/screen/register_screen.dart';
import 'package:barber_booking_management/Login/screen/reset_password.dart';
import 'package:barber_booking_management/mixin/button_mixin.dart';
import 'package:barber_booking_management/mixin/textfield_mixin.dart';
import 'package:barber_booking_management/utils/app_color.dart';
import 'package:barber_booking_management/widget/bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Firebase/firebase_collection.dart';
import '../../utils/app_prefrence_key.dart';
import '../../utils/app_utils.dart';
import '../firebase_auth/login_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailController = TextEditingController(),passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool passwordVisibility = false;
  String? fcmToken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance.getToken().then((value) {
      debugPrint('Token: $value');
      setState(() {
        fcmToken = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0,left: 20,right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Login",
                        style: TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Please sign in to continue',
                        style: TextStyle(
                            color: AppColor.greyColor,fontSize: 12
                        ),
                      ),
                      const SizedBox(height: 50),
                      const Text('Email',style: TextStyle(color: AppColor.appColor)),
                      const SizedBox(height: 5),
                      TextFieldMixin().textFieldWidget(
                        controller: emailController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        hintText: "Enter email",
                        prefixIcon: const Icon(Icons.email_outlined,color: AppColor.appColor),
                        validator: (value) {
                          if (value!.isEmpty || value.trim().isEmpty ) {
                            return 'Please enter an email';
                          }
                          else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@"
                          r"[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)){
                            return 'Please enter valid email';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),
                      const Text('Password',style: TextStyle(color: AppColor.appColor),),
                      const SizedBox(height: 5),
                      TextFieldMixin().textFieldWidget(
                          controller: passwordController,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.visiblePassword,
                          hintText: "Enter password",
                          prefixIcon: const Icon(Icons.lock_outline,color: AppColor.appColor),
                        obscureText: passwordVisibility ? false : true,
                        suffixIcon: IconButton(
                            highlightColor: Colors.transparent,
                            onPressed: () {
                              setState(() {
                                passwordVisibility = !passwordVisibility;
                              });
                            },
                            icon: passwordVisibility ? const Icon(
                              Icons.visibility, color: AppColor.appColor,
                            ) : const Icon(Icons.visibility_off,
                                color: AppColor.appColor)),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim().isEmpty) {
                              return 'Please enter password';
                            }
                            return null;
                          }
                      ),
                      GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ResetPasswordScreen()));
                          },
                          child: Container(
                            alignment: Alignment.topRight,
                              padding: const EdgeInsets.all(10),
                              child:  const Text('Reset Password',style: TextStyle(fontSize: 12),))),
                      const SizedBox(height: 30),
                      GestureDetector(
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            if(_formKey.currentState!.validate()){
                              Provider.of<LoadingProvider>(context,listen: false).startLoading();
                              User? user = await LoginAuth.signInUsingEmailPassword(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                context: context,
                              );
                              if (user != null) {
                                AppUtils.instance.setPref(PreferenceKey.boolKey, PreferenceKey.prefLogin, true);
                                AppUtils.instance.setPref(PreferenceKey.stringKey, PreferenceKey.prefEmail, emailController.text);
                                Provider.of<LoginProvider>(context,listen:false).getSharedPreferenceData(emailController.text);

                                var snapshotData = await FirebaseCollection().userCollection.
                                where('userEmail',isEqualTo: FirebaseAuth.instance.currentUser?.email).get();
                                for(var data in snapshotData.docChanges){
                                  debugPrint('User Name ${data.doc.get('userEmail')}');
                                  LoginProvider().addUserDetail(
                                      userName: data.doc.get("userName"), userEmail: data.doc.get("userEmail"),
                                      userMobile: data.doc.get("userMobile"), userImage: data.doc.get("userImage"),
                                      uId: data.doc.get("uid"),
                                      fcmToken: fcmToken.toString(),
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
                                }

                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const BottomNavBarScreen()));
                                Provider.of<LoadingProvider>(context,listen: false).stopLoading();
                              }
                              Provider.of<LoadingProvider>(context,listen: false).stopLoading();
                            }
                          },
                          child: ButtonMixin().appButton(text: 'Login')),

                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 10,top: 10),
                            child: Text(
                              'Need an account?  ',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color:AppColor.blackColor),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const RegisterScreen()));
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(bottom: 10,top: 10),
                              child: Text(
                                'SIGN UP',
                                style: TextStyle(
                                    fontSize: 15,
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 1,
                                    color:AppColor.appColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ),
    );
  }
}
