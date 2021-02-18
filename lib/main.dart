import 'package:flutter/material.dart';
import './controller/pull_down_refresh_controller.dart';
import './utils/network_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  HttpHelper helper = HttpHelper();
  final tabs = ['领导人们', 'NBA', '奥运会', '黑命贵', '海外疫情', '好莱坞'];
  TabController _tabController;
  PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController =
        TabController(initialIndex: 0, length: tabs.length, vsync: this);
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "海外社交聚合",
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              print("Search");
            },
          ),
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                print("Setting");
              }),
        ],
        bottom: customTabBar(),
      ),
      body: customPageView(),
    );
  }

  // customTabBar
  Widget customTabBar() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      indicatorColor: Colors.orange,
      tabs: tabs
          .map((e) => Tab(
                text: e,
              ))
          .toList(),
      onTap: (tab) {
        print(tab);
        setState(() {
          _currentIndex = tab;
          _pageController.jumpToPage(_currentIndex);
        });
      },
    );
  }

  // customPageView
  Widget customPageView() {
    return PageView(
      controller: _pageController,
      children: tabs
          .map((e) => Container(
                child: Column(
                  children: [
                    Expanded(
                      child: PullDownRefreshController(),
                    ),
                  ],
                ),
              ))
          .toList(),
      onPageChanged: (position) {
        _currentIndex = position;
        _tabController.index = _currentIndex;
      },
    );
  }
}
