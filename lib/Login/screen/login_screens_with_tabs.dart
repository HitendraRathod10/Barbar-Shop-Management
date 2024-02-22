import 'package:flutter/material.dart';

import '../../utils/app_color.dart';
import '../../utils/app_font.dart';
import 'login_screen.dart';

class LoginScreensWithTabs extends StatefulWidget {
  const LoginScreensWithTabs({Key? key}) : super(key: key);

  @override
  State<LoginScreensWithTabs> createState() => _LoginScreensWithTabsState();
}

  class _LoginScreensWithTabsState extends State<LoginScreensWithTabs> with TickerProviderStateMixin {

  late TabController customerTabController;
  final List<Widget> _tabs = [
    const Tab(child: FittedBox(child: Text('User',style: TextStyle(fontSize: 20,fontFamily: AppFont.bold)))),
    const Tab(child: FittedBox(child: Text('Shop Owner',style: TextStyle(fontSize: 20,fontFamily: AppFont.bold)))),
  ];
  int selectedTab = 0;

  @override
  void initState() {
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
            borderSide: BorderSide(width: 3.5,color: AppColor.appColor),
          ),
          tabs: _tabs,
          onTap: (val) {
            setState(() {
              selectedTab = val;
              print("SELECTED_USER $selectedTab");
            });
          },
        ),
      ),
      body: TabBarView(
        controller: customerTabController,
        children:  [
          LoginScreen(selectedTab == 0 ? "User":"Shop Owner"),
          LoginScreen(selectedTab == 0 ? "User":"Shop Owner"),
        ],
      ),
    );
  }
  }
