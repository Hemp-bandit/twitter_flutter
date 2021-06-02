/*
 * @LastEditors: wyswill
 * @Description: 
 * @Date: 2021-05-10 10:52:41
 * @LastEditTime: 2021-05-26 16:01:27
 */

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:weita_app/utils/network_helper.dart';
import 'package:weita_app/widgets/post_content_widget.dart';

class CardPage extends StatefulWidget {
  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  int fromIndex = 0;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: HttpHelper.queryListByRandom(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(
              child: Container(),
            );
          case ConnectionState.done:
            return contentPageView(snapshot.data);
        }
        return null;
      },
    );
  }

  Widget contentPageView(List dataSource) {
    return Swiper(
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          margin: EdgeInsets.all(15.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: PostContentWidget(dataSource[index]),
        );
      },
      itemCount: dataSource.length,
      loop: true,
      layout: SwiperLayout.TINDER,
      itemWidth: MediaQuery.of(context).size.width,
      itemHeight: MediaQuery.of(context).size.height,
      onIndexChanged: (index) async {
        if (index == 4 && fromIndex == 3) {
          List data = await HttpHelper.queryListByRandom();
          dataSource = data;
          setState(() {});
        }
        fromIndex = index;
      },
    );
  }
}
