import 'package:barber_booking_management/Home/screen/shop_details_screen.dart';
import 'package:barber_booking_management/utils/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Firebase/firebase_collection.dart';
import '../../utils/app_font.dart';

class BarberScreen extends StatelessWidget {
  const BarberScreen({Key? key}) : super(key: key);

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Barber',style: TextStyle(fontFamily: AppFont.bold),),
      ),
        body:  SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: StreamBuilder(
                  stream: FirebaseCollection().barberCollection.snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot)  {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(child: CircularProgressIndicator());
                    }else if (snapshot.hasError) {
                      return const Center(child: Text("Something went wrong",style: TextStyle(fontFamily: AppFont.regular),));
                    } else if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.requireData.docChanges.isEmpty){
                      return const Center(child: Text("No Data Found",style: TextStyle(fontFamily: AppFont.regular),));
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 0,
                                childAspectRatio: 0.3,
                                mainAxisExtent: 135
                            ),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data?.docChanges.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ShopDetailsScreen(snapshotData: snapshot.data?.docs[index])));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0,right: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ClipOval(
                                        //borderRadius: const BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)),
                                        child: Image.network(snapshot.data?.docs[index]['barberImage'],
                                            height: 80,width: 80,fit: BoxFit.fill),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(capitalizeAllWord(snapshot.data?.docs[index]['barberName']),maxLines: 2,overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(color: AppColor.blackColor,fontSize: 12,fontFamily: AppFont.medium),textAlign:TextAlign.center),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20,)
                        ],
                      );
                    }
                }
              ),
            ),
          ),
        )
    );
  }
}
