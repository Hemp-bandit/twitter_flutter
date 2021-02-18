import 'package:flutter/material.dart';
import 'package:twitter_flutter/model/item_model.dart';

class PostContentCard extends StatefulWidget {
  final Items item;
  PostContentCard({this.item});

  @override
  _PostContentCardState createState() => _PostContentCardState();
}

class _PostContentCardState extends State<PostContentCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          accountInfoWidget(),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              widget.item.text,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: imageWidget(),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "testtesettesttesttesttesettesttesttesttesettesttesttesttesettesttesttesttesettesttesttesttesettesttest",
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: footerWidget(),
          ),
        ],
      ),
    );
  }

//  账号信息Widget
  Widget accountInfoWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: CircleAvatar(
                child: Icon(Icons.image),
              ),
            ),
            Text(
              widget.item.username,
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 10.0,
            right: 10.0,
          ),
          child: Text(
            "for twitter",
          ),
        ),
      ],
    );
  }

//  图片Widget
  Widget imageWidget() {
    return FittedBox(
      child: Row(
        children: [
          Image.network(
            "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fsoftbbs%2F1003%2F07%2Fc0%2F3134443_1267900790753_1024x1024soft.jpg&refer=http%3A%2F%2Fimg.pconline.com.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1615449569&t=6aa4b5a5ebfbb070778e37a46c8e075d",
            fit: BoxFit.fill,
          ),
          SizedBox(
            width: 5.0,
          ),
          Image.network(
            "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fsoftbbs%2F1003%2F07%2Fc0%2F3134443_1267900790753_1024x1024soft.jpg&refer=http%3A%2F%2Fimg.pconline.com.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1615449569&t=6aa4b5a5ebfbb070778e37a46c8e075d",
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }

  Widget footerWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.item.created,
        ),
        Text("翻译来自百度"),
      ],
    );
  }

}
