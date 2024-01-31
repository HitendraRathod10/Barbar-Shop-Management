import 'package:barber_booking_management/Home/screen/barber_screen.dart';
import 'package:barber_booking_management/Home/screen/shop_details_screen.dart';
import 'package:barber_booking_management/shimmers/barber_shimmer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Firebase/firebase_collection.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';

class ChooseBarberWidget extends StatelessWidget {
  const ChooseBarberWidget({Key? key}) : super(key: key);

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
    return StreamBuilder(
        stream: FirebaseCollection().barberCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot)  {
          if(snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none){
            return const BarberShimmers();
          }else if (snapshot.hasError) {
            return const BarberShimmers();
          } else if (!snapshot.hasData) {
            return const BarberShimmers();
          } else if (snapshot.requireData.docChanges.isEmpty){
            return const SizedBox();
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20,bottom: 10,right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                                text: "Choose Your Barber",
                                style: TextStyle(
                                  color: AppColor.appColor,
                                  fontSize: 16,
                                    fontFamily: AppFont.bold
                                ))
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const BarberScreen()));
                        },
                        child: const Padding(
                            padding:  EdgeInsets.all(10),
                            child: Text('View All',style: TextStyle(color: Colors.blue,fontSize: 12,fontFamily: AppFont.regular),)),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 93,
                  margin: const EdgeInsets.only(left: 10,bottom: 5),
                  child: Scrollbar(
                    child: ListView.builder(
                        itemCount: snapshot.data?.docChanges.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ShopDetailsScreen(snapshotData: snapshot.data?.docs[index])));
                            },
                            child: SizedBox(
                              width: 90,
                              height: 90,
                              child: Column(
                                children: [
                                  ClipOval(
                                    child: Image.network(snapshot.data?.docs[index]['barberImage'],
                                      height: 55,width: 55,fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 5,),
                                  Text(capitalizeAllWord(snapshot.data?.docs[index]['barberName']),
                                    style: const TextStyle(fontSize: 10,fontFamily: AppFont.regular),
                                    textAlign: TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis,)
                                ],
                              ),
                            ),
                          );
                        }
                    ),
                  ),
                ),
              ],
            );
          }
      }
    );
  }
}
