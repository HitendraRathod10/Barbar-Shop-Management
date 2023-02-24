import 'dart:developer';
import 'package:barber_booking_management/Chat/notification/push_notification.dart';
import 'package:barber_booking_management/Firebase/firebase_collection.dart';
import 'package:barber_booking_management/utils/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import 'model/chatroom_model.dart';
import 'model/message_model.dart';


class ChatRoomPage extends StatefulWidget {
  final  snapshotUserName,getOpenentUserEmail;
  final ChatRoomModel chatroom;
  const ChatRoomPage({Key? key, required this.snapshotUserName, required this.chatroom, required this.getOpenentUserEmail}) : super(key: key);
  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {

  TextEditingController messageController = TextEditingController();

  void sendMessage() async {
    String msg = messageController.text.trim();
    if(msg != "") {
      // Send Message
      MessageModel newMessage = MessageModel(
          messageid: uuid.v1(),
          sender: FirebaseAuth.instance.currentUser?.email,
          timeStamp: DateTime.now().toString(),
          text: msg,
          seen: false
      );
      FirebaseCollection().chatRoomCollection.doc(widget.chatroom.chatroomid).
      collection("messages").doc(newMessage.messageid).set(newMessage.toMap());
      widget.chatroom.lastMessage = msg;
      widget.chatroom.lastMessageTime = DateTime.now().toString();
      FirebaseCollection().chatRoomCollection.
      doc(widget.chatroom.chatroomid).set(widget.chatroom.toMap());
      log('Chat Room Id ${widget.chatroom.chatroomid}');
      log('New Message Id ${newMessage.messageid}');
      log("Message Sent!");

      var fetchTokenSnapshot = await FirebaseCollection().userCollection.get();

      for(var snapShot in fetchTokenSnapshot.docChanges){
        if(snapShot.doc.get('userEmail') == widget.getOpenentUserEmail){

          var shopQuerySnapshot = await FirebaseCollection().userCollection.where('userEmail',
              isEqualTo: FirebaseAuth.instance.currentUser?.email).get();

          for(var userMsgSnapShot in shopQuerySnapshot.docChanges){
            PushNotification().chatMessageNotification(
                snapShot.doc.get('fcmToken'),
                userMsgSnapShot.doc.get('userName'),
                snapShot.doc.get('userName'),
                messageController.text.toString(),
                widget.getOpenentUserEmail,
                FirebaseAuth.instance.currentUser?.email,
            );
          }
          break;
        }
      }
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.snapshotUserName.toString()),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: StreamBuilder(
                  stream: FirebaseCollection().chatRoomCollection.
                  doc(widget.chatroom.chatroomid).collection("messages").
                  orderBy("timeStamp", descending: true).
                  snapshots(),
                  builder: (context,AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(child: CircularProgressIndicator(),);
                    }
                    if(snapshot.requireData.docChanges.isNotEmpty) {
                      QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
                      return ListView.builder(
                        reverse: true,
                        itemCount: dataSnapshot.docs.length,
                        itemBuilder: (context, index) {
                          MessageModel currentMessage = MessageModel.fromMap(dataSnapshot.docs[index].data() as Map<String, dynamic>);
                          return GestureDetector(
                            onLongPress: (){
                                Widget cancelButton = TextButton(
                                  child: const Text("Cancel",style: TextStyle(color: AppColor.appColor,fontSize: 12),),
                                  onPressed:  () {
                                    Navigator.pop(context);
                                  },
                                );
                                Widget deleteButton = TextButton(
                                  child: const Text("Delete",style: TextStyle(color: AppColor.appColor,fontSize: 12),),
                                  onPressed:  () async {
                                    Navigator.pop(context);
                                    FirebaseCollection().chatRoomCollection.
                                    doc(widget.chatroom.chatroomid).
                                    collection("messages").doc(currentMessage.messageid).delete();
                                   // FirebaseCollection().userRatingCollection.doc('${ratingSnapshot.doc.get("currentUser")} ${widget.snapshotData['shopName']}').delete();
                                  },
                                );
                                AlertDialog alert = AlertDialog(
                                  contentPadding : const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 0.0),
                                  titleTextStyle: const TextStyle(color: AppColor.appColor,fontSize: 16),
                                  title: const Text("Delete message?"),
                                  content: const Text("Do you want to delete this message",style: TextStyle(color: AppColor.blackColor,fontSize: 12)),
                                  actions: [
                                    cancelButton,
                                    deleteButton,
                                  ],
                                );

                                currentMessage.sender == FirebaseAuth.instance.currentUser?.email ?
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return alert;
                                  },
                                ) : debugPrint('');
                            },
                            child: Row(
                              mainAxisAlignment: (currentMessage.sender == FirebaseAuth.instance.currentUser?.email) ? MainAxisAlignment.end : MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: currentMessage.sender != FirebaseAuth.instance.currentUser?.email ?
                                    CrossAxisAlignment.start : CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                          margin: currentMessage.sender == FirebaseAuth.instance.currentUser?.email ?
                                          const EdgeInsets.fromLTRB(50,7,00,0) : const EdgeInsets.fromLTRB(00,7,50,00),
                                          padding: currentMessage.sender == FirebaseAuth.instance.currentUser?.email ?
                                          const EdgeInsets.fromLTRB(10,10,5,10) : const EdgeInsets.fromLTRB(5,10,10,10),
                                          decoration: BoxDecoration(
                                              color: (currentMessage.sender == FirebaseAuth.instance.currentUser?.email) ? AppColor.appColor : AppColor.greyColor,
                                              borderRadius:
                                              currentMessage.sender == FirebaseAuth.instance.currentUser?.email ?
                                              const BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight:  Radius.circular(10),
                                                  bottomLeft:  Radius.circular(10)
                                              ) : const BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                  bottomRight: Radius.circular(10)
                                              )
                                          ),
                                          child: Text(
                                            currentMessage.text.toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          )
                                      ),
                                      Text(
                                        currentMessage.timeStamp.toString().substring(0,10) !=
                                            DateTime.now().toString().substring(0,10) ?
                                        DateFormat("dd/MM/yyyy  hh:mm a").format(DateTime.parse(currentMessage.timeStamp.toString())).toString() :
                                        DateFormat("hh:mm a").format(DateTime.parse(currentMessage.timeStamp.toString())).toString(),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                    else if(snapshot.hasError) {
                      return const Center(
                        child: Text("An error occurred! Please check your internet connection."),
                      );
                    } else {
                      return const Center(
                        child: Text("Say hii"),
                      );
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              color: AppColor.textFieldColor,
              padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5
              ),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: messageController,
                      maxLines: 4,
                      minLines: 1,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter message"
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      sendMessage();
                    },
                    icon: Icon(Icons.send, color: Theme.of(context).colorScheme.secondary,),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}