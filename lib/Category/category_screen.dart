import 'package:barber_booking_management/Category/screen/category_shop_details_screen.dart';
import 'package:barber_booking_management/utils/app_image.dart';
import 'package:flutter/material.dart';
import '../utils/app_color.dart';
import 'model/category_model.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {


  String gender = 'Male';
  List<ServiceListModel> maleHairCategoryList = <ServiceListModel>[
    ServiceListModel(serviceName: 'Medium Length',serviceGender: 'Male', serviceImage: AppImage.mediumLength),
    ServiceListModel(serviceName: 'Bun Cut',serviceGender: 'Male', serviceImage: AppImage.bunCut),
    ServiceListModel(serviceName: 'French Crop',serviceGender: 'Male', serviceImage: AppImage.frenchCrop),
    ServiceListModel(serviceName: 'Faux Hawk',serviceGender: 'Male', serviceImage: AppImage.fauxHawk),
    ServiceListModel(serviceName: 'Fringe',serviceGender: 'Male', serviceImage: AppImage.fringe),
    ServiceListModel(serviceName: 'Buzz Cut',serviceGender: 'Male', serviceImage: AppImage.buzzCut),
    ServiceListModel(serviceName: 'Man Bread',serviceGender: 'Male', serviceImage: AppImage.manBread),
    ServiceListModel(serviceName: 'Pixie Cut',serviceGender: 'Male', serviceImage: AppImage.pixieCut),
    ServiceListModel(serviceName: 'Crew Cut',serviceGender: 'Male', serviceImage: AppImage.crewCut),
  ];

  List<ServiceListModel> femaleHairCategoryList = <ServiceListModel>[
    ServiceListModel(serviceName: 'Medium Length',serviceGender: 'Female', serviceImage: AppImage.femaleMediumLength),
    ServiceListModel(serviceName: 'Bun Cut',serviceGender: 'Female', serviceImage: AppImage.femaleBunCut),
    ServiceListModel(serviceName: 'French Crop',serviceGender: 'Female', serviceImage: AppImage.femaleFrenchCrop),
    ServiceListModel(serviceName: 'Faux Hawk',serviceGender: 'Female', serviceImage: AppImage.femaleFauxHawk),
    ServiceListModel(serviceName: 'Fringe',serviceGender: 'Female', serviceImage: AppImage.femaleFringe),
    ServiceListModel(serviceName: 'Buzz Cut',serviceGender: 'Female', serviceImage: AppImage.femaleBuzzCut),
    ServiceListModel(serviceName: 'Female Bread',serviceGender: 'Female', serviceImage: AppImage.femaleBread),
    ServiceListModel(serviceName: 'Pixie Cut',serviceGender: 'Female', serviceImage: AppImage.femalePixieCut),
    ServiceListModel(serviceName: 'Crew Cut',serviceGender: 'Female', serviceImage: AppImage.femaleCrewCut),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Category'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text('Gender'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Radio(value: 'Male', groupValue: gender, onChanged: (index) {
                          setState((){
                            gender = index.toString();
                          });
                        }),
                        const Text('Male')
                      ],
                    ),
                    Row(
                      children: [
                        Radio(value: "Female", groupValue: gender, onChanged: (index) {
                          setState((){
                            gender = index.toString();
                          });
                        }),
                        const Text('Female')
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ListView.builder(
                    itemCount: gender == 'Male' ? maleHairCategoryList.length : femaleHairCategoryList.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context,index){
                      return
                        // child: Container(
                        //   margin: const EdgeInsets.only(right: 10,top: 10),
                        //   width: double.infinity,
                        //   decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(10)
                        //   ),
                        //   child:  Row(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     children: [
                        //       ClipRRect(
                        //         child: Image.network(
                        //           gender == 'Male' ? maleHairCategoryList[index].serviceImage : femaleHairCategoryList[index].serviceImage,
                        //           height: 90,width: 80,fit: BoxFit.fill,),
                        //       ),
                        //       Expanded(
                        //         child: Padding(
                        //           padding: const EdgeInsets.only(left: 10),
                        //           child: Column(
                        //             mainAxisAlignment: MainAxisAlignment.start,
                        //             crossAxisAlignment: CrossAxisAlignment.start,
                        //             children:  [
                        //               Text(
                        //                   gender == 'Male' ? maleHairCategoryList[index].serviceName : femaleHairCategoryList[index].serviceName,
                        //                   style : const TextStyle(color: AppColor.appColor),maxLines: 2,overflow: TextOverflow.ellipsis),
                        //               const SizedBox(height: 2),
                        //               Text(
                        //                   gender == 'Male' ? maleHairCategoryList[index].serviceGender : femaleHairCategoryList[index].serviceGender,
                        //                   style : const TextStyle(color: AppColor.aquaColor2,fontSize: 12),maxLines: 2,overflow: TextOverflow.ellipsis),
                        //               const SizedBox(height: 4),
                        //               // const Text('30 Shop',
                        //               //     style : TextStyle(color: AppColor.blackColor,fontSize: 10),overflow: TextOverflow.ellipsis),
                        //             ],
                        //           ),
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        Container(
                          height: 150,
                          margin: const EdgeInsets.only(right: 10,bottom: 10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: index.isEven ? AppColor.summerColor4.withOpacity(0.3) : AppColor.summerColor2.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child:  Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 30,top: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:  [
                                      Text(
                                          gender == 'Male' ? maleHairCategoryList[index].serviceName : femaleHairCategoryList[index].serviceName,
                                          style : const TextStyle(color: AppColor.appColor),maxLines: 2,overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 2),
                                      Text(
                                          gender == 'Male' ? maleHairCategoryList[index].serviceGender : femaleHairCategoryList[index].serviceGender,
                                          style : const TextStyle(color: AppColor.aquaColor2,fontSize: 12),maxLines: 2,overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 4),
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoryShopDetailScreen(hairCategory: maleHairCategoryList[index].serviceName,gender: gender,)));
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(top: 20),
                                          padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: AppColor.appColor,
                                              borderRadius: BorderRadius.circular(20)
                                          ),
                                          child: const Center(child: Text('View Shop',style : TextStyle(color: AppColor.whiteColor))),
                                        ),
                                      )
                                      // const Text('30 Shop',
                                      //     style : TextStyle(color: AppColor.blackColor,fontSize: 10),overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              ClipRRect(
                                child: Image.asset(
                                  gender == 'Male' ? maleHairCategoryList[index].serviceImage :
                                  femaleHairCategoryList[index].serviceImage,
                                  height: double.infinity,width: 120,fit: BoxFit.fill,),
                              ),
                            ],
                          ),
                        );
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
