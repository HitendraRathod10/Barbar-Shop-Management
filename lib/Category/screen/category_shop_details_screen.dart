import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Firebase/firebase_collection.dart';
import '../../Home/screen/shop_details_screen.dart';
import '../../utils/app_color.dart';

class CategoryShopDetailScreen extends StatefulWidget {
  String gender,hairCategory;
  CategoryShopDetailScreen({Key? key,required this.hairCategory,required this.gender}) : super(key: key);

  @override
  State<CategoryShopDetailScreen> createState() => _CategoryShopDetailScreenState();
}

class _CategoryShopDetailScreenState extends State<CategoryShopDetailScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.hairCategory);
    print(widget.gender);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hairCategory),
      ),
      body:StreamBuilder(
          stream: FirebaseCollection().shopCollection.where('gender',isEqualTo: widget.gender).
          where('hairCategory',isEqualTo: widget.hairCategory).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot)  {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            }else if (snapshot.hasError) {
              return const Center(child: Text("Something went wrong"));
            } else if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.requireData.docChanges.isEmpty){
              return const Center(child: Text("No Shop Available"));
            } else {
              return Column(
                children: [
                  ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context,index){
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ShopDetailsScreen(snapshotData: snapshot.data?.docs[index])));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 20,right: 20,top: 10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child:  Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  child: Image.network(snapshot.data?.docs[index]['shopImage'],
                                    height: 90,width: 80,fit: BoxFit.fill,),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:  [
                                        Text(snapshot.data?.docs[index]['shopName'],
                                            style : const TextStyle(color: AppColor.appColor),maxLines: 2,overflow: TextOverflow.ellipsis),
                                        const SizedBox(height: 2),
                                        Text(snapshot.data?.docs[index]['hairCategory'],
                                            style : const TextStyle(color: AppColor.aquaColor2,fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis),
                                        const SizedBox(height: 4),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const Text('Price',
                                                style: TextStyle(color: AppColor.blackColor,fontSize: 10),
                                                maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start),
                                            const SizedBox(width: 5,),
                                            Text('₹${snapshot.data?.docs[index]['price']}',
                                                style:  const TextStyle(color: AppColor.appColor,fontWeight: FontWeight.bold),
                                                maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                  )
                ],
              );
            }
          }
      )
    );
  }
}
