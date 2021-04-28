// catcher
import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:weita_app/pages/splash_page.dart';

void main() {
  // Debug配置
  CatcherOptions debugOptions =
      CatcherOptions(SilentReportMode(), [ConsoleHandler()]);
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
