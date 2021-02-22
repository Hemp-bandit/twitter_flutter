import 'package:flutter/material.dart';
import 'package:twitter_flutter/utils/network_helper.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  TextEditingController _inputNameController = TextEditingController();
  TextEditingController _inputContentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "用户反馈",
        ),
        leading: BackButton(),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: [
            SizedBox(
              height: 60,
            ),
            TextField(
              controller: _inputNameController,
              decoration: InputDecoration(
                fillColor: Color(0xffF4F5F7),
                filled: true,
                hintText: "用户名",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _inputContentController,
              maxLines: 5,
              decoration: InputDecoration(
                filled: true,
                hintText: "有什么想说的，尽管给我留言吧",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(20.0), child: ElevatedButton(
              onPressed: () {
                HttpHelper.sendFeedback(_inputNameController.text, _inputContentController.text);
              },
              child: Text(
                "提交",
              ),
            ),),
          ],
        ),
      ),
    );
  }
}
