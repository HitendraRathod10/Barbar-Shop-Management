import 'package:barber_booking_management/Firebase/firebase_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import '../utils/app_color.dart';
import 'chat_room_page.dart';
import 'model/chatroom_model.dart';

class ChatUserScreen extends StatefulWidget {
  const ChatUserScreen({Key? key}) : super(key: key);

  @override
  State<ChatUserScreen> createState() => _ChatUserScreenState();
}

class _ChatUserScreenState extends State<ChatUserScreen> {

  String? userName;

  Future shopDetailsCheck() async{
    var shopQuerySnapshot = await FirebaseCollection().userCollection.where('userEmail',
        isEqualTo: FirebaseAuth.instance.currentUser?.email).get();

    for(var snapShot in shopQuerySnapshot.docChanges){
        userName = snapShot.doc.get('userName');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint('${DateTime.now().subtract(const Duration(days:1))}');
    shopDetailsCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseCollection().chatRoomCollection.
          where('participants.${FirebaseAuth.instance.currentUser?.uid}',isEqualTo: true).
          //orderBy('lastMessageTime').
          snapshots(),
          builder: (context,AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            }else if (snapshot.hasError) {
              return const Center(child: Text("Something went wrong"));
            } else if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.requireData.docChanges.isEmpty){
              return const Center(child: Text("No User Available"));
            } else {
              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context,index){
                    return GestureDetector(
                      onTap: () async{
                        Future<ChatRoomModel?> getChatroomModel() async {
                          ChatRoomModel? chatRoom;
                          var querySnapShot = await FirebaseCollection().userCollection.get();
                            for(var snapshotData in querySnapShot.docChanges){
                              if(snapshotData.doc.get('userEmail') == snapshot.data?.docs[index]['chatUser1'])
                              {
                              debugPrint('For Loop 1  => ${snapshotData.doc.get('userEmail')}');
                              debugPrint('For Loop 1  => ${snapshotData.doc.get('uid')}');

                              QuerySnapshot snapshot1 = await FirebaseCollection().chatRoomCollection.
                              where("participants.${FirebaseAuth.instance.currentUser?.uid}", isEqualTo: true).
                              where("participants.${snapshotData.doc.get('uid')}", isEqualTo: true).get();

                              if(snapshot1.docs.length > 0) {
                                var docData = snapshot1.docs[0].data();
                                ChatRoomModel existingChatroom = ChatRoomModel.fromMap(docData as Map<String, dynamic>);
                                chatRoom = existingChatroom;
                                //break;
                              }
                              else {
                                ChatRoomModel newChatroom = ChatRoomModel(
                                  chatroomid: uuid.v1(),
                                  chatUserName1: userName,
                                  chatUserName2: snapshot.data?.docs[index]['userName'],
                                  lastMessage: "",
                                  chatUser1: FirebaseAuth.instance.currentUser?.email,
                                  chatUser2: snapshot.data?.docs[index]['userEmail'],
                                  lastMessageTime: DateTime.now().toString(),
                                  participants: {
                                    FirebaseAuth.instance.currentUser!.uid.toString(): true,
                                    snapshot.data?.docs[index]['uid']: true,
                                  },
                                );

                                await FirebaseCollection().chatRoomCollection.doc(newChatroom.chatroomid).set(newChatroom.toMap());
                                chatRoom = newChatroom;
                                debugPrint("New Chatroom Created");
                              }
                              }
                            }
                          return chatRoom;
                        }

                        Future<ChatRoomModel?> getChatroomModel1() async {
                          ChatRoomModel? chatRoom;
                          // print('Doc Id get => ${snapshot.data?.docs[index]['uid']}');
                          var querySnapShot = await FirebaseCollection().userCollection.get();

                          for(var snapshotData in querySnapShot.docChanges){
                            if(snapshotData.doc.get('userEmail') == snapshot.data?.docs[index]['chatUser2']
                              //  && FirebaseAuth.instance.currentUser?.email == snapshot.data?.docs[index]['chatUser1']
                            )
                            {
                            debugPrint('For Loop 1  => ${snapshotData.doc.get('userEmail')}');

                            QuerySnapshot snapshot1 = await FirebaseCollection().chatRoomCollection.
                            where("participants.${FirebaseAuth.instance.currentUser?.uid}", isEqualTo: true).
                            where("participants.${snapshotData.doc.get('uid')}", isEqualTo: true).get();

                            if(snapshot1.docs.length > 0) {
                              var docData = snapshot1.docs[0].data();
                              ChatRoomModel existingChatroom = ChatRoomModel.fromMap(docData as Map<String, dynamic>);
                              chatRoom = existingChatroom;
                              break;
                            }
                            else {
                              ChatRoomModel newChatroom = ChatRoomModel(
                                chatroomid: uuid.v1(),
                                chatUserName1: userName,
                                chatUserName2: snapshot.data?.docs[index]['userName2'],
                                lastMessage: "",
                                chatUser1: FirebaseAuth.instance.currentUser?.email,
                                chatUser2: snapshot.data?.docs[index]['userEmail'],
                                lastMessageTime: DateTime.now().toString(),
                                participants: {
                                  FirebaseAuth.instance.currentUser!.uid.toString(): true,
                                  snapshot.data?.docs[index]['uid']: true,
                                },
                              );

                              await FirebaseCollection().chatRoomCollection.doc(newChatroom.chatroomid).set(newChatroom.toMap());
                              chatRoom = newChatroom;
                              debugPrint("New Chatroom Created");
                            }
                           }
                          }
                          return chatRoom;
                        }

                        ChatRoomModel? chatroomModel = FirebaseAuth.instance.currentUser?.email != snapshot.data?.docs[index]['chatUser1'] ?
                        await getChatroomModel() : await getChatroomModel1();
                        if(chatroomModel != null) {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return ChatRoomPage(
                                  snapshotUserName: FirebaseAuth.instance.currentUser?.email != snapshot.data?.docs[index]['chatUser1'] ?
                                  snapshot.data?.docs[index]['userName1'] :
                                  snapshot.data?.docs[index]['userName2'],
                                  chatroom: chatroomModel,
                                  getOpenentUserEmail: FirebaseAuth.instance.currentUser?.email != snapshot.data?.docs[index]['chatUser1'] ?
                                  snapshot.data?.docs[index]['chatUser1'] :
                                  snapshot.data?.docs[index]['chatUser2'],
                                );
                              }
                          ));
                        }
                      },
                      child: ListTile(
                        title: FirebaseAuth.instance.currentUser?.email == snapshot.data?.docs[index]['chatUser1'] ?
                        Text(
                            '${snapshot.data?.docs[index]['userName2']?.substring(0,1).toUpperCase()}'
                            '${snapshot.data?.docs[index]['userName2'].substring(1).toLowerCase()}',
                            style: const TextStyle(fontSize: 12)
                        ) : Text(
                      '${snapshot.data?.docs[index]['userName1']?.substring(0,1).toUpperCase()}'
                    '${snapshot.data?.docs[index]['userName1'].substring(1).toLowerCase()}',
                    style: const TextStyle(fontSize: 12)
                    ),
                        subtitle: Text(snapshot.data?.docs[index]['lastmessage'], style: const TextStyle(fontSize: 10),maxLines: 1,overflow: TextOverflow.ellipsis,),
                        leading: ClipOval(
                          child: Container(
                            color: AppColor.appColor,
                            height: 40,width: 40,child: Center(
                            child: Text('${snapshot.data?.docs[index]['userName2']?.substring(0,1).toUpperCase()}',
                                style: const TextStyle(color: AppColor.whiteColor)),
                          ))
                        ),
                        trailing: Text('${
                            snapshot.data?.docs[index]['lastMessageTime'].toString().substring(0,10) ==
                                DateTime.now().subtract(const Duration(days:1)).toString().substring(0,10) ? 'Yesterday' :
                            snapshot.data?.docs[index]['lastMessageTime'].toString().substring(0,10) ==
                                DateTime.now().toString().substring(0,10) ?
                            DateFormat("hh:mm a").format(DateTime.parse(snapshot.data?.docs[index]['lastMessageTime'])).toString() :
                            // snapshot.data?.docs[index]['lastMessageTime'].toString().substring(11,16) :
                            snapshot.data?.docs[index]['lastMessageTime'].toString().substring(0,10)
                        }',
                                  style: const TextStyle(color: AppColor.greyColor,fontSize: 10)),
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
