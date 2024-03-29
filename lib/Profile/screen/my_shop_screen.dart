import 'package:barber_booking_management/Firebase/firebase_collection.dart';
import 'package:barber_booking_management/Profile/screen/edit_shop_screen.dart';
import 'package:barber_booking_management/utils/app_image.dart';
import 'package:barber_booking_management/utils/app_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/app_color.dart';
import '../../utils/app_font.dart';

class MyShopScreen extends StatelessWidget {
  const MyShopScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop',style: TextStyle(fontFamily: AppFont.bold),),
      ),
      body: StreamBuilder(
        stream: FirebaseCollection().shopCollection.
        where('currentUser',isEqualTo: FirebaseAuth.instance.currentUser?.email).snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none){
            return const Center(child: CircularProgressIndicator());
          } else if(snapshot.requireData.docs.isEmpty){
            return const Center(child: Text('No Shop',style: TextStyle(fontFamily: AppFont.regular),));
          }  else {
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                shrinkWrap: true,
                itemBuilder: (context,index){
                  return Card(
                    child: ListTile(
                      title: Text(snapshot.data?.docs[index]['shopName'],style: const TextStyle(fontSize: 13,fontFamily: AppFont.regular)),
                      subtitle: Text(snapshot.data?.docs[index]['shopDescription'],
                          style: const TextStyle(fontSize: 10,fontFamily: AppFont.regular),maxLines: 2,),
                      leading: ClipOval(
                          child: Image.network(
                              snapshot.data?.docs[index]['shopImage'],height: 50,width: 50,fit: BoxFit.fill,)),
                      trailing: PopupMenuButton<int>(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: Row(
                              children: const [
                                Icon(Icons.edit,color: AppColor.appColor,size: 20),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Edit Shop",style: TextStyle(fontSize: 13,fontFamily: AppFont.regular))
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: Row(
                              children: const [
                                Icon(Icons.delete,color: AppColor.appColor,size: 20),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Delete",style: TextStyle(fontSize: 13,fontFamily: AppFont.regular))
                              ],
                            ),
                          ),
                        ],
                        icon: Image.asset(AppImage.menu,height: 20,width: 17,),
                        color: Colors.white,
                        elevation: 2,
                        onSelected: (value) {
                          if (value == 1) {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>EditShopScreen(
                              snapshotData: snapshot.data?.docs[index],
                            )));
                          } else if (value == 2) {
                            Widget noButton = TextButton(
                              child: const Text("No",style: TextStyle(color: AppColor.whiteColor,fontSize: 12,fontFamily: AppFont.bold),),
                              onPressed:  () {
                                Navigator.pop(context);
                              },
                            );
                            Widget yesButton = TextButton(
                              child: const Text("Yes",style: TextStyle(color: AppColor.whiteColor,fontSize: 12,fontFamily: AppFont.bold),),
                              onPressed:  () async {
                                debugPrint('Document Id ${ snapshot.data?.docs[index]['shopName']} ');
                                debugPrint('Document Id ${ snapshot.data?.docs[index]['hairCategory']} ');
                                Navigator.pop(context);
                                await FirebaseCollection().shopCollection.
                                doc('${snapshot.data?.docs[index]['currentUser']}'
                                    '${snapshot.data?.docs[index]['hairCategory']}')
                                    .delete();
                                final uid= snapshot.data?.docs[index]['uid'];
                                await FirebaseCollection().barberCollection
                                    .where('uid', isEqualTo: uid)
                                    .get()
                                    .then((querySnapshot) {
                                  querySnapshot.docs.forEach((document) {
                                    document.reference.delete();
                                  });
                                });
                                AppUtils.instance.showToast(toastMessage: 'delete successfully.');

                              },
                            );
                            AlertDialog alert = AlertDialog(
                              backgroundColor: AppColor.appColor,
                              titleTextStyle: const TextStyle(color: AppColor.whiteColor,fontSize: 18),
                              title: const Text("Delete Shop",style: TextStyle(fontFamily: AppFont.bold),),
                              content: const Text("Are sure want to delete this shop?",style: TextStyle(color: AppColor.whiteColor,fontSize: 12,fontFamily: AppFont.medium)),
                              actions: [
                                noButton,
                                yesButton,
                              ],
                            );
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return alert;
                              },
                            );
                          }
                        },
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
