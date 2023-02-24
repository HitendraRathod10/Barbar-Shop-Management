// import 'package:barber_booking_management/mixin/button_mixin.dart';
// import 'package:barber_booking_management/mixin/textfield_mixin.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../utils/app_color.dart';
//
// class SearchScreen extends StatefulWidget {
//   const SearchScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//
//   static Future<String?> getData(Uri uri,{Map<String,String>? headers}) async{
//     try{
//       final response = await http.get(uri,headers: headers);
//       if(response.statusCode == 200){
//         return response.body;
//       }
//     }
//
//     catch(e){
//       debugPrint("Exception");
//     }
//   }
//
//   void placeAutoComplete(String query) async{
//     Uri uri = Uri.https(
//         'maps.googleapis.com',
//         'maps/api/place/autocomplete/json',
//         {
//           'input' : query,
//           'key' : 'AIzaSyBez4Qknt1n156OXb8MmiEIMOdX6Eb8VJg'
//         }
//     );
//
//     String? response = await getData(uri);
//     if(response!=null){
//       print(response);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final formKey = GlobalKey<FormState>();
//     final controller = TextEditingController();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Search'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(20,20,20,20),
//           child: Form(
//             key: formKey,
//             child: Column(
//               children: [
//                 TextFieldMixin().textFieldWidget(
//                   controller: controller,
//                   textInputAction: TextInputAction.next,
//                   hintText: "Enter Location",
//                   prefixIcon: const Icon(Icons.location_on_outlined,color: AppColor.appColor),
//                 ),
//                 GestureDetector(
//                   onTap: (){
//                     placeAutoComplete(controller.text);
//                   },
//                   child: ButtonMixin().appButton(
//                     text: 'Find Location'
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Text('Finding Location here')
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
