import 'package:barber_booking_management/Home/screen/shop_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../Firebase/firebase_collection.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';

class ServiceCategoryScreen extends StatelessWidget {
  const ServiceCategoryScreen({Key? key}) : super(key: key);

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
        title: const Text('Shop Details',style: TextStyle(fontFamily: AppFont.bold),),
      ),
      body:  SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: StreamBuilder(
                stream: FirebaseCollection().shopCollection.snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot)  {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator());
                  }else if (snapshot.hasError) {
                    return const Center(child: Text("Something went wrong",style: TextStyle(fontFamily: AppFont.regular),));
                  } else if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.requireData.docChanges.isEmpty){
                    return const Center(child: Text("No Shop Available",style: TextStyle(fontFamily: AppFont.regular),));
                  } else{
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.1,
                          mainAxisExtent: 261
                      ),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data?.docs.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ShopDetailsScreen(snapshotData: snapshot.data?.docs[index])));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0,right: 5),
                            child: Card(
                              elevation: 5,
                              shape:  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)),
                                    child: Image.network(snapshot.data?.docs[index]['shopImage'],
                                        height: 120,width: double.infinity,fit: BoxFit.fill),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.only(left: 5,right: 5),
                                    child: Text(capitalizeAllWord(snapshot.data?.docs[index]['shopName']),
                                        textAlign:TextAlign.start,maxLines: 2,style: const TextStyle(fontSize: 12,fontFamily: AppFont.semiBold),
                                      overflow: TextOverflow.ellipsis,),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                                    child: Row(
                                      children: [
                                        RatingBar.builder(
                                          initialRating: snapshot.data?.docs[index]['rating'],
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          ignoreGestures : true,
                                          itemSize: 14,
                                          itemBuilder: (context, _) => const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            debugPrint('$rating');
                                          },
                                        ),
                                        const SizedBox(width: 2),
                                        StreamBuilder(
                                            stream: FirebaseCollection().userRatingCollection.
                                            where('shopName',isEqualTo: snapshot.data?.docs[index]['shopName']).snapshots(),
                                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> ratingSnapshot)  {
                                              if(snapshot.connectionState == ConnectionState.waiting){
                                                return const SizedBox();
                                              }else if (snapshot.hasError) {
                                                return const SizedBox();
                                              } else if (!snapshot.hasData) {
                                                return const SizedBox();
                                              } else if (snapshot.requireData.docChanges.isEmpty){
                                                return const SizedBox();
                                              }  else{
                                                return Text(ratingSnapshot.data!.docs.isNotEmpty ?
                                                '(${ratingSnapshot.data?.docs.length.toString()} review)' : '',
                                                  style: const TextStyle(fontSize: 10,fontFamily: AppFont.regular),);
                                              }
                                            }
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5,right: 5,top: 3),
                                    child : Text('₹ ${snapshot.data?.docs[index]['price']}',maxLines: 2,overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: AppColor.appColor,fontFamily: AppFont.regular),textAlign:TextAlign.start),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5,right: 5,top: 3),
                                    child: Text(capitalizeAllWord(snapshot.data?.docs[index]['address']),maxLines: 2,overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: AppColor.blackColor,fontSize: 12,fontFamily: AppFont.regular),textAlign:TextAlign.start),
                                  ),
                                  const SizedBox(height: 5)
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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
