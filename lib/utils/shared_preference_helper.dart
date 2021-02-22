import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//存数据
Object savePreference(BuildContext context, String key, Object value) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  if (value is int) {
    await preferences.setInt(key, value);
  } else if (value is double) {
    await preferences.setDouble(key, value);
  } else if (value is bool) {
    await preferences.setBool(key, value);
  } else if (value is String) {
    await preferences.setString(key, value);
  } else if (value is List) {
    await preferences.setStringList(key, value);
  } else {
    throw Exception("无法获取该类型");
  }
}

//取数据
Future getPreference(Object context, String key, Object defaultValue) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  if (defaultValue is int) {
    return preferences.getInt(key);
  } else if (defaultValue is double) {
    return preferences.getDouble(key);
  } else if (defaultValue is bool) {
    return preferences.getBool(key);
  } else if (defaultValue is String) {
    return preferences.getString(key);
  } else if (defaultValue is List) {
    return preferences.getStringList(key);
  } else {
    throw Exception("无法获取该类型");
  }
}

//删除指定数据
void remove(String key) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.remove(key);
}

//清空整个缓存
void clear() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.clear();
}
