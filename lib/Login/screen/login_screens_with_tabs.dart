import 'package:flutter/material.dart';

import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
import 'login_screen.dart';

class LoginScreensWithTabs extends StatefulWidget {
  const LoginScreensWithTabs({Key? key}) : super(key: key);

  @override
  State<LoginScreensWithTabs> createState() => _LoginScreensWithTabsState();
}

class _LoginScreensWithTabsState extends State<LoginScreensWithTabs> with TickerProviderStateMixin{

  late TabController customerTabController;
  final List<Widget> _tabs = [
    const Tab(child: FittedBox(child: Text('User',style: TextStyle(fontSize: 20,fontFamily: AppFont.bold)))),
    const Tab(child: FittedBox(child: Text('Shop Owner',style: TextStyle(fontSize: 20,fontFamily: AppFont.bold)))),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    customerTabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: TabBar(
            controller: customerTabController,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: AppColor.blackColor,
            indicatorColor: AppColor.appColor,
            indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(width: 3.5,color: AppColor.appColor)
            ),
            tabs: _tabs,
            onTap: (val) {
              // quoteTabController.animateTo(0);
              // orderTabController.animateTo(0);
              // setState(() {});
            },
          ),
        ),
        body:TabBarView(
          controller: customerTabController,
          children:  const [
            LoginScreen(),
            // LoginScreenAdmin(),
            // LoginScreenEmployee()
          ],
        )
    );
  }
}
