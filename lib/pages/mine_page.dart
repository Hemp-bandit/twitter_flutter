/*
 * @LastEditors: wyswill
 * @Description: 
 * @Date: 2021-04-07 17:07:45
 * @LastEditTime: 2021-05-10 11:10:53
 */
import 'package:flutter/material.dart';
import 'package:weita_app/pages/sub_page/mine_sub/comment_page.dart';
import 'package:weita_app/pages/sub_page/mine_sub/favorite_page.dart';
import 'package:weita_app/pages/sub_page/mine_sub/subscribe_page.dart';
import 'package:weita_app/widgets/mine/user_tab.dart';
import 'package:weita_app/widgets/mine/user_tile.dart';

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF1F1F1),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: 150.0,
              child: UserTile(),
            ),
          ),
          SliverToBoxAdapter(
            child: ListTile(
              title: Text(
                "经常访问的人",
                style: TextStyle(fontSize: 16.0),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              subtitle: Container(
                // color: Colors.grey,
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2121472252,1294774723&fm=26&gp=0.jpg"),
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2121472252,1294774723&fm=26&gp=0.jpg"),
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2121472252,1294774723&fm=26&gp=0.jpg"),
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2121472252,1294774723&fm=26&gp=0.jpg"),
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2121472252,1294774723&fm=26&gp=0.jpg"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: UserTabBar(),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 400,
              child: PageView(
                children: [
                  CommentPage(),
                  FavoritePage(),
                  SubscribePage(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
