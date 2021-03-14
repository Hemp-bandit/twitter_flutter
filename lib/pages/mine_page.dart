import 'package:flutter/material.dart';
import 'package:weita_app/widgets/mine/user_tile.dart';
import 'package:weita_app/widgets/mine/user_tab.dart';

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF1F1F1),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: 150.0,
              child: UserTile(),
            ),
          ),
          SliverToBoxAdapter(
            child: ListTile(
              title: Text("经常访问的人"),
              trailing: Icon(Icons.arrow_forward_ios),
              subtitle: Container(
                // color: Colors.grey,
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2121472252,1294774723&fm=26&gp=0.jpg"),
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2121472252,1294774723&fm=26&gp=0.jpg"),
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2121472252,1294774723&fm=26&gp=0.jpg"),
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2121472252,1294774723&fm=26&gp=0.jpg"),
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2121472252,1294774723&fm=26&gp=0.jpg"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: UserTabBar(),
          ),
        ],
      ),
    );
  }
}

