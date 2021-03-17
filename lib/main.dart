import 'package:flutter/material.dart';

// catcher
import 'package:catcher/catcher.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

// controller
import 'package:weita_app/pages/login_page.dart';
import 'package:weita_app/pages/main_page.dart';
import 'package:weita_app/utils/network_helper.dart';
import 'package:weita_app/pages/splash_page.dart';

// widgets
import 'package:weita_app/widgets/login_dialog.dart';

// utils
import 'package:weita_app/utils/save_user_data.dart';

// provider
import 'package:provider/provider.dart';
import 'provide/token_model.dart';

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
      return MaterialApp(
        home: SplashPage(),
        builder: EasyLoading.init(),
      );
  }
}
