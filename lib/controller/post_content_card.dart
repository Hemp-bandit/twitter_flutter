import 'package:flutter/material.dart';
import 'package:twitter_flutter/model/item_model.dart';
import 'package:twitter_flutter/model/user_info_model.dart';
import 'package:twitter_flutter/utils/network_helper.dart';

class PostContentCard extends StatefulWidget {
  final Items item;
  final String username;
  PostContentCard({this.item, this.username});

  @override
  _PostContentCardState createState() => _PostContentCardState();
}

class _PostContentCardState extends State<PostContentCard> {
  Future uFuture;
  Future transFuture;
  bool isShow = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uFuture = HttpHelper.getUserInfo(widget.username);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    print("referenced: ${widget.item.referenced_tweets}");
    print("attachments: ${widget.item.attachments}");
    return Card(
      child: Column(
        children: [
          accountInfoWidget(),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              widget.item.text,
              textAlign: TextAlign.left,
            ),
          ),
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: InkWell(
          //     child: Text("查看更多"),
          //     onTap: () {
          //       print(123);
          //     },
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: imageWidget(widget.item.attachments),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: transActionWidget(),
            ),
          ),
          translateWidget(isShow, widget.item.lang),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: footerWidget(),
          ),
        ],
      ),
    );
  }

//  账号信息Widget
  Widget accountInfoWidget() {
    return FutureBuilder(
      future: uFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator(),);
          case ConnectionState.done:
            if (snapshot.data == null) {
              return Text("暂无数据");
            } else {
              return accountInfoListTile(snapshot.data);
            }
        }
        return null;
      },);
  }

//  用户信息ListTile
  Widget accountInfoListTile(Map data) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(data['qiniuUrl']),
      ),
      title: Text(
        data['name'],
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
      subtitle: Text(
        "@${data['username']}",
        style: TextStyle(
          fontSize: 14.0,
        ),
      ),
      trailing: Text(
        "from Twitter",
      ),
    );
  }
  
//  图片Widget
  Widget imageWidget(Map data) {
    if (data != null) {
      return FittedBox(
        child: Row(
          children: [
            Image.network(
              "http://${data['media_keys'][0]}",
              fit: BoxFit.fill,
            ),
            SizedBox(
              width: 5.0,
            ),
            Image.network(
              "http://${data['media_keys'][1]}",
              fit: BoxFit.fill,
            ),
          ],
        ),
      );
    } else {
      return Container(
        width: 0,
        height: 0,
      );
    }
  }

  Widget translateWidget(bool show, String lang) {
    if (show == false || lang == 'zh') {
      return Container(
        width: 0,
        height: 0,
      );
    } else {
      return FutureBuilder(
        future: transFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator(),);
            case ConnectionState.done:
              if (snapshot.data == null) {
                return Text("暂无数据");
              } else {
                print("data: ${snapshot.data}");
                return Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    snapshot.data,
                    textAlign: TextAlign.left,
                  ),
                );
              }
          }
          return null;
        },);
    }
  }

  Widget transActionWidget() {
    return InkWell(
      child: Icon(Icons.translate),
      onTap: () {
        transFuture = HttpHelper.translatePost(widget.item.twitterId);
        setState(() {
          isShow = !isShow;
        });
      },
    );
  }

  Widget footerWidget() {
    DateTime date = DateTime.parse(widget.item.created);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "${date.year}.${date.month}.${date.day}\t${date.hour}:${date.minute}:${date.second}",
          style: TextStyle(
            fontSize: 13.0,
          ),
        ),
      ],
    );
  }

}
