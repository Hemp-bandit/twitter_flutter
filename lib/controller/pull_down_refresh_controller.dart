import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twitter_flutter/model/item_model.dart';
import './post_content_card.dart';
import '../utils/network_helper.dart';

class PullDownRefreshController extends StatefulWidget {
  @override
  _PullDownRefreshControllerState createState() =>
      _PullDownRefreshControllerState();
}

class _PullDownRefreshControllerState extends State<PullDownRefreshController> {
  Future mFuture;

  @override
  void initState() {
    // TODO: implement initState
    mFuture = HttpHelper.getItemListByPage();
    super.initState();
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
            print("reload");
          });
        });
  }

  Widget _buildListView(ItemModel data) {
    return ListView.builder(
      itemCount: data?.items == null ? 0 : data.items.length,
      itemBuilder: (context, index) {
        return PostContentCard(item: data.items[index]);
      },
    );
  }
}
