import 'package:barber_booking_management/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../provider/loading_provider.dart';

class LoginAuth {
  static Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String mobile,
    required String fcmToken,
    required String password,
    required BuildContext context,
  })
  async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      Provider.of<LoadingProvider>(context,listen: false).startLoading();
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      await user!.updateDisplayName(name);
      await user.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        AppUtils.instance.showToast(toastMessage: 'The password provided is too weak');
        Provider.of<LoadingProvider>(context,listen: false).stopLoading();
      }
      else if (e.code == 'email-already-in-use') {
        AppUtils.instance.showToast(toastMessage: 'The account already exists for that email');
        Provider.of<LoadingProvider>(context,listen: false).stopLoading();

      }
    } catch (e) {
      debugPrint('$e');
    }
    return user;
  }

  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        AppUtils.instance.showToast(toastMessage: 'No user found for that email');
      }
      else if (e.code == 'wrong-password') {
        AppUtils.instance.showToast(toastMessage: 'Wrong password provided');
      }
    }
    return user;
  }

  Future resetPassword({required String email}) async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email).then((value) {
      AppUtils.instance.showToast(toastMessage: 'sent a reset password link on your gmail account');
    }
    ).catchError((e) {
      AppUtils.instance.showToast(toastMessage: 'No user found that email');
    }
    );
  }

}