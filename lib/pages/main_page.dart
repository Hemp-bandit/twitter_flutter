/*
 * @LastEditors: wyswill
 * @Description: 
 * @Date: 2021-05-10 10:52:41
 * @LastEditTime: 2021-05-26 13:43:36
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

  @override
  Future getTheToken() async {
    token = await SaveUserData.getToken();
    HttpHelper.userToken = token;
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomePage(),
    );
  }
}
