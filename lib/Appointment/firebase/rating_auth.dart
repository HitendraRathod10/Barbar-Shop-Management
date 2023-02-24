import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../Firebase/firebase_collection.dart';

class RatingAuth{

  Future<void> userRating(
      { required String shopName,
        required String barberName,
        required String currentUser,
        required String currentDate,
        required double userRating,
        required String userExprience,
        required String userName,
        required String userImage,
        required Timestamp timestamp,
      }
      ) async {
    DocumentReference documentReferencer = FirebaseCollection().userRatingCollection.
    doc('$currentUser $shopName');

    Map<String, dynamic> data = <String, dynamic>{
      "shopName": shopName.toString(),
      "barberName": barberName.toString(),
      'shopRating' : userRating,
      'userExprience' : userExprience.toString(),
      "currentUser": currentUser.toString(),
      "currentDate": currentDate.toString(),
      "userName": userName.toString(),
      "userImage": userImage.toString(),
      "timeStamp" : timestamp
    };
    debugPrint('User Rating Data=> $data');

    await documentReferencer
        .set(data)
        .whenComplete(() => debugPrint('our review will be post'))
        .catchError((e) => debugPrint(e));
  }
}