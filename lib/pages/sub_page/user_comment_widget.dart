import 'package:flutter/material.dart';
import 'package:weita_app/utils/get_time_interval.dart';
import 'package:weita_app/models/comment_model.dart';

Widget userCommentWidget(Comment comment) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(padding: EdgeInsets.all(10.0), child: CircleAvatar(
        backgroundImage: NetworkImage(comment.userInfo['avatar'] == null ? "http://ss1.gupiao66.com/default.jpeg" : comment.userInfo['avatar']),
      ),),
      Expanded(child: Column(
        children: [
          SizedBox(height: 10.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              userInfoName(comment),
              Text(
                getTheDateTime(comment.createTime),
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            child: Text(
              comment.content,
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: 10.0,),
          Divider(height: 1.0,),
        ],
      ),),
    ],
  );
}

Widget userInfoName(Comment comment) {
  if (comment.retCommId.isEmpty) {
    return Text(
      comment.userInfo['name'], //评论用户名字
      style: TextStyle(
        fontFamily: 'SourceHanSans',
        fontWeight: FontWeight.bold,
        fontSize: 17.0,
      ),
    );
  } else {
    return RichText(
      text: TextSpan(
          text: comment.userInfo['name'], //评论用户名字
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'SourceHanSans',
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
          children: [
            TextSpan(text: "@", style: TextStyle(
              color: Colors.black54,
              fontFamily: 'SourceHanSans',
              fontSize: 15.0,
            ),),
            TextSpan(text: comment.reUserInfo['name'], style: TextStyle(
              color: Colors.black54,
              fontFamily: 'SourceHanSans',
              fontSize: 14.0,
            ),),
          ]
      ),
    );
  }
}
