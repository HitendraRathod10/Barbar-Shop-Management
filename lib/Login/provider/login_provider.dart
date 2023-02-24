import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Firebase/firebase_collection.dart';

class LoginProvider extends ChangeNotifier{

  List<dynamic> userData = [];
  String? userEmail,selectUserType;

  List<String> selectUserTypeList = ['Shop Owner','User'];

  get getUserType {
    notifyListeners();
    return selectUserType;
  }

  getSharedPreferenceData(String? email) {
    userEmail=email;
    notifyListeners();
  }

  onWillPop(context){
    selectUserType = null;
  }

  Future<void> addUserDetail(
      {
        required String uId,
        required String userName,
        required String userEmail,
        required String userMobile,
        required String userImage,
        required String fcmToken,
        required String shopName,
        required String shopDescription,
        required double rating,
        required String status,
        required String openingHour,
        required String closingHour,
        required String barberName,
        required String currentUser,
        required String hairCategory,
        required String price,
        required String longitudeShop,
        required String latitudeShop,
        required String contactNumber,
        required String webSiteUrl,
        required String gender,
        required String address,
        required String coverPageImage,
        required String barberImage,
        required String shopImage,
        required String userType,

        required Timestamp timestamp
      }) async {
    DocumentReference documentReferencer =
    FirebaseCollection().userCollection.doc(userEmail);
    Map<String, dynamic> data = <String, dynamic>{
      "uid": uId.toString(),
      "userEmail": userEmail.toString(),
      "userName": userName.toString(),
      "userMobile": userMobile.toString(),
      "userImage": userImage.toString(),
      "fcmToken": fcmToken.toString(),
      "shopName": shopName.toString(),
      "shopDescription": shopDescription.toString(),
      "rating": rating,
      "openingHour": openingHour.toString(),
      "closingHour": closingHour.toString(),
      "shopStatus": status.toString(),
      "barberName": barberName.toString(),
      "hairCategory": hairCategory.toString(),
      "price": price.toString(),
      "currentUser": currentUser.toString(),
      "longitude": longitudeShop.toString(),
      "latitude": latitudeShop.toString(),
      "contactNumber": contactNumber.toString(),
      "webSiteUrl": webSiteUrl.toString(),
      "gender": gender.toString(),
      "address": address.toString(),
      "coverPageImage": coverPageImage.toString(),
      "barberImage": barberImage.toString(),
      "shopImage": shopImage.toString(),
      "userType": userType.toString(),
      "timeStamp" : timestamp
    };
    debugPrint('user data=> $data');

    FirebaseCollection().userCollection.get().then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        debugPrint("${result.data()}");
        userData.add(result.data());
      }
    });
    await documentReferencer
        .set(data)
        .whenComplete(() => debugPrint("Added user Details"))
        .catchError((e) => debugPrint(e));
  }
}