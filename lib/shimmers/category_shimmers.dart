import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategoryShimmers extends StatelessWidget {
  const CategoryShimmers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: Colors.white,
      baseColor: Colors.grey.shade100,
      child: SizedBox(
        height: 290,
        child: ListView.builder(
            itemCount: 4,
            shrinkWrap: true,
            primary: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(left: 10),
                width: 200,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomRight: Radius.circular(30)),
                ),
                child: const Card(),
              );
            }
        ),
      ),
    );
  }
}
