import 'package:flutter/material.dart';

class UserTabBar extends StatefulWidget {
  @override
  _UserTabBarState createState() => _UserTabBarState();
}

class _UserTabBarState extends State<UserTabBar>
    with SingleTickerProviderStateMixin {
  List<String> _tabs = ["关注动态", "喜欢", "评论"];
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
        controller: _tabController,
        labelColor: Color(0xff000000),
        unselectedLabelColor: Color(0xff787878),
        labelStyle: TextStyle(fontSize: 18.0),
        tabs: _tabs
            .map((e) => Tab(
                  text: e,
                ))
            .toList());
  }
}
