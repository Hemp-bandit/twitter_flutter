/*
 * @LastEditors: wyswill
 * @Description: 
 * @Date: 2021-04-07 17:07:45
 * @LastEditTime: 2021-05-26 09:40:17
 */
import 'package:weita_app/models/user_info_model.dart';

class ItemModel {
  List<Items> items;

  ItemModel({this.items});

  ItemModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      items = [];
      json['data']['list'].forEach((v) {
        items.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['data'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String id;
  String text;
  String text_cn;
  String created;
  String type;
  String platform;
  List media_keys;
  User userInfo;
  Map ref_tweet;
  String lang;
  List commentList;

  Items(
      {this.id,
      this.text,
      this.text_cn,
      this.created,
      this.type,
      this.platform,
      this.media_keys,
      this.userInfo,
      this.ref_tweet,
      this.lang,
      this.commentList});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    text_cn = json['text_cn'];
    created = json['created_at'];
    type = json['type'];
    platform = json['platform'];
    media_keys = json['media_keys'];
    userInfo = User.fromJson(json['userInfo']);
    ref_tweet = json['ref_tweet'];
    lang = json['lang'];
    commentList = json['commentList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    data['text_cn'] = this.text_cn;
    data['created_at'] = this.created;
    data['type'] = this.type;
    data['platform'] = this.platform;
    data['media_keys'] = this.media_keys;
    data['userInfo'] = this.userInfo.toJson();
    data['ref_tweet'] = this.ref_tweet;
    data['lang'] = this.lang;
    data['commentList'] = this.commentList;
    return data;
  }
}
