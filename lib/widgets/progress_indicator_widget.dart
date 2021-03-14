import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget loadingProgressIndicator() {
  if (Platform.isIOS || Platform.isMacOS) {
    return CupertinoActivityIndicator();
  } else {
    return CircularProgressIndicator();
  }
}
