import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weita_app/utils/network_helper.dart';
import 'package:weita_app/utils/shared_preference_helper.dart' as SharedHelper;
import 'package:weita_app/pages/login_page.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  List items = [
    {
      "title": "消息通知",
      "icon": Icons.email,
      "action": () {
        print("message");
      }
    },
    {
      "title": "隐私",
      "icon": Icons.security,
      "action": () {
        print("message");
      }
    },
    {
      "title": "清除缓存",
      "icon": Icons.cleaning_services,
      "action": () {
        print("message");
      }
    },
    {
      "title": "意见反馈",
      "icon": Icons.local_post_office,
      "action": () {
        print("message");
      }
    },
    {
      "title": "关于我们",
      "icon": Icons.info_outline,
      "action": () {
        print("message");
      }
    },
  ];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("设置"),
        leading: BackButton(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return settingItem(items[index]);
          }, childCount: items.length)),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(15.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                    HttpHelper.logOut(HttpHelper.userToken).then((value) => EasyLoading.showToast(value['msg'], duration: Duration(seconds: 1)));
                    SharedHelper.clear();
                    return LoginPage();
                  }), (route) => false);
                },
                child: Text("退出登录"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.red),
                  minimumSize: MaterialStateProperty.resolveWith((states) => Size(MediaQuery.of(context).size.width * 3 / 5, 40)),
                  shape: MaterialStateProperty.resolveWith((states) =>
                      RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.circular(30.0))),
                  elevation: MaterialStateProperty.resolveWith((states) => 0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget settingItem(Map data) {
    return ListTile(
      title: Text(data['title']),
      leading: Icon(data['icon']),
      trailing: Icon(Icons.arrow_forward_ios),
      contentPadding: EdgeInsets.all(10.0),
      tileColor: Colors.white,
    );
  }
}
