import 'package:flutter/material.dart';

class ReferencedWidget extends StatelessWidget {
  final Map dataSource;
  ReferencedWidget({this.dataSource});
  @override
  Widget build(BuildContext context) {
    if (dataSource == null) {
      return Container(
        height: 0,
        width: 0,
      );
    } else {
      return Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          // borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: "${dataSource['username']}:",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                    children: [
                      TextSpan(
                        text: dataSource['text'],
                        style: TextStyle(
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
