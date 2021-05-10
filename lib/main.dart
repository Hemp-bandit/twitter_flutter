/*
 * @LastEditors: wyswill
 * @Description: 
 * @Date: 2021-05-10 10:52:41
 * @LastEditTime: 2021-05-10 10:55:16
 */
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:weita_app/pages/splash_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashPage(),
      builder: EasyLoading.init(),
    );
  }
}
