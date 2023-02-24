import 'package:barber_booking_management/Profile/profile_screen.dart';
import 'package:barber_booking_management/utils/app_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../Category/category_screen.dart';
import '../Chat/chat_room_page.dart';
import '../Chat/chat_user.dart';
import '../Chat/model/chatroom_model.dart';
import '../Chat/notification/push_notification.dart';
import '../Firebase/firebase_collection.dart';
import '../Home/home_screen.dart';
import '../NearBy/near_by_screen.dart';
import '../main.dart';
import '../utils/app_color.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {

  int _selectedIndex=0;
  List<Widget> buildScreen(){
    return [
      const HomeScreen(),
      const NearbyScreen(),
      const CategoryScreen(),
      const ChatUserScreen(),
      const ProfileScreen()
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    PushNotification().getNotification(context);
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) async {
      if (message != null) {
        Future<ChatRoomModel?> getChatroomModel() async {
          ChatRoomModel? chatRoom;
          var querySnapShot = await FirebaseCollection().userCollection.get();
          for(var snapshotData in querySnapShot.docChanges){
            if(snapshotData.doc.get('userEmail') == message.data.values.first)
            {
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
                  chatUserName1: message.data.values.first,
                  chatUserName2: message.data.values.last,
                  lastMessage: "",
                  chatUser1: FirebaseAuth.instance.currentUser?.email,
                  chatUser2: '${message.data.values.first}',
                  lastMessageTime: DateTime.now().toString(),
                  participants: {
                    FirebaseAuth.instance.currentUser!.uid.toString(): true,
                    'htnwya93lIQPi3caYBGxodIIMEG2': true,
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

        ChatRoomModel? chatroomModel = await getChatroomModel();

        debugPrint('Email => ${message.data.values.last}');

        if(chatroomModel != null) {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return ChatRoomPage(
                  snapshotUserName: message.notification?.title,
                  chatroom: chatroomModel,
                  getOpenentUserEmail: FirebaseAuth.instance.currentUser?.email != message.data.values.first ?
                  message.data.values.first :
                  message.data.values.last,
                );
              }
          ));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: WillPopScope(
        onWillPop: () async{
          if(_selectedIndex != 0) {
            setState(() {
              _selectedIndex = 0;
            });
            return false;
          } else {
            return true;
          }
        },
      child: buildScreen().elementAt(_selectedIndex)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedIndex,
        backgroundColor: Colors.transparent,
        selectedFontSize: 12,
        selectedLabelStyle: const TextStyle(color: AppColor.appColor),
        unselectedLabelStyle: const TextStyle(color: AppColor.blackColor,),
        selectedItemColor: AppColor.appColor,
        unselectedItemColor: AppColor.appColor,
        onTap: _onItemTapped,
        items:  [
          BottomNavigationBarItem(
              label: "Home",
              icon:  Image.asset(AppImage.home,height: 22,width: 25,)
          ),
          BottomNavigationBarItem(
              label: "Near By",
              icon: Image.asset(AppImage.nearBy,height: 25,width: 25,)
          ),
          BottomNavigationBarItem(
              label: "Category",
              icon: Image.asset(AppImage.categories,height: 24,width: 25,)
          ),
          BottomNavigationBarItem(
              label: "Chat",
              icon: Image.asset(AppImage.chat,height: 24,width: 25,color: AppColor.appColor,)
          ),
          BottomNavigationBarItem(
              label: "Profile",
              icon: Image.asset(AppImage.profile,height: 19,width: 25,)
    ),
        ],
      ),
    );
  }
}

