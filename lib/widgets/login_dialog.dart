/*
 * @LastEditors: wyswill
 * @Description: 
 * @Date: 2021-05-10 10:52:41
 * @LastEditTime: 2021-05-17 10:26:28
 */
import 'package:flutter/material.dart';
import 'package:weita_app/pages/login_page.dart';
import 'package:weita_app/utils/save_user_data.dart';

void showLoginWidget(BuildContext context) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      builder: (context) {
        return Container(
          child: Stack(
            children: [
              LoginPage(),
              Positioned(
                top: 40.0,
                left: 15.0,
                child: InkWell(
                  child: Icon(
                    Icons.close,
                    size: 30.0,
                  ),
                  onTap: () {
                    SaveUserData.getToken();
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      });
}
