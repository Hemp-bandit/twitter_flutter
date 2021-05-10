import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:weita_app/utils/network_helper.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  String _codeCountdownStr = "获取验证码";
  int _countdownNum = 29;
  Timer _timer;

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Color(0xFF227CFA),
        ),
        title: Text(
          "注册",
          style: TextStyle(
            color: Color(0xFF227CFA),
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 用户名
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.person,
                  size: 20.0,
                ),
                hintText: "用户名",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                contentPadding: EdgeInsets.all(10.0),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            // 手机号
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.phone_android,
                  size: 20.0,
                ),
                hintText: "手机号",
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
              height: 40,
            ),
            // 注册
            ElevatedButton(
              onPressed: () {
                print(123);
                HttpHelper.registerUser(nameController.text,
                        phoneController.text, codeController.text)
                    .then((value) {
                  if (value.statusCode == 201) {
                    print(value.data);
                    Navigator.pop(context);
                  }
                });
              },
              child: Text(
                '注册',
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => Color(0xFF227CFA),
                ),
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
