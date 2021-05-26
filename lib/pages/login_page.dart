import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:weita_app/pages/main_page.dart';
import 'package:weita_app/pages/register_page.dart';
import 'package:weita_app/utils/network_helper.dart';
import 'package:weita_app/utils/save_user_data.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  String _codeCountdownStr = "获取验证码";
  int _countdownNum = 29;
  Timer _timer;

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
    codeController.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 手机号
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                hintText: "手机号",
                prefixIcon: Icon(
                  Icons.phone_android,
                  size: 20.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                contentPadding: EdgeInsets.all(10.0),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            // 密码
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: codeController,
                      decoration: InputDecoration(
                        hintText: "验证码",
                        prefixIcon: Icon(
                          Icons.vpn_key,
                          size: 20.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        contentPadding: EdgeInsets.all(10.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: verificationCodeWidget(),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                flex: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: Text(
                        "忘记密码",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                      onTap: () {
                        print('忘记密码');
                      },
                    ),
                    GestureDetector(
                      child: Text(
                        "注册",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                      onTap: () {
                        print('注册');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()));
                      },
                    ),
                  ],
                )),
            SizedBox(
              height: 20,
            ),
            // 登录
            ElevatedButton(
              onPressed: () {
                if (phoneController.text.isEmpty ||
                    codeController.text.isEmpty) {
                  EasyLoading.showToast('手机号或验证码不能为空',
                      duration: Duration(seconds: 1));
                } else {
                  HttpHelper.login(phoneController.text, codeController.text)
                      .then((value) {
                    print('value $value');
                    if (value['msg'] == '') {
                      new Future.delayed(Duration(seconds: 2), () {
                        SaveUserData.saveUserData(value['data']);
                        HttpHelper.initToken(false, value['data']['token']);
                        HttpHelper.userToken = value['data']['token'];
                        print("userToken = ${HttpHelper.userToken}");
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => MainPage()),
                            (route) => false);
                      });
                    } else {
                      EasyLoading.showToast(value['msg'],
                          duration: Duration(seconds: 1));
                    }
                  });
                }
              },
              child: Text(
                '登录',
              ),
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
      ),
    );
  }

  Widget verificationCodeWidget() {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Color(0xFF227CFA),
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        child: Text(
          _codeCountdownStr,
          style: TextStyle(color: Colors.white),
        ),
      ),
      onTap: _timer == null
          ? () {
              print(SaveUserData.getToken());
              HttpHelper.getVerificationCode()
                  .then((value) => codeController.text = value.data);
              EasyLoading.showToast(
                '验证码已自动填写',
                duration: Duration(seconds: 1),
              );
              _timer = Timer.periodic(Duration(seconds: 1), (timer) {
                setState(() {
                  if (_countdownNum > 0) {
                    _codeCountdownStr = "重发验证码${_countdownNum--}s";
                  } else {
                    _codeCountdownStr = "获取验证码";
                    _countdownNum = 29;
                    _timer.cancel();
                    _timer = null;
                  }
                });
              });
            }
          : null,
    );
  }
}
