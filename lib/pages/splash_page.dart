import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weita_app/pages/main_page.dart';
import 'package:weita_app/pages/login_page.dart';
import 'package:weita_app/pages/wechat_login_page.dart';
import 'package:weita_app/utils/network_helper.dart';
import 'package:weita_app/utils/save_user_data.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    // TODO: implement initState
    // 启动的时候将屏幕设置成全屏模式
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();

    fluwx.registerWxApi(
      appId: "wx9dbedbb3bbbf0d38",
      doOnAndroid: true,
      // doOnIOS: true,
    );

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _animation = Tween(begin: 1.0, end: 1.0).animate(_controller);

    String token;

    _animation.addStatusListener((status) async {
      token = await SaveUserData.getToken();
      if (status == AnimationStatus.completed) {
        HttpHelper.userToken = token;
        HttpHelper.loginWithToken(token);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => token == null ? WeChatLoginPage() : MainPage()),
            (route) => false);
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    // 关闭的时候将屏幕设置成原来的状态
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Image.asset(
        "assets/images/splash.jpeg",
        fit: BoxFit.cover,
      ),
    );
  }
}
