import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Appointment/Screen/appointment_book_screen.dart';
import '../../Category/widget/review_widget.dart';
import '../../Chat/chat_room_page.dart';
import '../../Chat/model/chatroom_model.dart';
import '../../Firebase/firebase_collection.dart';
import '../../main.dart';
import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
//ignore: must_be_immutable
class ShopDetailsScreen extends StatefulWidget{

  dynamic snapshotData;
  ShopDetailsScreen({Key? key,required this.snapshotData}) : super(key: key);

  @override
  State<ShopDetailsScreen> createState() => _ShopDetailsScreenState();
}

class _ShopDetailsScreenState extends State<ShopDetailsScreen> with SingleTickerProviderStateMixin{

  late TabController controller;
  final ScrollController _scrollController = ScrollController();
  final List<Widget> _tabs = const [
    Text("About",style: TextStyle(fontFamily: AppFont.medium),),
    Text("Rating",style: TextStyle(fontFamily: AppFont.medium),),
  ];

  String? userName,userPhoneNumber,userEmail;

  Future shopDetailsCheck() async{
    var shopQuerySnapshot = await FirebaseCollection().userCollection.where('userEmail',
        isEqualTo: FirebaseAuth.instance.currentUser?.email).get();

    for(var snapShot in shopQuerySnapshot.docChanges){
      setState(() {
        userName = snapShot.doc.get('userName');
        userPhoneNumber = snapShot.doc.get('userMobile');
        userEmail = snapShot.doc.get('userEmail');
      });
    }
  }

