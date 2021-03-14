import 'package:flutter/material.dart';

// widgets
import 'package:weita_app/widgets/progress_indicator_widget.dart';
import 'package:weita_app/widgets/post_content_widget.dart';

// utils
import 'package:weita_app/utils/network_helper.dart';
import 'package:weita_app/widgets/refresh_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  TabController _tabController; //TabBar控制器
  PageController _pageController; //PageView控制器

  Future uFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    HttpHelper.initToken(true, "");
    uFuture = HttpHelper.getItemCategory();
    uFuture.then((value) => _tabController =
        TabController(initialIndex: 0, length: value.length, vsync: this));
    // _tabController = TabController(initialIndex: 0, length: 11, vsync: this);
    _pageController = PageController(initialPage: 0);
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   _tabController.dispose();
  //   _pageController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Center(child: Text("WEITA", style: TextStyle(color: Color(0xFF227CFA), fontSize: 17.0, fontWeight: FontWeight.bold),),),
        actions: [
          IconButton(
            onPressed: () {
              print(123);
            },
            icon: Icon(
              Icons.menu,
              color: Color(0xFF227CFA),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(38.0),
          child: loadTabBar(),
        ),
      ),
      body: FutureBuilder(
        future: uFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(
                child: loadingProgressIndicator(),
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
              child: loadingProgressIndicator(),
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
    return Container(
      height: 30.0,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorWeight: 5.0,
        indicatorColor: Color(0xFF227CFA),
        unselectedLabelColor: Colors.black54,
        unselectedLabelStyle: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
        labelColor: Colors.black,
        labelStyle: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
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
      ),
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
              child: RefreshWidget(e),
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