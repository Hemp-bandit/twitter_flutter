import 'package:flutter/material.dart';

// catcher
import 'package:catcher/catcher.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

// controller
import 'package:weita_app/pages/home_page.dart';
import 'package:weita_app/pages/category_page.dart';
import 'package:weita_app/pages/mine_page.dart';
import 'package:weita_app/pages/login_page.dart';
import 'package:weita_app/pages/main_page.dart';

// widgets
import 'package:weita_app/widgets/login_dialog.dart';

// utils
import 'package:weita_app/utils/save_user_data.dart';

void main() {
  // Debug配置
  CatcherOptions debugOptions =
      CatcherOptions(SilentReportMode(), [ConsoleHandler()]);

  // Release配置
  // CatcherOptions releaseOptions = CatcherOptions(SilentReportMode(), [
  //   EmailManualHandler(["1208879283@qq.com"],
  //       emailTitle: "围Ta异常上报", printLogs: true),
  // ]);

  //Profile配置
  CatcherOptions profileOptions = CatcherOptions(
      SilentReportMode(), [ConsoleHandler(), ToastHandler()],
      handlerTimeout: 10000);

  Catcher(
    runAppFunction: () {
      runApp(MyApp());
    },
    debugConfig: debugOptions,
    // releaseConfig: releaseOptions,
    profileConfig: profileOptions,
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String token;
    Widget _defaultPage = LoginPage();
    Future checkIsLogin() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('token');
      print("token: $token");
      if (token != null || token != "") {
        _defaultPage = MainPage();
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    }
    checkIsLogin();
    return MaterialApp(
      home: _defaultPage,
      builder: EasyLoading.init(),
    );
  }
}