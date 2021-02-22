import 'package:flutter/material.dart';
import './controller/pull_down_refresh_controller.dart';
import './utils/network_helper.dart';

// pages
import './controller/setting_controller.dart';

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
  TabController _tabController; //TabBar控制器
  PageController _pageController; //PageView控制器

  Future uFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uFuture = HttpHelper.getItemCategory();
    uFuture.then((value) => _tabController = TabController(initialIndex: 0, length: value.length, vsync: this));
    // _tabController = TabController(initialIndex: 0, length: 11, vsync: this);
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    _pageController.dispose();
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
            // IconButton(
            //   icon: Icon(Icons.search),
            //   onPressed: () {
            //     print("Search");
            //   },
            // ),
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  print("Setting");
                  // 跳转至设置页面
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingPage()),
                  );
                }),
          ],
          bottom: PreferredSize(
            child: loadTabBar(),
            preferredSize: Size.fromHeight(48.0),
          )),
      body: FutureBuilder(
        future: uFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              return customPageView(snapshot.data);
          }
          return null;
        },
      ),
    );
  }

//  通过网络请求加载TabBar
  Widget loadTabBar() {
    return FutureBuilder(
      future: uFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.done:
            return customTabBar(snapshot.data);
        }
        return null;
      },
    );
  }

  // customTabBar
  Widget customTabBar(Map data) {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      indicatorColor: Colors.orange,
      tabs: data.keys
          .map((e) => Tab(
                text: data[e],
              ))
          .toList(),
      onTap: (tab) {
        setState(() {
          _currentIndex = tab;
          _pageController.jumpToPage(_currentIndex);
        });
      },
    );
  }

  // customPageView
  Widget customPageView(Map data) {
    return PageView(
      controller: _pageController,
      children: data.keys
          .map(
            (e) => Column(
                children: [
                  Expanded(
                    child: PullDownRefreshController(
                      categoryKey: e,
                    ),
                  ),
                ],
            ),
          )
          .toList(),
      onPageChanged: (position) {
        _currentIndex = position;
        _tabController.index = _currentIndex;
      },
    );
  }
}
