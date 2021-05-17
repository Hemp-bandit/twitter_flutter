import 'package:flutter/material.dart';
import 'package:weita_app/pages/mine_page.dart';
// utils
import 'package:weita_app/utils/network_helper.dart';
import 'package:weita_app/widgets/SearchBarDelegate.dart';
import 'package:weita_app/widgets/home/card_page.dart';

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
    super.initState();
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
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leading: Center(
      //     child: Text(
      //       "WEITA",
      //       style: TextStyle(
      //           color: Color(0xFF227CFA),
      //           fontSize: 17.0,
      //           fontWeight: FontWeight.bold),
      //     ),
      //   ),
      //   title: GestureDetector(
      //     child: Center(
      //       child: Container(
      //         width: MediaQuery.of(context).size.width * 0.6,
      //         height: 35.0,
      //         decoration: BoxDecoration(
      //           color: Colors.grey[200],
      //           borderRadius: BorderRadius.circular(20.0),
      //         ),
      //         padding: EdgeInsets.only(left: 10.0, right: 10.0),
      //         child: Align(
      //           alignment: Alignment.centerLeft,
      //           child: Text(
      //             "搜索",
      //             style:
      //                 TextStyle().copyWith(fontSize: 16.0, color: Colors.grey),
      //           ),
      //         ),
      //       ),
      //     ),
      //     onTap: () {
      //       showSearch(context: context, delegate: SearchBarDelegate());
      //     },
      //   ),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Navigator.push(
        //           context, MaterialPageRoute(builder: (context) => MinePage()));
        //     },
        //     icon: Icon(
        //       Icons.menu,
        //       color: Color(0xFF227CFA),
        //     ),
        //   ),
        // ],
        // bottom: PreferredSize(
        //   preferredSize: Size.fromHeight(38.0),
        //   child: loadTabBar(),
        // ),
      // ),
      body: Column(
        children: [
          Expanded(
            child: CardPage('political'),
          ),
        ],
      ),
    );
  }

  //  通过网络请求加载TabBar
  Widget loadTabBar() {
    print("tabBar: ${HttpHelper.userToken}");
    return FutureBuilder(
      future: uFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(
              child: Container(),
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
                  child: CardPage(e),
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
