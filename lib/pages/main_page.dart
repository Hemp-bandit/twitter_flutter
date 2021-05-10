import 'package:flutter/material.dart';
import 'package:weita_app/pages/category_page.dart';
// controller
import 'package:weita_app/pages/home_page.dart';
import 'package:weita_app/pages/mine_page.dart';
import 'package:weita_app/utils/network_helper.dart';
import 'package:weita_app/utils/save_user_data.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController _pageController;
  int _currentIndex = 0;
  String token;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  Future getTheToken() async {
    token = await SaveUserData.getToken();
    HttpHelper.userToken = token;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomePage(),
      // bottomNavigationBar: weitaBottomNavigationBar(),
    );
  }

  Widget contentPageView() {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        HomePage(),
        CategoryPage(),
        MinePage(),
      ],
    );
  }

  Widget weitaBottomNavigationBar() {
    Map itemMap = {
      "home": {"label": "首页", "icon": Icon(Icons.home)},
      "category": {"label": "分类", "icon": Icon(Icons.category)},
      "mine": {"label": "我的", "icon": Icon(Icons.person)},
    };

    return BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Color(0xFF227CFA),
        items: itemMap.keys
            .map((e) => BottomNavigationBarItem(
                icon: itemMap[e]['icon'], label: itemMap[e]['label']))
            .toList(),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(_currentIndex);
          });
        });
  }
}
