import 'package:barber_booking_management/utils/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../Firebase/firebase_collection.dart';
import '../../Appointment/Screen/give_review_screen.dart';

class ReviewWidget extends StatelessWidget {

  ReviewWidget({Key? key, required this.snapshotData,required this.shopName,required this.currentUser}) : super(key: key);

  var snapshotData,shopName,currentUser;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10, top: 350),
          child: Column(
            children: [
              Visibility(
                visible: currentUser != FirebaseAuth.instance.currentUser?.email ? true : false,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GiveReviewScreen(snapshotData: snapshotData)));
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10, top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Write a review',
                          style:
                              TextStyle(color: AppColor.appColor),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          size: 20,
                          color: AppColor.appColor,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              StreamBuilder(
                  stream: FirebaseCollection().userRatingCollection
                      .where('shopName', isEqualTo: shopName).snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.requireData.docChanges.isEmpty) {
                      return const Center(child: Text('No review'));
                    } else if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: AppColor.aquaColor4,
                                  borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 10, bottom: 10),
                              margin: const EdgeInsets.only(top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipOval(
                                      child:
                                      snapshot.data!.docs[index]['userImage'] == "" ? Container(
                                        color: AppColor.appColor,
                                        height: 50,width: 50,child: Center(
                                        child: Text('${snapshot.data?.docs[index]['userName'].substring(0,1).toUpperCase()}',
                                            style: const TextStyle(color: AppColor.whiteColor)),
                                      ),) :
                                      Image.network(
                                          '${snapshot.data?.docs[index]['userImage']}',
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.fill)
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                         Text(snapshot.data?.docs[index]['userName']),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        RatingBar.builder(
                                          initialRating: snapshot.data?.docs[index]['shopRating'],
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          ignoreGestures: true,
                                          itemSize: 15,
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            debugPrint('$rating');
                                          },
                                        ),
                                        const SizedBox(height: 5),
                                        Text(snapshot.data?.docs[index]['userExprience'],
                                          style: const TextStyle(fontSize: 12,color: AppColor.greyColor),)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  })
            ],
          )),
    );
  }
}
