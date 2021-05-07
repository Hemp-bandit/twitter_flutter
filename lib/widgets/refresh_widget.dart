import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:weita_app/utils/network_helper.dart';
import 'dart:async';

import 'package:weita_app/widgets/post_content_widget.dart';

class RefreshWidget extends StatefulWidget {
  final String categoryKey;
  RefreshWidget(this.categoryKey);
  @override
  _RefreshWidgetState createState() => _RefreshWidgetState();
}

class _RefreshWidgetState extends State<RefreshWidget> {
  EasyRefreshController _controller = EasyRefreshController();
  int page = 1;
  //  数据源list
  static List dataSource;
  Future mFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataSource = List();
    // mFuture = HttpHelper.getItemListByCategory(page, widget.categoryKey); //初始化获取帖子信息
    initTheDataSource();
  }

  Future initTheDataSource() async {
    dataSource = await HttpHelper.getItemListByCategory(page, widget.categoryKey);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh.custom(
      enableControlFinishLoad: true,
      firstRefresh: true,
      firstRefreshWidget: Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
            child: SizedBox(
              height: 100.0,
              width: 150.0,
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 50.0,
                      height: 50.0,
                      child: CircularProgressIndicator(),
                    )
                  ],
                ),
              ),
            )),
      ),
      controller: _controller,
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 2), () {
          print('onRefresh');
          if (mounted) {
            setState(() {
              mFuture = HttpHelper.getItemListByCategory(1, widget.categoryKey);
            });
            _controller.resetLoadState();
          }
        });
      },
      onLoad: () async {
        List data = await HttpHelper.getItemListByCategory(page++, widget.categoryKey);
        await Future.delayed(Duration(seconds: 2), () {
          print('onLoad');
          if (mounted) {
            setState(() {
              dataSource.addAll(data);
            });
            print(dataSource);
          }
          _controller.finishLoad(success: dataSource.length == page * 10);
        });
      },
      header: ClassicalHeader(refreshingText: "刷新数据中...", refreshedText: "刷新完成"),
      footer: ClassicalFooter(loadingText: "加载更多...", loadedText: "加载完成"),
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              return Column(
                children: [
                  PostContentWidget(dataSource[index]),
                  Divider(),
                ],
              );
            },
            childCount: dataSource.length,
          ),
        ),
      ],
    );
  }
}

