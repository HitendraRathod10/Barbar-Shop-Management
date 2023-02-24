// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
//
// import '../../Firebase/firebase_collection.dart';
// import '../../main.dart';
// import '../model/chatroom_model.dart';
//
// class ChatMessage {
//
//   Future<ChatRoomModel?> getChatroomModel() async {
//     ChatRoomModel? chatRoom;
//     var querySnapShot = await FirebaseCollection().userCollection.get();
//     for(var snapshotData in querySnapShot.docChanges){
//       if(snapshotData.doc.get('userEmail') == snapshot.data?.docs[index]['chatUser1'])
//       {
//         debugPrint('For Loop 1  => ${snapshotData.doc.get('userEmail')}');
//         debugPrint('For Loop 1  => ${snapshotData.doc.get('uid')}');
//
//         QuerySnapshot snapshot1 = await FirebaseCollection().chatRoomCollection.
//         where("participants.${FirebaseAuth.instance.currentUser?.uid}", isEqualTo: true).
//         where("participants.${snapshotData.doc.get('uid')}", isEqualTo: true).get();
//
//         if(snapshot1.docs.length > 0) {
//           var docData = snapshot1.docs[0].data();
//           ChatRoomModel existingChatroom = ChatRoomModel.fromMap(docData as Map<String, dynamic>);
//           chatRoom = existingChatroom;
//           //break;
//         }
//         else {
//           ChatRoomModel newChatroom = ChatRoomModel(
//             chatroomid: uuid.v1(),
//             chatUserName1: userName,
//             chatUserName2: snapshot.data?.docs[index]['userName'],
//             lastMessage: "",
//             chatUser1: FirebaseAuth.instance.currentUser?.email,
//             chatUser2: snapshot.data?.docs[index]['userEmail'],
//             lastMessageTime: DateTime.now().toString(),
//             participants: {
//               FirebaseAuth.instance.currentUser!.uid.toString(): true,
//               snapshot.data?.docs[index]['uid']: true,
//             },
//           );
//
//           await FirebaseCollection().chatRoomCollection.doc(newChatroom.chatroomid).set(newChatroom.toMap());
//           chatRoom = newChatroom;
//           debugPrint("New Chatroom Created");
//         }
//       }
//     }
//     return chatRoom;
//   }
//
//
// }