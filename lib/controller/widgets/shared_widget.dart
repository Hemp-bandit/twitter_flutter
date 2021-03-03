import 'package:flutter/material.dart';
import 'package:share/share.dart';

Widget sharedButton() {
  return InkWell(
    child: Icon(Icons.ios_share, size: 18.0,),
    onTap: () {
      print("Shared");
      Share.share('【王者荣耀】\n https://apps.apple.com/cn/app/%E7%8E%8B%E8%80%85%E8%8D%A3%E8%80%80/id989673964');
    },
  );
}
