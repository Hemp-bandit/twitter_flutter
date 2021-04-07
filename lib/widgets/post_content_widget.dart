import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:weita_app/utils/get_time_interval.dart';
import 'package:weita_app/utils/network_helper.dart';
import 'package:weita_app/models/item_model.dart';
import 'package:weita_app/models/user_info_model.dart';
import 'package:weita_app/widgets/progress_indicator_widget.dart';
import 'package:weita_app/widgets/post_handle_button_bar.dart';
import 'package:weita_app/widgets/imageShowWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostContentWidget extends StatefulWidget {
  final Items item;
  PostContentWidget(this.item);

  @override
  _PostContentWidgetState createState() => _PostContentWidgetState();
}

class _PostContentWidgetState extends State<PostContentWidget> {
  Future transFuture;
  bool isShow = false;
  bool isFocus = false;
  String userId;

  Future getTheUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getString('id');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTheUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12.0),
      child: postContent(),
    );
  }

//  帖子信息
  Widget postContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(widget.item.userInfo.qiniuUrl),
            foregroundColor: Colors.transparent,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.item.userInfo.name, //发帖用户名字
                    style: TextStyle(
                      fontFamily: 'SourceHanSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  subscribeButton(),
                  Text(
                    getTheTimeInterval(
                        DateTime.parse(widget.item.created), DateTime.now()),
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.0),
                child: Text(
                  "@${widget.item.userInfo.description}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[800]),
                ), //发帖用户身份
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 10.0),
                child: Text(
                  widget.item.text,
                  textAlign: TextAlign.left,
                ),
              ),
              // 翻译按钮
              transActionWidget(),
              // 翻译结果文本
              transTextWidget(isShow, widget.item.lang),
              // 图片显示
              imageWidget(widget.item.media_keys),
              // 帖子操作
              PostHandleButtonBar(id: widget.item.id, commentList: widget.item.commentList,),
            ],
          ),
        ),
        // Text(
        //   getTheTimeInterval(
        //       DateTime.parse(widget.item.created), DateTime.now()),
        //   style: TextStyle(
        //     color: Colors.black54,
        //   ),
        // ),
      ],
    );
  }

//  关注按钮
  Widget subscribeButton() {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
        decoration: BoxDecoration(
          color: isFocus == false ? Color(0xFF227CFA) : Colors.grey[400],
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          children: [
            Icon(
              isFocus == false ? Icons.add : Icons.check,
              color: Colors.white,
              size: 12.0,
            ),
            Text(
              isFocus == false ? "关注" : "已关注",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        if (isFocus == false) {
          HttpHelper.focusUser(userId, widget.item.userInfo.userId).then((value) {
            if (value == '关注成功') {
              setState(() {
                isFocus = !isFocus;
              });
            } else {
              EasyLoading.showToast(value, duration: Duration(seconds: 1));
            }
          });
        } else {

        }
      },
    );
  }

//  翻译按钮
  Widget transActionWidget() {
    if (widget.item.text.isEmpty) {
      return Container(
        width: 0,
        height: 0,
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            child: Text(
              isShow == false ? "查看翻译" : "取消翻译",
              style: TextStyle(
                color: Color(0xFF227CFA),
                fontSize: 14.0,
              ),
            ),
            onTap: () {
              // transFuture = HttpHelper.translatePost(widget.item.id);
              setState(() {
                transFuture = HttpHelper.translatePost(widget.item.id);
                isShow = !isShow;
              });
            },
          ),
        ),
      );
    }
  }

//  翻译结果
  Widget transTextWidget(bool show, String lang) {
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
                  margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Text(
                    widget.item.text_cn == null
                        ? snapshot.data
                        : widget.item.text_cn,
                    textAlign: TextAlign.left,
                  ),
                );
              }
          }
          return null;
        },
      );
    }
  }
}
