import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twitter_flutter/model/item_model.dart';
import './post_content_card.dart';
import '../utils/network_helper.dart';

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



  @override
  void initState() {
    // TODO: implement initState
    mFuture = HttpHelper.getItemListByCategory(page, widget.categoryKey); //初始化获取帖子信息
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels > _scrollController.position.maxScrollExtent - 20) {
        setState(() {
          mFuture = HttpHelper.getItemListByCategory(page++, widget.categoryKey);
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
                return Center(child: CircularProgressIndicator(),);
              case ConnectionState.done:
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
      itemCount: data.length,
      itemBuilder: (context, index) {
        return PostContentCard(item: data[index], username: data[index].username,);
      },
    );
  }
}
