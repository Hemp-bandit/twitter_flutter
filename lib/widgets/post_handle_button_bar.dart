import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weita_app/models/item_model.dart';
import 'package:weita_app/pages/sub_page/post_details_page.dart';
import 'package:weita_app/utils/network_helper.dart';

class PostHandleButtonBar extends StatefulWidget {
  final String id;
  final List commentList;
  final Items item;
  final bool enableComment;
  final FocusNode focusNode;
  PostHandleButtonBar(
      {this.id,
      this.commentList,
      this.item,
      this.enableComment = false,
      this.focusNode});

  @override
  _PostHandleButtonBarState createState() => _PostHandleButtonBarState();
}

class _PostHandleButtonBarState extends State<PostHandleButtonBar> {
  // String userId = '';
  // Future getTheUserId() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   userId = sharedPreferences.getString('id');
  // }
@override
void initState() { 
  super.initState();
  // getTheUserId();
}
  bool isCancel = false;
  @override
  Widget build(BuildContext context) {
    Map buttomMap = {
      // "collect": {
      //   "icon": Icons.favorite_border,
      //   "count": '${widget.item.zanLen}',
      //   "action": () async {
      //     await HttpHelper.zanPost(widget.id, userId, isCancel);
      //     setState(() {
      //       isCancel = !isCancel;
      //     });
      //   }
      // },
      "comment": {
        "icon": Icons.comment,
        "count": "",
        "action": () {
          if (widget.enableComment == false) {
            print(widget.id);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PostDetailsPage(widget.item)));
          } else {
            widget.focusNode.requestFocus();
          }
        }
      },
      "share": {
        "icon": Icons.share_outlined,
        "count": "",
        "action": () {
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
                          fluwx.shareToWeChat(fluwx.WeChatShareWebPageModel(
                            'https://apps.apple.com/cn/app/%E7%8E%8B%E8%80%85%E8%8D%A3%E8%80%80/id989673964',
                            title: '围Ta',
                            description: widget.item.text,
                            thumbnail: fluwx.WeChatImage.network(
                              widget.item.media_keys[0],
                            ),
                            scene: fluwx.WeChatScene.SESSION,
                          ));
                          // showLoginWidget(context);
                        },
                      ),
                      ListTile(
                        leading: Image.asset(
                          'assets/images/share_icon/share_pyq.png',
                          scale: 5.0,
                        ),
                        title: Text("分享到朋友圈"),
                        onTap: () {
                          fluwx.shareToWeChat(fluwx.WeChatShareWebPageModel(
                            'https://apps.apple.com/cn/app/%E7%8E%8B%E8%80%85%E8%8D%A3%E8%80%80/id989673964',
                            title: '围Ta',
                            description: widget.item.text,
                            thumbnail: fluwx.WeChatImage.network(
                                'https://is4-ssl.mzstatic.com/image/thumb/Purple114/v4/53/86/cb/5386cb18-2c26-c11d-9cd6-2e68ee96a71a/AppIcon-0-0-1x_U007emarketing-0-0-0-6-0-85-220.png/230x0w.webp 1x, https://is4-ssl.mzstatic.com/image/thumb/Purple114/v4/53/86/cb/5386cb18-2c26-c11d-9cd6-2e68ee96a71a/AppIcon-0-0-1x_U007emarketing-0-0-0-6-0-85-220.png/460x0w.webp 2x'),
                            scene: fluwx.WeChatScene.TIMELINE,
                          ));
                        },
                      ),
                    ],
                  ),
                );
              });
        }
      },
    };

    return Container(
      padding: EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: buttomMap.keys
            .map((e) => handleButton(buttomMap[e]['icon'],
                buttomMap[e]['count'], buttomMap[e]['action']))
            .toList(),
      ),
    );
  }

  Widget handleButton(IconData icon, String label, Function tapAction) {
    return GestureDetector(
      onTap: tapAction,
      child: Row(
        children: [
          Icon(icon),
          SizedBox(
            width: 10.0,
          ),
          Text(label),
        ],
      ),
    );
  }
}
