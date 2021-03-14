import 'package:flutter/material.dart';
import 'package:weita_app/models/item_model.dart';
import 'package:weita_app/pages/sub_page/post_details_page.dart';
import 'package:weita_app/utils/network_helper.dart';

class PostHandleButtonBar extends StatefulWidget {
  final String id;
  final bool enableComment;
  final FocusNode focusNode;
  PostHandleButtonBar({this.id, this.enableComment = false, this.focusNode});

  @override
  _PostHandleButtonBarState createState() => _PostHandleButtonBarState();
}

class _PostHandleButtonBarState extends State<PostHandleButtonBar> {
  Items item;
  Future queryPostInfoById() async {
    item = await HttpHelper.queryInfoById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    Map buttomMap = {
      "like" : {"icon" : Icons.favorite_border, "count" : "123", "action" : () {
        print('favorite');
      }},
      "comment" : {"icon" : Icons.comment, "count" : "123", "action" : () {
        print('comment');
        // showLoginWidget(context);
        if (widget.enableComment == false) {
          print(widget.id);
          queryPostInfoById().whenComplete(() => Navigator.push(context, MaterialPageRoute(builder: (context) => PostDetailsPage(item))));
        } else {
          widget.focusNode.requestFocus();
        }

      }},
      "share" : {"icon" : Icons.share_outlined, "count" : "123", "action" : () {
        print('favorite');
      }},
    };

    return Container(
      padding: EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: buttomMap.keys.map((e) => handleButton(buttomMap[e]['icon'], buttomMap[e]['count'], buttomMap[e]['action'])).toList(),
      ),
    );
  }

  Widget handleButton(IconData icon, String label, Function tapAction) {
    return GestureDetector(
      onTap: tapAction,
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 10.0,),
          Text(label),
        ],
      ),
    );
  }
}

