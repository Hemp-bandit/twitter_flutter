import 'package:flutter/material.dart';
import 'package:twitter_flutter/controller/feedback_controller.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(
          "设置",
        ),
      ),
      body: ListView(
        // 此处暂时只有一个反馈功能，因此只有一个ListTile
        children: [
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text(
              "用户反馈",
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackPage()),);
            },
          ),
        ],
      ),
    );
  }
}

