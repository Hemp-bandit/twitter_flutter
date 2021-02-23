import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twitter_flutter/model/item_model.dart';
import './post_content_card.dart';
import '../utils/network_helper.dart';

//刷新状态枚举
enum LoadingStatus {
  // 正在加载中
  STATUS_LOADING,
  // 数据加载完毕
  STATUS_COMPLETED,
  // 空闲状态
  STATUS_IDEL
}

class PullDownRefreshController extends StatefulWidget {
  final String categoryKey;
  PullDownRefreshController({this.categoryKey});

  @override
  _PullDownRefreshControllerState createState() =>
      _PullDownRefreshControllerState();
}

class _PullDownRefreshControllerState extends State<PullDownRefreshController> {
  Future mFuture;
  ScrollController _scrollController;
  int page = 1;
  //  数据源list
  static List dataSource;
//  加载中默认文字
  String loadText = "加载中...";

  @override
  void initState() {
    // TODO: implement initState
    dataSource = List();
    mFuture =
        HttpHelper.getItemListByCategory(page, widget.categoryKey); //初始化获取帖子信息
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 10) {
        setState(() {
          HttpHelper.getItemListByCategory(page++, widget.categoryKey)
              .then((value) => dataSource.addAll(value));
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: FutureBuilder(
          future: mFuture,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.done:
                if (dataSource.length == 0) {
                  dataSource = snapshot.data;
                }
                return _buildListView(snapshot.data);
            }
            return null;
          },
        ),
        onRefresh: () async {
          setState(() {
            mFuture = HttpHelper.getItemListByCategory(1, widget.categoryKey);
          });
        });
  }

  // ListView控件
  Widget _buildListView(List<Items> data) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: dataSource.length,
      itemBuilder: (context, index) {
        return PostContentCard(
          item: dataSource[index],
        );
      },
    );
  }

  Widget buildSnackBar() {
    return SnackBar(
      content: Text("已显示全部数据"),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5.0),
          topRight: Radius.circular(5.0),
        ),
      ),
      duration: Duration(seconds: 1),
    );
  }
}
