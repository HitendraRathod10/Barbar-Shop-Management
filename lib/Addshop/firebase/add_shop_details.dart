import 'package:barber_booking_management/Firebase/firebase_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AddShopDetailFirebase {

  List shopData = [];

  Future<void> addShopDetail(
      {
        required String uId,
        required String userName,
        required String shopName,
        required String shopDescription,
        required double rating,
        required String status,
        required String openingHour,
        required String closingHour,
        required String shopEmail,
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
        required Timestamp timestamp
      }) async {
    DocumentReference documentReferencer =
    FirebaseCollection().shopCollection.doc('$currentUser$hairCategory');
    Map<String, dynamic> data = <String, dynamic>{
      "userName": userName.toString(),
      "uid": uId.toString(),
      "shopName": shopName.toString(),
      "shopDescription": shopDescription.toString(),
      "rating": rating,
      "openingHour": openingHour.toString(),
      "closingHour": closingHour.toString(),
      "shopStatus": status.toString(),
      "barberName": barberName.toString(),
      "shopEmail": shopEmail.toString(),
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
      "timeStamp" : timestamp
    };
    debugPrint('shop data=> $data');

    FirebaseCollection().shopCollection.get().then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        debugPrint("${result.data()}");
        shopData.add(result.data());
      }
    });
    await documentReferencer
        .set(data)
        .whenComplete(() => debugPrint("Added shop Details"))
        .catchError((e) => debugPrint(e));
  }

  Future<void> addBarberDetail(
      {
        required String uId,
        required String userName,
        required String shopName,
        required String shopDescription,
        required double rating,
        required String shopEmail,
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
        required Timestamp timestamp,
        required bool checkB,
        required String bMail,
        required String bName,
      }) async {

    debugPrint("bMail:$bMail bName:$bName checkB:$checkB");
    DocumentReference documentReferencer =
    FirebaseCollection().barberCollection.doc('${FirebaseAuth.instance.currentUser?.email}$barberName');

    DocumentReference documentReferencerForChooseBarber =
    FirebaseCollection().barberCollection.doc('$bMail$bName');

    Map<String, dynamic> data = <String, dynamic>{
      "userName": userName.toString(),
      "uid": uId.toString(),
      "shopName": shopName.toString(),
      "shopDescription": shopDescription.toString(),
      "rating": rating,
      "shopEmail": shopEmail.toString(),
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
      "timeStamp" : timestamp
    };
    debugPrint('shop data=> $data');

    FirebaseCollection().barberCollection.get().then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        debugPrint("${result.data()}");
        shopData.add(result.data());
      }
    });
    checkB ? await documentReferencerForChooseBarber
        .set(data)
        .whenComplete(() => debugPrint("documentReferencerForChooseBarber Added shop Details"))
        .catchError((e) => debugPrint(e)) :
    await documentReferencer
        .set(data)
        .whenComplete(() => debugPrint("Added shop Details"))
        .catchError((e) => debugPrint(e));
  }

    //new method for update rating in choose your barber widget for that first update the data of barber collection

}