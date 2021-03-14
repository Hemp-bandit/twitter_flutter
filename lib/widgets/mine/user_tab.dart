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
  Widget build(BuildContext context) {
    return TabBar(
        controller: _tabController,
        tabs: _tabs
            .map((e) => Tab(
                  text: e,
                ))
            .toList());
  }
}
