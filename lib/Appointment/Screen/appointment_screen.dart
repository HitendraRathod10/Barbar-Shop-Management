import 'package:barber_booking_management/Firebase/firebase_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/app_color.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointment'),
      ),
      body: StreamBuilder(
        stream: FirebaseCollection().bookAppointmentCollection.
        where('userEmail',isEqualTo: FirebaseAuth.instance.currentUser?.email).snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none) {
            return const Center(child: CircularProgressIndicator());
          } else if(snapshot.hasError || snapshot.requireData.docs.isEmpty){
            return const Center(child: Text('No Appointment'));
          }
          else {
            return ListView.builder(
              itemCount: snapshot.data?.docChanges.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    color: Colors.white70.withOpacity(0.8),
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 10,top: 10,right: 10,left: 5),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child:  Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ClipRRect(
                                child: Image.network(snapshot.data?.docs[index]['shopImage'],
                                    height: 60,width: 80,fit: BoxFit.fill),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:  [
                                      Text(snapshot.data?.docs[index]['shopName'],
                                          style : const TextStyle(color: AppColor.appColor),maxLines: 1,overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 2),
                                      Text(snapshot.data?.docs[index]['address'],
                                          style : const TextStyle(color: AppColor.aquaColor2,fontSize: 10),maxLines: 2,overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 4),
                                      Text('${snapshot.data?.docs[index]['userAppointmentDate']} '
                                          '${snapshot.data?.docs[index]['userAppointmentTime']}',
                                          style : const TextStyle(color: AppColor.blackColor,fontSize: 10),maxLines: 2,overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          const Divider(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Services : ',
                                    style: TextStyle(color: AppColor.appColor,fontWeight: FontWeight.w500),),
                                  const SizedBox(width: 20,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: const [
                                      Text('Service Name',style: TextStyle(fontSize: 12),),
                                      SizedBox(height: 5),
                                      Text('Price',style: TextStyle(fontSize: 12),),
                                      SizedBox(height: 5,),
                                      Text('Discount',style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ],
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('${snapshot.data?.docs[index]['hairCategory']}',style: const TextStyle(fontSize: 12)),
                                  const SizedBox(height: 5),
                                  Text('₹ ${snapshot.data?.docs[index]['price']}',style: const TextStyle(fontSize: 12)),
                                  const SizedBox(height: 5),
                                  const Text('0.0%',style: TextStyle(fontSize: 12)),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total',
                                style: TextStyle(color: AppColor.redColor,fontWeight: FontWeight.w500),),
                              Text('₹ ${snapshot.data?.docs[index]['price']}',
                                style: const TextStyle(color: AppColor.redColor,fontWeight: FontWeight.w500),),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
            );
          }
        }
      ),
    );
  }
}
