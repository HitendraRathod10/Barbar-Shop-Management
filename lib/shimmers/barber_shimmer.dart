import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/app_image.dart';

class BarberShimmers extends StatelessWidget {
  const BarberShimmers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(left: 10),
      child: ListView.builder(
          itemCount: 10,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey.shade200,
              highlightColor: Colors.white,
              child: SizedBox(
                width: 80,
                height: 100,
                child: Column(
                  children: [
                    ClipOval(
                      child: Container(height: 60,width: 60,color: Colors.grey.shade200)
                    ),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }
}
