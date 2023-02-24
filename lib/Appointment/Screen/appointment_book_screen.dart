import 'package:barber_booking_management/Firebase/firebase_collection.dart';
import 'package:barber_booking_management/mixin/button_mixin.dart';
import 'package:barber_booking_management/utils/app_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../utils/app_color.dart';
import '../../Category/provider/appointment_provider.dart';
import '../firebase/book_appointment.dart';

class AppointmentBookScreen extends StatefulWidget {

  var snapshotData,userEmail,userMobile;
  AppointmentBookScreen({Key? key,required this.snapshotData,required this.userEmail,
  required this.userMobile}) : super(key: key);

  @override
  State<AppointmentBookScreen> createState() => _AppointmentBookScreenState();
}

class _AppointmentBookScreenState extends State<AppointmentBookScreen> {

  DateTime? pickedDate;
  DateTime appointmentDate = DateTime.now();
  late Razorpay _razorpay;
  // static const platform = MethodChannel("razorpay_flutter");
  bool eightAmTime = false;

  List timeSlot = ['08:00 AM','09:00 AM','10:00 AM',
    '11:00 AM','12:00 PM',
    '02:00 PM','03:00 PM','04:00 PM','05:00 PM','06:00 PM','07:00 PM'];

  Future<void> selectAppointmentDate(BuildContext context) async {
    pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (pickedDate != null && pickedDate != Provider.of<AppointmentProvider>(context,listen: false).bookDate) {
      setState(() {
        Provider.of<AppointmentProvider>(context, listen: false).bookDate = pickedDate!;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    Provider.of<AppointmentProvider>(context,listen: false).onWillPop(context);
    Provider.of<AppointmentProvider>(context,listen: false).eightAmTime = false;
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout(BuildContext context) async {
    String price = '${widget.snapshotData['price']}00';
    debugPrint('Price $price');
    var options = {
      'key': 'rzp_test_CphmkEBGNw9BME',
      'amount': int.parse(price),
      'name': widget.snapshotData['shopName'],
      'description': 'Description Shop',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': widget.userMobile, 'email': widget.userEmail},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    debugPrint('Success Response: $response');
    var userSnapShotData = await FirebaseCollection().userCollection.where('userEmail', isEqualTo: FirebaseAuth.instance.currentUser?.email).get();
    for(var snapshotData in userSnapShotData.docs){
      BookAppointment().bookAppointment(
          shopName: widget.snapshotData['shopName'], shopDescription: widget.snapshotData['shopDescription'],
          shopEmail: widget.snapshotData['shopEmail'], barberName: widget.snapshotData['barberName'],
          hairCategory: widget.snapshotData['hairCategory'], price: widget.snapshotData['price'],
          longitudeShop: widget.snapshotData['longitude'], latitudeShop: widget.snapshotData['latitude'],
          contactNumber: widget.snapshotData['contactNumber'], webSiteUrl: widget.snapshotData['webSiteUrl'],
          gender: widget.snapshotData['gender'], address: widget.snapshotData['address'],
          coverPageImage: widget.snapshotData['coverPageImage'],
          barberImage: widget.snapshotData['barberImage'], shopImage: widget.snapshotData['shopImage'],
          userName: snapshotData.get('userName'), userMobile: snapshotData.get('userMobile'),
          userEmail: snapshotData.get('userEmail'), userImage: snapshotData.get('userImage'),
          userAppointmentDate: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10),
          userAppointmentTime:Provider.of<AppointmentProvider>(context,listen: false).timeSetAdd,
          timestamp: Timestamp.now());
    }
    //showAlertDialog(context);
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        buttonPadding : const EdgeInsets.fromLTRB(0, 20.0, 0.0,0),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          const SizedBox(height: 10,),
          Center(child: Image.asset(AppImage.checked,height: 50,width: 50,)),
          const Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(30,10,30,20),
              child: Text("Successfully your appointment book",textAlign: TextAlign.center,),
            ),
          ),
          GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                  color: AppColor.appColor,
                  child: ButtonMixin().appButton(text: 'OK',)))
        ],
      );
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint('Error Response: $response');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('External SDK Response: $response');
  }

  // showAlertDialog(BuildContext context) {
  //   Widget cancelButton = TextButton(
  //     child: const Text("Cancel",style: TextStyle(color: AppColor.whiteColor,fontSize: 12),),
  //     onPressed:  () {
  //       Navigator.pop(context);
  //     },
  //   );
  //   Widget continueButton = TextButton(
  //     child: const Text("Confirm",style: TextStyle(color: AppColor.whiteColor,fontSize: 12),),
  //     onPressed:  () async {
  //       Navigator.pop(context);
  //       var userSnapShotData = await FirebaseCollection().userCollection.where('userEmail', isEqualTo: FirebaseAuth.instance.currentUser?.email).get();
  //       for(var snapshotData in userSnapShotData.docs){
  //         BookAppointment().bookAppointment(
  //             shopName: widget.snapshotData['shopName'], shopDescription: widget.snapshotData['shopDescription'],
  //             shopEmail: widget.snapshotData['shopEmail'], barberName: widget.snapshotData['barberName'],
  //             hairCategory: widget.snapshotData['hairCategory'], price: widget.snapshotData['price'],
  //             longitudeShop: widget.snapshotData['longitude'], latitudeShop: widget.snapshotData['latitude'],
  //             contactNumber: widget.snapshotData['contactNumber'], webSiteUrl: widget.snapshotData['webSiteUrl'],
  //             gender: widget.snapshotData['gender'], address: widget.snapshotData['address'],
  //             coverPageImage: widget.snapshotData['coverPageImage'],
  //             barberImage: widget.snapshotData['barberImage'], shopImage: widget.snapshotData['shopImage'],
  //             userName: snapshotData.get('userName'), userMobile: snapshotData.get('userMobile'),
  //             userEmail: snapshotData.get('userEmail'), userImage: snapshotData.get('userImage'),
  //             userAppointmentDate: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10),
  //             userAppointmentTime:Provider.of<AppointmentProvider>(context,listen: false).timeSetAdd,
  //             timestamp: Timestamp.now());
  //         Provider.of<AppointmentProvider>(context,listen: false).onWillPop(context);
  //       }
  //       showDialog(context: context, builder: (BuildContext context){
  //         return AlertDialog(
  //           actionsAlignment: MainAxisAlignment.center,
  //           actions: [
  //             Column(
  //               children: [
  //                 const SizedBox(height: 10,),
  //                 Image.asset(AppImage.checked,height: 60,width: 60,),
  //                 const Padding(
  //                   padding: EdgeInsets.all(20.0),
  //                   child: Text("Successfully your appointment done",style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
  //                 ),
  //                 GestureDetector(
  //                   onTap: (){
  //                     Navigator.pop(context);
  //                   },
  //                     child: ButtonMixin().appButton(text: 'OK',))
  //               ],
  //             )
  //           ],
  //         );
  //       });
  //     },
  //   );
  //   AlertDialog alert = AlertDialog(
  //     backgroundColor: AppColor.appColor,
  //     titleTextStyle: const TextStyle(color: AppColor.whiteColor,fontSize: 18),
  //     title: const Text("Book Appointment"),
  //     content: const Text("Are you want to sure seat book",style: TextStyle(color: AppColor.whiteColor,fontSize: 12)),
  //     actions: [
  //       cancelButton,
  //       continueButton,
  //     ],
  //   );
  //
  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Book'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 20,right: 20),
          padding: const EdgeInsets.only(top:10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(widget.snapshotData['shopImage'],
                  width: double.infinity,height: 170,fit: BoxFit.fill),
              ),
              const SizedBox(height: 5),
              Text('${widget.snapshotData['shopName']}',maxLines: 1,overflow: TextOverflow.ellipsis,),
              const SizedBox(height: 2),
              RatingBar.builder(
                initialRating: widget.snapshotData['rating'],
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                ignoreGestures : true,
                itemSize: 16,
                unratedColor: AppColor.greyColor,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  debugPrint('$rating');
                },
              ),
              const SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('Price',style: TextStyle(fontSize: 12),),
                  const SizedBox(width: 10,),
                  Text('₹${widget.snapshotData['price']}',style: const TextStyle(fontSize: 16,color: AppColor.redColor),),
                ],
              ),
              const SizedBox(height: 5,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.watch_later_outlined,color: AppColor.appColor,size: 22,),
                  const SizedBox(width: 10,),
                  Text('${widget.snapshotData['openingHour']} - ${widget.snapshotData['closingHour']}',style: const TextStyle(fontSize: 12,height: 1.5),),
                ],
              ),
              Divider(height: 10,color: AppColor.blackColor.withOpacity(0.3),),

              const SizedBox(height: 20),

              GestureDetector(
                onTap : () {
                  selectAppointmentDate(context);
                  Provider.of<AppointmentProvider>(context,listen: false).onWillPop(context);
                },
                child: Container(
                  width: double.infinity,
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Select Date'),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.only(left: 10,right: 20,top: 15,bottom: 15),
                        decoration: BoxDecoration(
                            color: AppColor.textFieldColor,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.date_range_outlined,color: AppColor.appColor,size: 20,),
                            const SizedBox(width: 10),
                            Consumer<AppointmentProvider>(
                                builder: (BuildContext context, appointmentSnapshot, Widget? child) {
                                  return Text(
                                  DateFormat('dd-MM-yyyy').format(appointmentSnapshot.bookDate),style: const TextStyle(color: AppColor.appColor)
                                );
                              }
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Select Time'),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder(
                      stream: FirebaseCollection().bookAppointmentCollection.
                      where('shopName',isEqualTo: widget.snapshotData['shopName']).
                      where('userAppointmentDate',isEqualTo: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10)).
                      where('userAppointmentTime',isEqualTo: '08:00 AM').snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot)  {
                        if (snapshot.hasError || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none) {
                          return ButtonMixin().timeButton(
                              text: '08:00 AM',
                              bgColor: AppColor.appColor,
                              onPress: (){
                                debugPrint('Not Found Data');
                              }
                          );
                        } else if (snapshot.requireData.docChanges.isEmpty) {
                          return Consumer<AppointmentProvider>(
                              builder: (BuildContext context, appointmentSnapshot, Widget? child) {
                                return ButtonMixin().timeButton(
                                  text: '08:00 AM',
                                  bgColor:
                                  Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10) ==
                                      DateTime.now().toString().substring(0,10) && DateTime.now().hour >= 8 ? AppColor.greyColor :
                                  appointmentSnapshot.eightAmTime == false ? AppColor.appColor : AppColor.beachColor2,
                                  onPress: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10) ==
                                      DateTime.now().toString().substring(0,10) && DateTime.now().hour >= 8 ? null : (){
                                    appointmentSnapshot.getEightAmTime;
                                    appointmentSnapshot.timeSetAdd = '08:00 AM';
                                  }
                              );
                            }
                          );
                        } else {
                          return snapshot.data?.docs[0]['userEmail'] != FirebaseAuth.instance.currentUser?.email ?
                          ButtonMixin().timeButton(
                            text: '08:00 AM',
                            bgColor: AppColor.greyColor,
                          ) : ButtonMixin().timeButton(
                              text: '08:00 AM',
                              bgColor: AppColor.beachColor4);
                        }
                      }
                  ),
                  StreamBuilder(
                      stream: FirebaseCollection().bookAppointmentCollection.
                      where('shopName',isEqualTo: widget.snapshotData['shopName']).
                      where('userAppointmentDate',isEqualTo: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10)).
                      where('userAppointmentTime',isEqualTo: '09:00 AM').snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot)  {
                        if (snapshot.hasError || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none) {
                          return ButtonMixin().timeButton(
                              text: '09:00 AM',
                              bgColor: AppColor.appColor,
                              onPress: (){
                                debugPrint('Not Found Data');
                              }
                          );
                        } else if (snapshot.requireData.docChanges.isEmpty) {
                          return Consumer<AppointmentProvider>(
                              builder: (BuildContext context, appointmentSnapshot, Widget? child) {
                                return ButtonMixin().timeButton(
                                    text: '09:00 AM',
                                    bgColor: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10) ==
                                        DateTime.now().toString().substring(0,10) && DateTime.now().hour >= 9 ? AppColor.greyColor :
                                    appointmentSnapshot.nineAmTime == false ? AppColor.appColor : AppColor.beachColor2,
                                    onPress: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10) ==
                                        DateTime.now().toString().substring(0,10) && DateTime.now().hour >= 9 ? null : (){
                                      appointmentSnapshot.getNineAmTime;
                                      appointmentSnapshot.timeSetAdd = '09:00 AM';
                                    }
                                );
                              }
                          );
                        } else {
                          return snapshot.data?.docs[0]['userEmail'] != FirebaseAuth.instance.currentUser?.email ?
                          ButtonMixin().timeButton(
                            text: '09:00 AM',
                            bgColor: AppColor.greyColor,
                          ) : ButtonMixin().timeButton(
                              text: '09:00 AM',
                              bgColor: AppColor.beachColor4);
                        }
                      }
                  ),
                  StreamBuilder(
                      stream: FirebaseCollection().bookAppointmentCollection.
                      where('shopName',isEqualTo: widget.snapshotData['shopName']).
                      where('userAppointmentDate',isEqualTo: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10)).
                      where('userAppointmentTime',isEqualTo: '10:00 AM').snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot)  {
                        if (snapshot.hasError || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none) {
                          return ButtonMixin().timeButton(
                              text: '10:00 AM',
                              bgColor: AppColor.appColor,
                          );
                        } else if (snapshot.requireData.docChanges.isEmpty) {
                          return Consumer<AppointmentProvider>(
                              builder: (BuildContext context, appointmentSnapshot, Widget? child){
                                return ButtonMixin().timeButton(
                                    text: '10:00 AM',
                                    bgColor: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10) ==
                                        DateTime.now().toString().substring(0,10) && DateTime.now().hour >= 10 ? AppColor.greyColor :
                                    appointmentSnapshot.tenAmTime == false ? AppColor.appColor : AppColor.beachColor2,
                                    onPress: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10) ==
                                        DateTime.now().toString().substring(0,10) && DateTime.now().hour >= 10 ? null : (){
                                     appointmentSnapshot.getTenAmTime;
                                     appointmentSnapshot.timeSetAdd = '10:00 AM';
                                    }
                                );
                              }
                          );
                        } else {
                          return snapshot.data?.docs[0]['userEmail'] != FirebaseAuth.instance.currentUser?.email ?
                            ButtonMixin().timeButton(
                            text: '10:00 AM',
                            bgColor: AppColor.greyColor,
                          ) : ButtonMixin().timeButton(
                              text: '10:00 AM',
                              bgColor: AppColor.beachColor4);
                        }
                      }
                  ),
                  StreamBuilder(
                      stream: FirebaseCollection().bookAppointmentCollection.
                      where('shopName',isEqualTo: widget.snapshotData['shopName']).
                      where('userAppointmentDate',isEqualTo: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10)).
                      where('userAppointmentTime',isEqualTo: '11:00 AM').snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot)  {
                        if (snapshot.hasError || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none) {
                          return ButtonMixin().timeButton(
                              text: '11:00 AM',
                              bgColor: AppColor.appColor,
                              onPress: (){}
                          );
                        } else if (snapshot.requireData.docChanges.isEmpty) {
                          return Consumer<AppointmentProvider>(
                              builder: (BuildContext context, appointmentSnapshot, Widget? child) {
                                return ButtonMixin().timeButton(
                                    text: '11:00 AM',
                                    bgColor: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10) ==
                                        DateTime.now().toString().substring(0,10) && DateTime.now().hour >= 11 ? AppColor.greyColor :
                                    appointmentSnapshot.elevenAmTime == false ? AppColor.appColor : AppColor.beachColor2,
                                    onPress: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10) ==
                                        DateTime.now().toString().substring(0,10) && DateTime.now().hour >= 11 ? null : (){
                                       appointmentSnapshot.getElevenAmTime;
                                       appointmentSnapshot.timeSetAdd = '11:00 AM';
                                    }
                                );
                              }
                          );
                        } else {
                          return snapshot.data?.docs[0]['userEmail'] != FirebaseAuth.instance.currentUser?.email ?
                          ButtonMixin().timeButton(
                            text: '11:00 AM',
                            bgColor: AppColor.greyColor,
                          ) : ButtonMixin().timeButton(
                              text: '11:00 AM',
                              bgColor: AppColor.beachColor4);
                        }
                      }
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder(
                      stream: FirebaseCollection().bookAppointmentCollection.
                      where('shopName',isEqualTo: widget.snapshotData['shopName']).
                      where('userAppointmentDate',isEqualTo: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10)).
                      where('userAppointmentTime',isEqualTo: '12:00 PM').snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot)  {
                        if (snapshot.hasError || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none) {
                          return ButtonMixin().timeButton(
                              text: '12:00 PM',
                              bgColor: AppColor.appColor,
                              onPress: (){
                                debugPrint('Not Found Data');
                              }
                          );
                        } else if (snapshot.requireData.docChanges.isEmpty) {
                          return Consumer<AppointmentProvider>(
                              builder: (BuildContext context, appointmentSnapshot, Widget? child) {
                                return ButtonMixin().timeButton(
                                    text: '12:00 PM',
                                    bgColor: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10) ==
                                        DateTime.now().toString().substring(0,10) && DateTime.now().hour >= 12 ? AppColor.greyColor :
                                    appointmentSnapshot.twelvePmTime == false ? AppColor.appColor : AppColor.beachColor2,
                                    onPress: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10) ==
                                        DateTime.now().toString().substring(0,10) && DateTime.now().hour >= 12 ? null : (){
                                      appointmentSnapshot.getTwelvePmTime;
                                      appointmentSnapshot.timeSetAdd = '12:00 PM';
                                    }
                                );
                              }
                          );
                        } else {
                          return snapshot.data?.docs[0]['userEmail'] != FirebaseAuth.instance.currentUser?.email ?
                          ButtonMixin().timeButton(
                            text: '12:00 PM',
                            bgColor: AppColor.greyColor,
                          ) : ButtonMixin().timeButton(
                              text: '12:00 PM',
                              bgColor: AppColor.beachColor4);
                        }
                      }
                  ),
                  StreamBuilder(
                      stream: FirebaseCollection().bookAppointmentCollection.
                      where('shopName',isEqualTo: widget.snapshotData['shopName']).
                      where('userAppointmentDate',isEqualTo: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10)).
                      where('userAppointmentTime',isEqualTo: '02:00 PM').snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot)  {
                        if (snapshot.hasError || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none) {
                          return ButtonMixin().timeButton(
                              text: '02:00 PM',
                              bgColor: AppColor.appColor,
                              onPress: (){
                                debugPrint('Not Found Data');
                              }
                          );
                        } else if (snapshot.requireData.docChanges.isEmpty) {
                          return Consumer<AppointmentProvider>(
                              builder: (BuildContext context, appointmentSnapshot, Widget? child) {
                                return ButtonMixin().timeButton(
                                    text: '02:00 PM',
                                    bgColor: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10) ==
                                        DateTime.now().toString().substring(0,10) && DateTime.now().hour >= 14 ? AppColor.greyColor :
                                    appointmentSnapshot.twoPmTime == false ? AppColor.appColor : AppColor.beachColor2,
                                    onPress: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10) ==
                                        DateTime.now().toString().substring(0,10) && DateTime.now().hour >= 14 ? null : (){
                                      appointmentSnapshot.getTwoPmTime;
                                      appointmentSnapshot.timeSetAdd = '02:00 PM';
                                    }
                                );
                              }
                          );
                        } else {
                          return snapshot.data?.docs[0]['userEmail'] != FirebaseAuth.instance.currentUser?.email ?
                          ButtonMixin().timeButton(
                            text: '02:00 PM',
                            bgColor: AppColor.greyColor,
                          ) : ButtonMixin().timeButton(
                              text: '02:00 PM',
                              bgColor: AppColor.beachColor4);
                        }
                      }
                  ),
                  StreamBuilder(
                      stream: FirebaseCollection().bookAppointmentCollection.
                      where('shopName',isEqualTo: widget.snapshotData['shopName']).
                      where('userAppointmentDate',isEqualTo: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10)).
                      where('userAppointmentTime',isEqualTo: '03:00 PM').snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot)  {
                        if (snapshot.hasError || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none) {
                          return ButtonMixin().timeButton(
                              text: '03:00 PM',
                              bgColor: AppColor.appColor,
                              onPress: (){
                                debugPrint('Not Found Data');
                              }
                          );
                        } else if (snapshot.requireData.docChanges.isEmpty) {
                          return Consumer<AppointmentProvider>(
                              builder: (BuildContext context, appointmentSnapshot, Widget? child) {
                                return ButtonMixin().timeButton(
                                    text: '03:00 PM',
                                    bgColor: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10) ==
                                        DateTime.now().toString().substring(0,10) && DateTime.now().hour >= 15 ? AppColor.greyColor :
                                    appointmentSnapshot.threePmTime == false ? AppColor.appColor : AppColor.beachColor2,
                                    onPress: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10) ==
                                        DateTime.now().toString().substring(0,10) && DateTime.now().hour >= 15 ? null : (){
                                      appointmentSnapshot.getThreePmTime;
                                      appointmentSnapshot.timeSetAdd = '03:00 PM';
                                    }
                                );
                              }
                          );
                        }else {
                          return snapshot.data?.docs[0]['userEmail'] != FirebaseAuth.instance.currentUser?.email ?
                          ButtonMixin().timeButton(
                            text: '03:00 PM',
                            bgColor: AppColor.greyColor,
                          ) : ButtonMixin().timeButton(
                              text: '03:00 PM',
                              bgColor: AppColor.beachColor4);
                        }
                      }
                  ),
                  StreamBuilder(
                      stream: FirebaseCollection().bookAppointmentCollection.
                      where('shopName',isEqualTo: widget.snapshotData['shopName']).
                      where('userAppointmentDate',isEqualTo: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10)).
                      where('userAppointmentTime',isEqualTo: '04:00 PM').snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot)  {
                        if (snapshot.hasError || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none) {
                          return ButtonMixin().timeButton(
                              text: '04:00 PM',
                              bgColor: AppColor.appColor,
                              onPress: (){}
                          );
                        } else if (snapshot.requireData.docChanges.isEmpty) {
                          return Consumer<AppointmentProvider>(
                              builder: (BuildContext context, appointmentSnapshot, Widget? child) {
                                return ButtonMixin().timeButton(
                                    text: '04:00 PM',
                                    bgColor: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10) ==
                                        DateTime.now().toString().substring(0,10) && DateTime.now().hour >= 16 ? AppColor.greyColor :
                                    appointmentSnapshot.fourPmTime == false ? AppColor.appColor : AppColor.beachColor2,
                                    onPress: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10) ==
                                        DateTime.now().toString().substring(0,10) && DateTime.now().hour >= 16 ? null : (){
                                      appointmentSnapshot.getFourPmTime;
                                      appointmentSnapshot.timeSetAdd = '04:00 PM';
                                    }
                                );
                              }
                          );
                        } else {
                          return snapshot.data?.docs[0]['userEmail'] != FirebaseAuth.instance.currentUser?.email ?
                          ButtonMixin().timeButton(
                            text: '04:00 PM',
                            bgColor: AppColor.greyColor,
                          ) : ButtonMixin().timeButton(
                              text: '04:00 PM',
                              bgColor: AppColor.beachColor4);
                        }
                      }
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder(
                      stream: FirebaseCollection().bookAppointmentCollection.
                      where('shopName',isEqualTo: widget.snapshotData['shopName']).
                      where('userAppointmentDate',isEqualTo: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10)).
                      where('userAppointmentTime',isEqualTo: '05:00 PM').snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot)  {
                        if (snapshot.hasError || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none) {
                          return ButtonMixin().timeButton(
                              text: '05:00 AM',
                              bgColor: AppColor.appColor,
                              onPress: (){
                                debugPrint('Not Found Data');
                              }
                          );
                        } else if (snapshot.requireData.docChanges.isEmpty) {
                          return Consumer<AppointmentProvider>(
                              builder: (BuildContext context, appointmentSnapshot, Widget? child) {
                                return ButtonMixin().timeButton(
                                    text: '05:00 PM',
                                    bgColor: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10) ==
                                        DateTime.now().toString().substring(0,10) && DateTime.now().hour >= 17 ? AppColor.greyColor :
                                    appointmentSnapshot.fivePmTime == false ? AppColor.appColor : AppColor.beachColor2,
                                    onPress: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10) ==
                                        DateTime.now().toString().substring(0,10) && DateTime.now().hour >= 17 ? null : (){
                                      appointmentSnapshot.getFivePmTime;
                                      appointmentSnapshot.timeSetAdd = '05:00 PM';
                                    }
                                );
                              }
                          );
                        } else {
                          return snapshot.data?.docs[0]['userEmail'] != FirebaseAuth.instance.currentUser?.email ?
                          ButtonMixin().timeButton(
                            text: '05:00 PM',
                            bgColor: AppColor.greyColor,
                          ) : ButtonMixin().timeButton(
                              text: '05:00 PM',
                              bgColor: AppColor.beachColor4);
                        }
                      }
                  ),
                  StreamBuilder(
                      stream: FirebaseCollection().bookAppointmentCollection.
                      where('shopName',isEqualTo: widget.snapshotData['shopName']).
                      where('userAppointmentDate',isEqualTo: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10)).
                      where('userAppointmentTime',isEqualTo: '06:00 PM').snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot)  {
                        if (snapshot.hasError || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none) {
                          return ButtonMixin().timeButton(
                              text: '06:00 PM',
                              bgColor: AppColor.appColor,
                              onPress: (){
                                debugPrint('Not Found Data');
                              }
                          );
                        } else if (snapshot.requireData.docChanges.isEmpty) {
                          return Consumer<AppointmentProvider>(
                              builder: (BuildContext context, appointmentSnapshot, Widget? child) {
                                return ButtonMixin().timeButton(
                                    text: '06:00 PM',
                                    bgColor: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10) ==
                                        DateTime.now().toString().substring(0,10) && DateTime.now().hour >= 18 ? AppColor.greyColor :
                                    appointmentSnapshot.sixPmTime == false ? AppColor.appColor : AppColor.beachColor2,
                                    onPress: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10) ==
                                        DateTime.now().toString().substring(0,10) && DateTime.now().hour >= 18 ? null : (){
                                      appointmentSnapshot.getSixPmTime;
                                      appointmentSnapshot.timeSetAdd = '06:00 PM';
                                    }
                                );
                              }
                          );
                        } else {
                          return snapshot.data?.docs[0]['userEmail'] != FirebaseAuth.instance.currentUser?.email ?
                          ButtonMixin().timeButton(
                            text: '06:00 PM',
                            bgColor: AppColor.greyColor,
                          ) : ButtonMixin().timeButton(
                              text: '06:00 PM',
                              bgColor: AppColor.beachColor4);
                        }
                      }
                  ),
                  StreamBuilder(
                      stream: FirebaseCollection().bookAppointmentCollection.
                      where('shopName',isEqualTo: widget.snapshotData['shopName']).
                      where('userAppointmentDate',isEqualTo: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10)).
                      where('userAppointmentTime',isEqualTo: '07:00 PM').snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot)  {
                        if (snapshot.hasError || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none) {
                          return ButtonMixin().timeButton(
                              text: '07:00 PM',
                              bgColor: AppColor.appColor,
                              onPress: (){
                                debugPrint('Not Found Data');
                              }
                          );
                        } else if (snapshot.requireData.docChanges.isEmpty) {
                          return Consumer<AppointmentProvider>(
                              builder: (BuildContext context, appointmentSnapshot, Widget? child) {
                                return ButtonMixin().timeButton(
                                    text: '07:00 PM',
                                    bgColor: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10) ==
                                        DateTime.now().toString().substring(0,10) && DateTime.now().hour >= 19 ? AppColor.greyColor :
                                    appointmentSnapshot.sevenPMTime == false ? AppColor.appColor : AppColor.beachColor2,
                                    onPress: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10) ==
                                        DateTime.now().toString().substring(0,10) && DateTime.now().hour >= 19 ? null : (){
                                      appointmentSnapshot.getSevenPmTime;
                                      appointmentSnapshot.timeSetAdd = '07:00 PM';
                                    }
                                );
                              }
                          );
                        } else {
                          return snapshot.data?.docs[0]['userEmail'] != FirebaseAuth.instance.currentUser?.email ?
                          ButtonMixin().timeButton(
                            text: '07:00 PM',
                            bgColor: AppColor.greyColor,
                          ) : ButtonMixin().timeButton(
                              text: '07:00 PM',
                              bgColor: AppColor.beachColor4);
                        }
                      }
                  ),
                  StreamBuilder(
                      stream: FirebaseCollection().bookAppointmentCollection.
                      where('shopName',isEqualTo: widget.snapshotData['shopName']).
                      where('userAppointmentDate',isEqualTo: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10)).
                      where('userAppointmentTime',isEqualTo: '08:00 PM').snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot)  {
                        if (snapshot.hasError || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none) {
                          return ButtonMixin().timeButton(
                              text: '08:00 PM',
                              bgColor: AppColor.appColor,
                              onPress: (){}
                          );
                        } else if (snapshot.requireData.docChanges.isEmpty) {
                          return Consumer<AppointmentProvider>(
                              builder: (BuildContext context, appointmentSnapshot, Widget? child) {
                                return ButtonMixin().timeButton(
                                    text: '08:00 PM',
                                    bgColor: Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10) ==
                                        DateTime.now().toString().substring(0,10) && DateTime.now().hour >= 20 ? AppColor.greyColor :
                                    appointmentSnapshot.eightPmTime == false ? AppColor.appColor : AppColor.beachColor2,
                                    onPress:  Provider.of<AppointmentProvider>(context,listen: false).bookDate.toString().substring(0,10) ==
                                        DateTime.now().toString().substring(0,10) && DateTime.now().hour >= 20 ? null : (){
                                      appointmentSnapshot.getEightPmTime;
                                      appointmentSnapshot.timeSetAdd = '08:00 PM';
                                    }
                                );
                              }
                          );
                        } else {
                          return snapshot.data?.docs[0]['userEmail'] != FirebaseAuth.instance.currentUser?.email ?
                          ButtonMixin().timeButton(
                            text: '08:00 PM',
                            bgColor: AppColor.greyColor,
                          ) : ButtonMixin().timeButton(
                              text: '08:00 PM',
                              bgColor: AppColor.beachColor4);
                        }
                      }
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Container(color: AppColor.appColor,height: 10,width: 10,),
                  const SizedBox(width: 10),
                  const Text('Available Seat',style: TextStyle(fontSize: 12))
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Container(color: AppColor.greyColor,height: 10,width: 10,),
                  const SizedBox(width: 10),
                  const Text('Not Available Seat',style: TextStyle(fontSize: 12))
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Container(color: AppColor.beachColor4,height: 10,width: 10,),
                  const SizedBox(width: 10),
                  const Text('My Booked Seat',style: TextStyle(fontSize: 12))
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Container(color: AppColor.beachColor2,height: 10,width: 10,),
                  const SizedBox(width: 10),
                  const Text('Selected Seat',style: TextStyle(fontSize: 12),)
                ],
              ),
              const SizedBox(height: 50),
              Consumer<AppointmentProvider>(
                  builder: (BuildContext context, appointmentSnapshot, Widget? child) {
                    return GestureDetector(
                      onTap: appointmentSnapshot.eightAmTime != false ||
                          appointmentSnapshot.nineAmTime  != false ||
                          appointmentSnapshot.tenAmTime != false ||
                          appointmentSnapshot.elevenAmTime != false ||
                          appointmentSnapshot.twelvePmTime != false ||
                          appointmentSnapshot.twoPmTime  != false ||
                          appointmentSnapshot.threePmTime  != false ||
                          appointmentSnapshot.fourPmTime != false||
                          appointmentSnapshot.fivePmTime  != false ||
                          appointmentSnapshot.sixPmTime != false ||
                          appointmentSnapshot.sevenPMTime != false ||
                          appointmentSnapshot.eightPmTime != false ?
                          () async{
                            openCheckout(context);
                             // showAlertDialog(context);

                          } : null,
                          child: ButtonMixin().appButton(text: 'Book Now',
                          //     bgColor:
                          // appointmentSnapshot.eightAmTime != false ||
                          //     appointmentSnapshot.nineAmTime  != false ||
                          //     appointmentSnapshot.tenAmTime != false ||
                          //     appointmentSnapshot.elevenAmTime != false ||
                          //     appointmentSnapshot.twelvePmTime != false ||
                          //     appointmentSnapshot.twoPmTime  != false ||
                          //     appointmentSnapshot.threePmTime  != false ||
                          //     appointmentSnapshot.fourPmTime != false||
                          //     appointmentSnapshot.fivePmTime  != false ||
                          //     appointmentSnapshot.sixPmTime != false ||
                          //     appointmentSnapshot.sevenPMTime != false ||
                          //     appointmentSnapshot.eightPmTime != false ?
                          // AppColor.appColor :
                          // AppColor.greyColor
                          )
                  );
                }
              ),
              const SizedBox(height: 20)
            ],
          )
        ),
      ),
    );
  }
}
