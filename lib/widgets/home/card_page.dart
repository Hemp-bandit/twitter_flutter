/*
 * @LastEditors: wyswill
 * @Description: 
 * @Date: 2021-05-10 10:52:41
 * @LastEditTime: 2021-05-14 16:23:43
 */
import 'package:flutter/material.dart';
import 'package:weita_app/utils/network_helper.dart';
import 'package:weita_app/widgets/post_content_widget.dart';

class CardPage extends StatefulWidget {
  final String categoryKey;
  CardPage(this.categoryKey);

  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  PageController _pageController = PageController();
  int page = 1;
  //  数据源list
  static List dataSource;
  Future mFuture;

  @override
  void initState() {
    super.initState();
    print("userTokenAgain = ${HttpHelper.userToken}");
    mFuture = HttpHelper.getItemListByCategory(page, widget.categoryKey);
  }

  Future initTheDataSource() async {
    dataSource =
        await HttpHelper.getItemListByCategory(page, widget.categoryKey);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: mFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(
              child: Container(),
            );
          case ConnectionState.done:
            return contentPageView(snapshot.data);
        }
        return null;
      },
    );
  }

  Widget contentPageView(List dataSource) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: dataSource.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(15.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: PostContentWidget(
            dataSource[index],
          ),
        );
      },
      onPageChanged: (index) async {
        _pageController.jumpToPage(index);
        if (index <= dataSource.length - 2) {
          List data = await HttpHelper.getItemListByCategory(
              page++, widget.categoryKey);
          setState(() {
            dataSource.addAll(data);
          });
        }
      },
    );
  }
}
