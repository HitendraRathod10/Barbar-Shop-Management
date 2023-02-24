import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../Login/provider/loading_provider.dart';
import '../utils/app_color.dart';

class Loading extends StatelessWidget {
  final Widget? child;

  const Loading({this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoadingProvider>(
      builder: (context, data, _) {
        return IgnorePointer(
          ignoring: data.isLoading,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              child!,
              if (data.isLoading)
                const Center(
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.transparent,
                    child: SpinKitSpinningLines(
                      color: AppColor.appColor,
                      size: 40,
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
