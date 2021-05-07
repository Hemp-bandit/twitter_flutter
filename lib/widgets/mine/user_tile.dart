import 'package:flutter/material.dart';
import 'package:weita_app/pages/sub_page/setting_page.dart';

class UserTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Padding(padding: EdgeInsets.only(left: 19.0, right: 16.0),
            child: CircleAvatar(
              radius: 63.9 / 2,
              backgroundImage: NetworkImage(
                  "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2121472252,1294774723&fm=26&gp=0.jpg"),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "布鲁布鲁克",
                  style: TextStyle(
                    fontSize: 19.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  "已加入WEITA 2934天",
                  style: TextStyle(
                    color: Color(0xff787878),
                    fontSize: 12.0,
                  ),
                ),
                SizedBox(height: 10.0),
                Text("884关注"),
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage()));
              },
              icon: Icon(Icons.settings)),
        ],
      ),
    );
  }
}
