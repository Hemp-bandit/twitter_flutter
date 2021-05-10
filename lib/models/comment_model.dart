class CommentModel {
  List<Comment> comments;

  CommentModel({this.comments});

  CommentModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      comments = <Comment>[];
      json['data'].forEach((v) {
        comments.add(Comment.fromJson(v));
      });
      print(comments);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.comments != null) {
      data['data'] = this.comments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Comment {
  // String id;
  Map userInfo;
  Map reUserInfo;
  String id;
  String weUserId;
  String retUserId;
  String retTweeId;
  String retCommId;
  String content;
  int zanNum;
  String createTime;

  Comment({this.userInfo, this.id, this.weUserId, this.retUserId, this.retTweeId, this.retCommId, this.content, this.zanNum, this.createTime, this.reUserInfo});

  Comment.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    userInfo = json['userInfo'];
    id = json['id'];
    weUserId = json['weUserId'];
    retUserId = json['retUserId'];
    retTweeId = json['retTweeId'];
    retCommId = json['retCommId'];
    content = json['content'];
    zanNum = json['zanNum'];
    createTime = json['createTime'];
    reUserInfo = json['reUserInfo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.id;
    data['userInfo'] = this.userInfo;
    data['id'] = this.id;
    data['weUserId'] = this.weUserId;
    data['retUserId'] = this.retUserId;
    data['retTweeId'] = this.retTweeId;
    data['retCommId'] = this.retCommId;
    data['content'] = this.content;
    data['zanNum'] = this.zanNum;
    data['createTime'] = this.createTime;
    data['reUserInfo'] = this.reUserInfo;
    return data;
  }
}