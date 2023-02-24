import 'package:barber_booking_management/Home/screen/shop_details_screen.dart';
import 'package:barber_booking_management/shimmers/shop_list_shimmers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../Firebase/firebase_collection.dart';
import '../../utils/app_color.dart';

class PopularCategoryWidget extends StatelessWidget {
  const PopularCategoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseCollection().shopCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot)  {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const ShopListShimmers();
          }else if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          } else if (!snapshot.hasData) {
            return const SizedBox();
          } else if (snapshot.requireData.docChanges.isEmpty){
            return const SizedBox();
          } else{
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20,bottom: 5,right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                                text: "Popular Category",
                                style: TextStyle(
                                  color: AppColor.appColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ShopDetailsScreen(snapshotData: snapshot.data?.docs[index])));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 15,right: 10),
                          child: Card(
                          //  elevation: 5,
                            shape:  RoundedRectangleBorder(
                              borderRadius:
                              index.isEven ?
                              const BorderRadius.only(topRight: Radius.circular(50),bottomLeft: Radius.circular(50)) :
                              const BorderRadius.only(topLeft: Radius.circular(50),bottomRight: Radius.circular(50)),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(snapshot.data?.docs[index]['shopImage'],
                                        height: 100,width: 80,fit: BoxFit.fill
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 20,top: 5,left: 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children:   [
                                              Text(snapshot.data?.docs[index]['shopName'],
                                                  style:  const TextStyle(color: AppColor.appColor),maxLines: 2,overflow: TextOverflow.ellipsis),
                                              const SizedBox(height: 3,),
                                              Row(
                                                children: [
                                                  ClipOval(child: Container(height: 5,width: 5,color: snapshot.data?.docs[index]['shopStatus'] == 'OPEN' ?
                                                  AppColor.appColor : AppColor.redColor,)),
                                                  const SizedBox(width: 5),
                                                  Text(' ${snapshot.data?.docs[index]['shopStatus'].toString().toUpperCase()}',
                                                      style:  const TextStyle(color: AppColor.blackColor,fontSize: 10),maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,textAlign: TextAlign.start),
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  const Icon(Icons.watch_later_outlined,size: 14,color: AppColor.appColor),
                                                  const SizedBox(width: 5,),
                                                  Text('${snapshot.data?.docs[index]['openingHour']} - ${snapshot.data?.docs[index]['closingHour']}',
                                                      style:  const TextStyle(color: AppColor.blackColor,fontSize: 10),maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,textAlign: TextAlign.start),
                                                ],
                                              ),
                                              const SizedBox(height: 3),
                                              Text(snapshot.data?.docs[index]['hairCategory'],
                                                  style: const TextStyle(color: AppColor.blackColor,fontSize: 10),maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,textAlign: TextAlign.start),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(top: 2,left: 10),
                                              child: Text('Price',
                                                  style: TextStyle(color: AppColor.blackColor,fontSize: 10),
                                                  maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(right: 20,top: 2,left: 10),
                                                child: Text('₹${snapshot.data?.docs[index]['price']}',
                                                    style:  const TextStyle(color: AppColor.appColor,fontWeight: FontWeight.bold),
                                                    maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10,top: 3),
                                          child: RatingBar.builder(
                                            initialRating: snapshot.data?.docs[index]['rating'],
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            ignoreGestures : true,
                                            itemSize: 10,
                                            itemBuilder: (context, _) => const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {
                                              debugPrint('$rating');
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                ),
              ],
            );
          }
        }
    );
  }
}
