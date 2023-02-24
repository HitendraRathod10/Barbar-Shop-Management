// import 'package:barber_booking_management/Firebase/firebase_collection.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../main.dart';
// import '../utils/app_color.dart';
// import 'chat_room_page.dart';
// import 'model/chatroom_model.dart';
//
// class ContactUsScreen extends StatefulWidget {
//   const ContactUsScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ContactUsScreen> createState() => _ContactUsScreenState();
// }
//
// class _ContactUsScreenState extends State<ContactUsScreen> {
//
//   String? userName;
//
//   Future shopDetailsCheck() async{
//     var shopQuerySnapshot = await FirebaseCollection().userCollection.where('userEmail',
//         isEqualTo: FirebaseAuth.instance.currentUser?.email).get();
//
//     for(var snapShot in shopQuerySnapshot.docChanges){
//       setState(() {
//         userName = snapShot.doc.get('userName');
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     shopDetailsCheck();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder(
//         stream: FirebaseCollection().userCollection.
//          where('userType',isEqualTo: 'Shop Owner').
//           //  where('userEmail',isNotEqualTo: FirebaseAuth.instance.currentUser?.email).
//         snapshots(),
//         builder: (context,AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
//           if(snapshot.connectionState == ConnectionState.waiting){
//             return const SizedBox();
//           }else if (snapshot.hasError) {
//             return const Center(child: Text("Something went wrong"));
//           } else if (!snapshot.hasData) {
//             return const SizedBox();
//           } else if (snapshot.requireData.docChanges.isEmpty){
//             return const SizedBox();
//           } else {
//             return ListView.builder(
//                 itemCount: snapshot.data?.docs.length,
//                 itemBuilder: (context,index){
//                   return GestureDetector(
//                     onTap: () async{
//                       Future<ChatRoomModel?> getChatroomModel() async {
//                         ChatRoomModel? chatRoom;
//
//                         QuerySnapshot snapshot1 = await FirebaseCollection().chatRoomCollection.
//                         where("participants.${FirebaseAuth.instance.currentUser?.uid}", isEqualTo: true).
//                         where("participants.${snapshot.data?.docs[index]['uid']}", isEqualTo: true).get();
//
//                         if(snapshot1.docs.length > 0) {
//                           var docData = snapshot1.docs[0].data();
//                           ChatRoomModel existingChatroom = ChatRoomModel.fromMap(docData as Map<String, dynamic>);
//                           chatRoom = existingChatroom;
//                         }
//                         else {
//                           ChatRoomModel newChatroom = ChatRoomModel(
//                             chatroomid: uuid.v1(),
//                             chatUserName1: userName,
//                             chatUserName2: snapshot.data?.docs[index]['userName'],
//                             lastMessage: "",
//                             chatUser1: FirebaseAuth.instance.currentUser?.email,
//                             chatUser2: snapshot.data?.docs[index]['userEmail'],
//                             lastMessageTime: DateTime.now().toString(),
//                             participants: {
//                               FirebaseAuth.instance.currentUser!.uid.toString(): true,
//                               snapshot.data?.docs[index]['uid']: true,
//                             },
//                           );
//
//                           await FirebaseCollection().chatRoomCollection.doc(newChatroom.chatroomid).set(newChatroom.toMap());
//
//                           chatRoom = newChatroom;
//                           debugPrint("New Chatroom Created");
//                         }
//
//                         return chatRoom;
//                       }
//
//                       ChatRoomModel? chatroomModel = await getChatroomModel();
//                       if(chatroomModel != null) {
//                         Navigator.push(context, MaterialPageRoute(
//                             builder: (context) {
//                               return ChatRoomPage(
//                                 snapshotUserName: snapshot.data?.docs[index]['userName'],
//                                 chatroom: chatroomModel,
//                               );
//                             }
//                         ));
//                       }
//                     },
//                     child: ListTile(
//                       title:  Text('${snapshot.data?.docs[index]['userName']?.substring(0,1).toUpperCase()}'
//                           '${snapshot.data?.docs[index]['userName'].substring(1).toLowerCase()}',
//                         style: const TextStyle(fontSize: 12)),
//                       subtitle: const Text('Last Message',style: TextStyle(fontSize: 10)),
//                       leading: snapshot.data?.docs[index]['userImage'] != '' ?
//                       ClipOval(
//                           child: Image.network(snapshot.data?.docs[index]['userImage'],
//                             height: 50,width: 50,fit: BoxFit.fill)) :
//                       ClipOval(
//                         child: Container(
//                           color: AppColor.appColor,
//                           height: 50,width: 50,child: Center(
//                           child: Text('${snapshot.data?.docs[index]['userName']?.substring(0,1).toUpperCase()}',
//                               style: const TextStyle(color: AppColor.whiteColor)),
//                         ),),
//                       ),
//                       trailing: const Text('Date',style: TextStyle(color: AppColor.greyColor,fontSize: 10)),
//                     ),
//                   );
//                 }
//             );
//           }
//         }
//       ),
//     );
//   }
//
// }
