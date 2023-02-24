import 'package:barber_booking_management/Firebase/firebase_collection.dart';
import 'package:barber_booking_management/Home/screen/shop_details_screen.dart';
import 'package:barber_booking_management/shimmers/category_shimmers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Category/screen/service_category_shop_screen.dart';
import '../../utils/app_color.dart';

class BestSalonServiceWidget extends StatelessWidget {
  const BestSalonServiceWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseCollection().shopCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot)  {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const CategoryShimmers();
          }else if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          } else if (!snapshot.hasData) {
            return const SizedBox();
          } else if (snapshot.requireData.docChanges.isEmpty){
            return const SizedBox();
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20,bottom: 10,right: 20,top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                                text: "Best Salon Service",
                                style: TextStyle(
                                  color: AppColor.appColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ))
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const ServiceCategoryScreen()));
                        },
                        child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('View All',style: TextStyle(color: AppColor.greyColor,fontSize: 12))),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 190,
                  child: ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context,index) {
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ShopDetailsScreen(snapshotData: snapshot.data?.docs[index])));
                          },
                          child: Container(
                            width: 200,
                            height: 180,
                            padding: const EdgeInsets.only(left:20,right: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)),
                                      child: Image.network(snapshot.data?.docs[index]['shopImage'],
                                          height: 120,width: double.infinity,fit: BoxFit.fill),
                                    ),
                                    Positioned(
                                        bottom: 10,left: 10,right: 10,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(left: 5,right: 10,top: 1,bottom: 1),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(7),
                                                  color: AppColor.whiteColor
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.star,color: Colors.amber,size: 20,),
                                                  const SizedBox(width: 2),
                                                  Text('${snapshot.data?.docs[index]['rating'].toString().substring(0,3)}',
                                                    style: TextStyle(fontSize: 12,color: AppColor.blackColor.withOpacity(0.6)),)
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            Container(
                                              padding: const EdgeInsets.only(left: 10,right: 10,top: 3,bottom: 3),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  color: snapshot.data?.docs[index]['shopStatus'] == 'OPEN' ?
                                                  AppColor.beachColor1 : AppColor.summerColor3
                                              ),
                                              child: Text(snapshot.data?.docs[index]['shopStatus'],
                                                style: const TextStyle(color: AppColor.whiteColor,fontSize: 12)),
                                            )
                                          ],
                                        )
                                    )
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child:  Text(snapshot.data?.docs[index]['shopName'],
                                      style: const TextStyle(color: AppColor.appColor),
                                      maxLines: 2,overflow: TextOverflow.ellipsis),
                                ),
                                const SizedBox(height: 2),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10,bottom: 10),
                                  child: Text(snapshot.data?.docs[index]['hairCategory'],
                                    style: const TextStyle(color: AppColor.blackColor,fontSize: 10,overflow: TextOverflow.ellipsis),
                                      textAlign:TextAlign.start,maxLines: 1),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                  ),
                )
              ],
            );
          }
      }
    );
  }
}
