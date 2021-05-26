/*
 * @LastEditors: wyswill
 * @Description: 
 * @Date: 2021-05-10 10:52:41
 * @LastEditTime: 2021-05-26 14:23:56
 */
import 'package:flutter/material.dart';
import 'package:weita_app/pages/home_page.dart';
import 'package:weita_app/utils/network_helper.dart';
import 'package:weita_app/utils/save_user_data.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String token;
  Future getTheToken() async {
    token = await SaveUserData.getToken();
    HttpHelper.initToken(false, token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomePage(),
    );
  }
}
