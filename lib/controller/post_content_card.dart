import 'package:flutter/material.dart';
import 'package:twitter_flutter/controller/gallery_photo_view_wrapper.dart';
import 'package:twitter_flutter/controller/widgets/referenced_tweet.dart';
import 'package:twitter_flutter/model/item_model.dart';
import 'package:twitter_flutter/model/user_info_model.dart';
import 'package:twitter_flutter/utils/network_helper.dart';
import 'package:twitter_flutter/controller/widgets/progress_indicator_widget.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:twitter_flutter/controller/widgets/shared_widget.dart';

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
    return Card(
      child: Column(
        children: [
          // 账户信息
          accountInfoWidget(),
          // 帖子信息
          contentText(widget.item.text),
          // 被回复信息
          ReferencedWidget(dataSource: widget.item.referenced_tweets),
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: InkWell(
          //     child: Text("查看更多"),
          //     onTap: () {
          //       print(123);
          //     },
          //   ),
          // ),
          // 图片内容
          imageWidget(widget.item.attachments),
          // 翻译按钮
          Padding(
            padding: EdgeInsets.only(
              right: 10.0,
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: transActionWidget(),
            ),
          ),
          // 翻译内容
          translateWidget(isShow, widget.item.lang),
          // 底部内容
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
            return Center(
              child: loadingProgressIndicator(),
            );
          case ConnectionState.done:
            if (snapshot.data == null) {
              //当获取的data数据为空，也就是无法查询到用户信息时，显示此控件
              return ListTile(
                leading: CircleAvatar(
                  child: Text("测试"),
                ),
                title: Text(
                  "路人甲",
                  style: TextStyle(
                    fontSize: 18.0,
                    letterSpacing: 0.15,
                  ),
                ),
                subtitle: Text(
                  "测试用户",
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
            } else {
              return accountInfoListTile(snapshot.data);
            }
        }
        return null;
      },
    );
  }

//  用户帖子内容
  Widget contentText(String text) {
    List contentList = text.split(' ');
    if (contentList.first == "RT") {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.all(10.0),
        child: RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            text: "Return: ",
            style: TextStyle(color: Colors.blue),
            children: [
              TextSpan(
                text: text.replaceAll("RT ", ""),
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.all(10.0),
        child: Text(
          text,
          textAlign: TextAlign.start,
          style: TextStyle(
            letterSpacing: 0.25,
          ),
        ),
      );
    }
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
          fontSize: 18.0,
          letterSpacing: 0.15,
        ),
      ),
      subtitle: Text(
        data['description'],
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
        List list = List();
        for (int x = 0; x < data['media_keys'].length; x++) {
          GalleryExampleItem item = GalleryExampleItem();
          item.id = data['media_keys'][x];
          item.resource = "http://${data['media_keys'][x]}";
          list.add(item);
        }
        // print("http://${list[0].resource}");
        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: list.length,
          padding: EdgeInsets.all(10.0),
          itemBuilder: (context, index) {
            return AspectRatio(
              aspectRatio: list.length < 2 ? 16 / 9 : 1,
              child: GalleryExampleItemThumbnail(
                galleryExampleItem: list[index],
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GalleryPhotoViewWrapper(
                            galleryItems: list,
                            backgroundDecoration:
                                const BoxDecoration(color: Colors.black),
                            initialIndex: index,
                          )));
                },
              ),
            );
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: list.length == 1 ? 2 : 3,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
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

//  显示翻译结果
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
              return Center(
                child: loadingProgressIndicator(),
              );
            case ConnectionState.done:
              if (snapshot.data == null) {
                return Text("暂无数据");
              } else {
                // print("data: ${snapshot.data}");
                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(10.0),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text(
                    snapshot.data,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 13.0,
                    ),
                  ),
                );
              }
          }
          return null;
        },
      );
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
    DateTime date = DateTime.parse(widget.item.created); //获取发帖时间
    DateTime now = DateTime.now();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          getTheTimeInterval(date, now),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        InkWell(
          child: Icon(
            Icons.ios_share,
            size: 20.0,
          ),
          onTap: () {
            showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                ),
                builder: (context) {
                  return Container(
                    height: MediaQuery.of(context).size.height / 3,
                    child: ListView(
                      children: [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              "分享方式",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Image.asset(
                            'assets/images/share_icon/share_wechat.png',
                            scale: 5.0,
                          ),
                          title: Text("分享到微信"),
                          onTap: () {
                            fluwx
                                .shareToWeChat(fluwx.WeChatShareWebPageModel(
                                  'https://apps.apple.com/cn/app/%E7%8E%8B%E8%80%85%E8%8D%A3%E8%80%80/id989673964',
                                  title: '围Ta',
                                  description: widget.item.text,
                                  thumbnail: fluwx.WeChatImage.network(
                                      'https://is4-ssl.mzstatic.com/image/thumb/Purple114/v4/53/86/cb/5386cb18-2c26-c11d-9cd6-2e68ee96a71a/AppIcon-0-0-1x_U007emarketing-0-0-0-6-0-85-220.png/230x0w.webp 1x, https://is4-ssl.mzstatic.com/image/thumb/Purple114/v4/53/86/cb/5386cb18-2c26-c11d-9cd6-2e68ee96a71a/AppIcon-0-0-1x_U007emarketing-0-0-0-6-0-85-220.png/460x0w.webp 2x'),
                                  scene: fluwx.WeChatScene.SESSION,
                                ))
                                .then((value) => print(value));
                          },
                        ),
                        ListTile(
                          leading: Image.asset(
                            'assets/images/share_icon/share_pyq.png',
                            scale: 5.0,
                          ),
                          title: Text("分享到朋友圈"),
                          onTap: () {
                            fluwx
                                .shareToWeChat(fluwx.WeChatShareWebPageModel(
                                  'https://apps.apple.com/cn/app/%E7%8E%8B%E8%80%85%E8%8D%A3%E8%80%80/id989673964',
                                  title: '围Ta',
                                  description: widget.item.text,
                                  thumbnail: fluwx.WeChatImage.network(
                                      'https://is4-ssl.mzstatic.com/image/thumb/Purple114/v4/53/86/cb/5386cb18-2c26-c11d-9cd6-2e68ee96a71a/AppIcon-0-0-1x_U007emarketing-0-0-0-6-0-85-220.png/230x0w.webp 1x, https://is4-ssl.mzstatic.com/image/thumb/Purple114/v4/53/86/cb/5386cb18-2c26-c11d-9cd6-2e68ee96a71a/AppIcon-0-0-1x_U007emarketing-0-0-0-6-0-85-220.png/460x0w.webp 2x'),
                                  scene: fluwx.WeChatScene.TIMELINE,
                                ))
                                .then((value) => print(value));
                          },
                        ),
                      ],
                    ),
                  );
                });
          },
        ),
      ],
    );
  }

//  判断相隔时间
  String getTheTimeInterval(DateTime startTime, DateTime endTime) {
    Duration intervalTime = endTime.difference(startTime);
    if (intervalTime.inSeconds < 60) {
      return "${intervalTime.inSeconds}秒钟前";
    } else if (intervalTime.inMinutes < 60) {
      return "${intervalTime.inMinutes}分钟前";
    } else if (intervalTime.inHours < 60) {
      return "${intervalTime.inHours}小时前";
    } else if (intervalTime.inDays < 30) {
      return "${intervalTime.inDays}天前";
    } else {
      return "${intervalTime.inDays / 30}个月前";
    }
  }
}
