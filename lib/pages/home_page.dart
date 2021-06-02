/*
 * @LastEditors: wyswill
 * @Description: 
 * @Date: 2021-05-10 10:52:41
 * @LastEditTime: 2021-05-27 15:32:04
 */
import 'package:flutter/material.dart';
import 'package:weita_app/widgets/SearchBarDelegate.dart';
import 'package:weita_app/widgets/home/card_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Center(
          child: Text(
            "WEITA",
            style: TextStyle(
                color: Color(0xFF227CFA),
                fontSize: 17.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        title: GestureDetector(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 35.0,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "搜索",
                  style:
                      TextStyle().copyWith(fontSize: 16.0, color: Colors.grey),
                ),
              ),
            ),
          ),
          onTap: () {
            showSearch(context: context, delegate: SearchBarDelegate());
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: CardPage(),
          ),
        ],
      ),
    );
  }
}
