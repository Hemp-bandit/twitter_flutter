/*
 * @LastEditors: wyswill
 * @Description: 
 * @Date: 2021-05-10 10:52:41
 * @LastEditTime: 2021-05-10 11:08:00
 */

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:weita_app/pages/main_page.dart';
import 'package:weita_app/utils/network_helper.dart';
import 'package:weita_app/utils/save_user_data.dart';

class WeChatLoginPage extends StatefulWidget {
  @override
  _WeChatLoginPageState createState() => _WeChatLoginPageState();
}

class _WeChatLoginPageState extends State<WeChatLoginPage> {
  void _installFluwx() async {
    bool installed = await fluwx.isWeChatInstalled;
    if (installed) {
      _wechatAuth();
    } else {
      EasyLoading.showToast('微信未安装');
    }
  }

  void _wechatAuth() {
    // 微信登录授权
    fluwx
        .sendWeChatAuth(scope: 'snsapi_userinfo', state: 'wechat_sdk_demo_test')
        .then((value) {
      print(value);
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    super.initState();
    // 监听微信授权返回结果
    fluwx.weChatResponseEventHandler.distinct((a, b) => a == b).listen((res) {
      if (res is fluwx.WeChatAuthResponse) {
        // 返回的res.code就是授权code
        HttpHelper.getAccessTokenByCode(res.code).then((value) {
          SaveUserData.token = value['access_token'];
          SaveUserData.saveToken(SaveUserData.token);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainPage()));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/icon.png',
            scale: 5.0,
          ),
          // 登录
          ElevatedButton.icon(
            onPressed: () {
              _installFluwx();
            },
            icon: Image.asset(
              'assets/images/share_icon/share_wechat.png',
              scale: 5.0,
            ),
            label: Text('微信登录'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => Color(0xFF227CFA)),
              minimumSize: MaterialStateProperty.resolveWith((states) =>
                  Size(MediaQuery.of(context).size.width * 3 / 5, 40)),
              shape: MaterialStateProperty.resolveWith((states) =>
                  RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(30.0))),
              elevation: MaterialStateProperty.resolveWith((states) => 0),
            ),
          ),
        ],
      ),
    );
  }
}
