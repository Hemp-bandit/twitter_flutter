import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weita_app/models/comment_model.dart';
import 'package:weita_app/models/item_model.dart';
import 'package:weita_app/pages/sub_page/user_comment_widget.dart';
import 'package:weita_app/utils/get_time_interval.dart';
import 'package:weita_app/utils/network_helper.dart';
import 'package:weita_app/widgets/imageShowWidget.dart';
import 'package:weita_app/widgets/post_handle_button_bar.dart';
import 'package:weita_app/widgets/progress_indicator_widget.dart';

class PostDetailsPage extends StatefulWidget {
  final Items item;
  PostDetailsPage(this.item);

  @override
  _PostDetailsPageState createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  Future transFuture;
  bool isShow = false;
  TextEditingController _commentController = TextEditingController();
  FocusNode userFocusNode = FocusNode();
  String hintText = "发表评论";
  String id; //帖子id
  String content; //回复内容
  String userId; //用户id
  String commentId = ""; //被回复用户id

  Future getTheUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getString('id');
  }

  List<Comment> comments = [];
  @override
  void initState() {
    HttpHelper.queryCommentById(widget.item.id).then((value) {
      setState(() {
        comments = value;
      });
    });
    id = widget.item.id;
    getTheUserId();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "详情",
          style: TextStyle(color: Colors.black),
        ),
        leading: BackButton(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: contentWidget(comments),
      bottomSheet: commentHandleBar(),
    );
  }

  Widget contentWidget(List<Comment> comments) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: postDetails(),
          ),
          comments.isEmpty
              ? SliverToBoxAdapter(child: emptyCommentWidget())
              : commentList(comments),
          SliverToBoxAdapter(
            child: SizedBox(height: 80),
          )
        ],
      ),
    );
  }

//  评论列表
  Widget commentList(List<Comment> comments) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return InkWell(
            child: userCommentWidget(comments[index]),
            onTap: () {
              // print(comments[index].id);
              commentId = comments[index].id; //commentId
              setState(() {
                hintText = "回复${comments[index].userInfo['name']}";
                userFocusNode.requestFocus();
              });
            },
          );
        },
        childCount: comments.length,
      ),
    );
  }

  Widget emptyCommentWidget() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Center(
        child: Text(
          "暂无评论",
        ),
      ),
    );
  }

  Widget commentHandleBar() {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              focusNode: userFocusNode,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 20,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                hintText: hintText,
                fillColor: Color(0xFFEEEEEE),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          TextButton(
            child: Text(
              "发表",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              // print(
              //     "id: $id\ncontent: ${_commentController.text}\nuserId: $userId\ncommentId: $commentId");
              if (_commentController.text.trim().isEmpty) {
                EasyLoading.showToast('回复内容不能为空',
                    duration: Duration(seconds: 1));
                _commentController.clear();
              } else {
                HttpHelper.commentTwee(
                        id, _commentController.text, userId, commentId)
                    .then((value) => EasyLoading.showToast(value['msg'],
                        duration: Duration(seconds: 1)));
                _commentController.clear();
                userFocusNode.unfocus();
                id = widget.item.id; //将id恢复成twitter帖子id
                Future.delayed(Duration(milliseconds: 200), () {
                  HttpHelper.queryCommentById(widget.item.id).then((value) {
                    setState(() {
                      comments = value;
                    });
                  });
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget postDetails() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                    Text(
                      widget.item.userInfo.name, //发帖用户名字
                      style: TextStyle(
                        fontFamily: 'SourceHanSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
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
                  ],
                ),
              ),
            ],
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
          // // 图片显示
          // imageWidget(widget.item.media_keys),
          //发帖时间
          Text(
            getTheDateTime(widget.item.created),
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
          Divider(
            height: 1.0,
          ),
        ],
      ),
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
