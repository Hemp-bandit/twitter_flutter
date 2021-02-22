import 'package:flutter/material.dart';
import 'package:twitter_flutter/model/item_model.dart';
import 'package:twitter_flutter/model/user_info_model.dart';
import 'package:twitter_flutter/utils/network_helper.dart';

class PostContentCard extends StatefulWidget {
  final Items item;
  PostContentCard({this.item});

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
    uFuture = HttpHelper.getUserInfo(widget.item.username);
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
              style: TextStyle(
                letterSpacing: 0.25,
              ),
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
          imageWidget(widget.item.attachments),
          Padding(
            padding: EdgeInsets.only(right: 10.0,),
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
          letterSpacing: 0.15,
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
        style: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.08,
        ),
      ),
    );
  }
  
//  图片Widget
  Widget imageWidget(Map data) {
    if (data != null) {
      if (data['media_keys'] != null) {
        return Padding(
          padding: EdgeInsets.all(10.0),
          child: FittedBox(
            child: Row(
              children:
              [
                Image.network(
                  "http://${data['media_keys'][0]}",
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  width: 5.0,
                ),
                // Image.network(
                //   "http://${data['media_keys'][1]}",
                //   fit: BoxFit.fill,
                // ),
              ],
            ),
          ),
        );
      }
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
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13.0,
                    ),
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
      child: Text(
        isShow == false ? "翻译" : "收起",
        style: TextStyle(
          color: Colors.lightBlueAccent,
          fontSize: 12.0,
        ),
      ),
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
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

}
