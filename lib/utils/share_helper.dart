//定义分享类型
import 'package:flutter/material.dart';

enum ShareType { wechat, pengyouquan, download, link }

//定义分享内容
class ShareInfo {
  //  标题
  String title;
  // 链接地址
  String url;
  // 图片
  var image;

  //  描述
  String describe;
  List<ShareType> shareTypeList;

  ShareInfo(this.title, this.url,
      {this.image, this.describe = '让我们一起观察世界，围Ta', this.shareTypeList});

  static ShareInfo fromJson(Map urlMessageMap) {
    return ShareInfo(urlMessageMap['title'], urlMessageMap['url'],
        image: urlMessageMap['image'],
        describe: urlMessageMap['describe'],
        shareTypeList: urlMessageMap['urlMessageMap']);
  }
}

//分享操作
class ShareOpt {
  final String title;
  final String image;
  final Action doAction;
  final ShareType shareType;

  const ShareOpt(
      {this.title = "",
      this.image = "",
      this.shareType = ShareType.wechat,
      this.doAction});
}