  String capitalizeAllWord(String value) {
    var result = value[0].toUpperCase();
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " ") {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
      }
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    shopDetailsCheck();
    controller = TabController(length: _tabs.length, vsync: this,initialIndex: 0);
    debugPrint("snapshotData ${widget.snapshotData['currentUser']}");
    debugPrint("snapshotData ${widget.snapshotData['uid']}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                      automaticallyImplyLeading : false,
                      backgroundColor: AppColor.whiteColor,
                      pinned: true,
                      shadowColor: AppColor.blackColor,
                      toolbarHeight: 300,
                      forceElevated: innerBoxIsScrolled,
                      flexibleSpace: Column(
                        children: [
                          Stack(
                            children: [
                              const SizedBox(
                                height: 200,width: double.infinity,
                              ),
                              Image.network(
                                  widget.snapshotData['shopImage'],
                                  height: 220,
                                  width: double.infinity,
                                  fit: BoxFit.fill),

                              Container(
                                height: 220,
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0x922B2626),
                                      Color(0x924E4444),
                                    ],
                                  ),
                                ),
                              ),

                              Positioned(
                                top: 10,
                                left: 8,
                                child: IconButton(onPressed: (){
                                  Navigator.pop(context);
                                }, icon: ClipOval(
                                  child: Container(
                                      color: AppColor.whiteColor.withOpacity(0.6),
                                      padding: const EdgeInsets.only(left: 9,right: 5,bottom: 5,top: 4),
                                      child: const Icon(Icons.arrow_back_ios,)),
                                ),color: AppColor.appColor,iconSize: 20),
                              ),

                              Positioned(
                                left: 20,bottom: 10,right: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                     Text(capitalizeAllWord(widget.snapshotData['shopName']),maxLines: 3,overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontFamily: AppFont.bold,color: AppColor.whiteColor)),
                                     Text(capitalizeAllWord(widget.snapshotData['address']),
                                        style: const TextStyle(color: AppColor.whiteColor,fontSize: 12,fontFamily: AppFont.semiBold)),
                                     const SizedBox(height: 5),
                                    RatingBar.builder(
                                      initialRating: widget.snapshotData['rating'],
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      ignoreGestures : true,
                                      itemSize: 20,
                                      unratedColor: AppColor.whiteColor,
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        debugPrint('$rating');
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0,right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 if(widget.snapshotData['currentUser'] != FirebaseAuth.instance.currentUser?.email)...{
                                   GestureDetector(
                                     onTap: () async {
                                       //  String url = widget.snapshotData['webSiteUrl'];
                                       //  if (await canLaunch(url)) {
                                       //    await launch(url);
                                       //  } else {
                                       //    throw 'Could not launch $url';
                                       //  }
                                       //Navigator.push(context, MaterialPageRoute(builder: (context)=>ContactUsScreen()));

                                       Future<ChatRoomModel?> getChatroomModel() async {
                                         ChatRoomModel? chatRoom;

                                         QuerySnapshot snapshot1 = await FirebaseCollection().chatRoomCollection.
                                         where("participants.${FirebaseAuth.instance.currentUser?.uid}", isEqualTo: true).
                                         where("participants.${widget.snapshotData['uid']}", isEqualTo: true).get();

                                         if(snapshot1.docs.isNotEmpty) {
                                           var docData = snapshot1.docs[0].data();
                                           ChatRoomModel existingChatroom = ChatRoomModel.fromMap(docData as Map<String, dynamic>);
                                           chatRoom = existingChatroom;
                                         }
                                         else {
                                           ChatRoomModel newChatroom = ChatRoomModel(
                                             chatroomid: uuid.v1(),
                                             chatUserName1: userName,
                                             chatUserName2: widget.snapshotData['userName'],
                                             lastMessage: "",
                                             chatUser1: FirebaseAuth.instance.currentUser?.email,
                                             chatUser2: widget.snapshotData['currentUser'],
                                             lastMessageTime: DateTime.now().toString(),
                                             participants: {
                                               FirebaseAuth.instance.currentUser!.uid.toString(): true,
                                               widget.snapshotData['uid']: true,
                                             },
                                           );

                                           await FirebaseCollection().chatRoomCollection.doc(newChatroom.chatroomid).set(newChatroom.toMap());

                                           chatRoom = newChatroom;
                                           debugPrint("New Chatroom Created");
                                         }
                                         return chatRoom;
                                       }

                                       ChatRoomModel? chatroomModel = await getChatroomModel();
                                       if(chatroomModel != null) {
                                         if (!mounted) return;
                                         Navigator.push(context, MaterialPageRoute(
                                             builder: (context) {
                                               return ChatRoomPage(
                                                 snapshotUserName: widget.snapshotData['userName'],
                                                 chatroom: chatroomModel,
                                                 getOpenentUserEmail: widget.snapshotData['currentUser'],
                                                 // myUserName: userName,
                                               );
                                             }
                                         ));
                                       }

                                     },
                                     child: Padding(
                                       padding: const EdgeInsets.all(8.0),
                                       child: Column(
                                         children: [
                                           Image.network('https://cdn-icons-png.flaticon.com/128/14/14558.png',scale: 5,color: AppColor.appColor),
                                           const SizedBox(height: 5),
                                           const Text('Chat Now',style: TextStyle(fontFamily: AppFont.regular),)
                                         ],
                                       ),
                                     ),
                                   ),
                                 },
                                GestureDetector(
                                  onTap: () async {
                                    final launchUri = Uri(
                                        scheme: 'tel',
                                        path: widget.snapshotData['contactNumber']
                                    );
                                    await launchUrl(launchUri);
                                    //await launch('tel:${widget.snapshotData['contactNumber']}');
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children:  [
                                        Image.network('https://cdn-icons-png.flaticon.com/128/9637/9637721.png',scale: 5,color: AppColor.appColor,),
                                        const SizedBox(height: 5),
                                        const Text('Call Now',style: TextStyle(fontFamily: AppFont.regular),)
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {

                                    final String googleMapsUrl = "comgooglemaps://?center=${widget.snapshotData['latitude']},${widget.snapshotData['longitude']}";
                                    final String appleMapsUrl = "https://maps.apple.com/?q=${widget.snapshotData['latitude']},${widget.snapshotData['longitude']}";

                                    // if (await canLaunch(googleMapsUrl)) {
                                    //   await launch(googleMapsUrl);
                                    // }
                                    // if (await canLaunch(appleMapsUrl)) {
                                    //   await launch(appleMapsUrl, forceSafariVC: false);
                                    // } else {
                                    //   throw "Couldn't launch URL";
                                    // }
                                    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
                                      await launchUrl(Uri.parse(googleMapsUrl));
                                    }
                                    if (await canLaunchUrl(Uri.parse(appleMapsUrl))) {
                                      await launchUrl(Uri.parse(appleMapsUrl));
                                    } else {
                                      throw "Couldn't launch URL";
                                    }

                                    // var uri = Uri.parse("google.navigation:q=${widget.snapshotData['latitude']},"
                                    //     "${widget.snapshotData['longitude']}&mode=d");
                                    // if (await canLaunch(uri.toString())) {
                                    //   await launch(uri.toString());
                                    // } else {
                                    //   throw 'Could not launch ${uri.toString()}';
                                    // }
                                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                    //     DirectionScreen(longitude: widget.snapshotData['longitude'],
                                    //       latitude: widget.snapshotData['latitude'],
                                    //       shopName: widget.snapshotData['shopName'],
                                    //       shopAddress: widget.snapshotData['address'],
                                    //     )));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children:  [
                                        Image.network('https://cdn-icons-png.flaticon.com/128/9572/9572876.png',scale: 5,color: AppColor.appColor,),
                                        const SizedBox(height: 5),
                                        const Text('Direction',style: TextStyle(fontFamily: AppFont.regular),)
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> AppointmentBookScreen(snapshotData: widget.snapshotData,userEmail: userEmail,userMobile: userPhoneNumber,)));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children:  [
                                        Image.network('https://cdn-icons-png.flaticon.com/128/8659/8659110.png',scale: 5,color: AppColor.appColor,),
                                        const SizedBox(height: 5),
                                        const Text('Book Now',style: TextStyle(fontFamily: AppFont.regular),)
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 5,)
                        ],
                      ),
                      bottom: TabBar(
                          unselectedLabelColor: AppColor.blackColor,
                          labelPadding: const EdgeInsets.symmetric(vertical: 10),
                          // isScrollable: true,
                          controller: controller,
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelColor: AppColor.blackColor,
                          indicatorColor: AppColor.appColor,
                          labelStyle: const TextStyle(overflow: TextOverflow.ellipsis),
                          indicator: const UnderlineTabIndicator(
                              borderSide: BorderSide(width: 2,color: AppColor.appColor)
                          ),
                          tabs: _tabs
                      )
                  )
              )
            ];
          },
          body: TabBarView(
              controller: controller,
              children:  <Widget>[
                SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0,right: 10,top: 350),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.snapshotData['shopDescription'],style: const TextStyle(fontSize: 14,fontFamily: AppFont.regular)),
                      ],
                    ),
                  ),
                ),
                ReviewWidget(snapshotData: widget.snapshotData,shopName: widget.snapshotData['shopName'],
                  currentUser: widget.snapshotData['currentUser'],)
              ]),
        ),
      )
    );
  }
}
