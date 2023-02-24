import 'package:barber_booking_management/Firebase/firebase_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class BookAppointment {

  List appointmentData = [];

  Future<void> bookAppointment(
      {
        required String shopName,
        required String shopDescription,
        required String shopEmail,
        required String barberName,
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

        required String userName,
        required String userMobile,
        required String userEmail,
        required String userImage,
        required String userAppointmentDate,
        required String userAppointmentTime,

        required Timestamp timestamp
      }) async {
    DocumentReference documentReferencer =
    FirebaseCollection().bookAppointmentCollection.doc('$shopName $userAppointmentDate $userAppointmentTime');
    Map<String, dynamic> data = <String, dynamic>{
      "shopName": shopName.toString(),
      "shopDescription": shopDescription.toString(),
      "shopEmail": shopEmail.toString(),
      "barberName": barberName.toString(),
      "hairCategory": hairCategory.toString(),
      "price": price,
      "longitude": longitudeShop.toString(),
      "latitude": latitudeShop.toString(),
      "contactNumber": contactNumber.toString(),
      "webSiteUrl": webSiteUrl.toString(),
      "gender": gender.toString(),
      "address": address.toString(),
      "coverPageImage": coverPageImage.toString(),
      "barberImage": barberImage.toString(),
      "shopImage": shopImage.toString(),

      "userName": userName.toString(),
      "userEmail": userEmail.toString(),
      "userImage": userImage.toString(),
      "userMobile": userMobile.toString(),
      "userAppointmentDate": userAppointmentDate.toString(),
      "userAppointmentTime": userAppointmentTime.toString(),

      "timeStamp" : timestamp
    };
    debugPrint('appointment data=> $data');

    FirebaseCollection().bookAppointmentCollection.get().then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        debugPrint("${result.data()}");
        appointmentData.add(result.data());
      }
    });
    await documentReferencer
        .set(data)
        .whenComplete(() => debugPrint("Book Seat"))
        .catchError((e) => debugPrint(e));
  }

}