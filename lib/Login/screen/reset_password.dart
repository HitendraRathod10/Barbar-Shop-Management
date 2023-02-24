import 'package:barber_booking_management/utils/app_image.dart';
import 'package:flutter/material.dart';
import '../../mixin/button_mixin.dart';
import '../../mixin/textfield_mixin.dart';
import '../../utils/app_color.dart';
import '../firebase_auth/login_auth.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({Key? key}) : super(key: key);

  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(AppImage.resetPassword,
                      height: 70,width: 70,fit: BoxFit.fill),
                  const SizedBox(height: 15),
                  const Text('Reset Your Password',style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 5,),
                  const Text('Provider your account email for which you want to reset your password',style: TextStyle(
                    color: AppColor.greyColor,fontSize: 12
                  ),),
                  const SizedBox(height: 40),
                  const Text('Email',style: TextStyle(color: AppColor.appColor)),
                  const SizedBox(height: 5),
                  TextFieldMixin().textFieldWidget(
                    controller: emailController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.emailAddress,
                    hintText: "Enter email",
                    prefixIcon: const Icon(Icons.email_outlined,color: AppColor.appColor),
                    validator: (value) {
                      if (value!.isEmpty ||
                          value.trim().isEmpty) {
                        return 'Please enter an email';
                      } else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@"
                      r"[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)){
                        return 'Please enter valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          LoginAuth().resetPassword(email: emailController.text.trim());
                        }
                      },
                      child: ButtonMixin()
                          .appButton(onPress: () {}, text: 'Reset Password'),
                    ),
                  ),
                  const SizedBox(height: 20)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
