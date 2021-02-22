import 'package:dio/dio.dart';
import 'package:twitter_flutter/model/item_model.dart';
import 'package:twitter_flutter/model/user_info_model.dart';

List<Items> saveData;

class HttpHelper {
  static HttpHelper instance;
  static String token;
  static Dio _dio;
  Options _options;
  static const String host = "http://tt.gupiao66.com/tapi";

  static HttpHelper getInstance() {
    if (instance == null) {
      instance = HttpHelper();
    }
    return instance;
  }

//  根据类型分页获取数据
  static Future<ItemModel> getItemListByPage(int page) async {
    try {
      Response response = await Dio().get("$host/queryList?size=10&page=$page");

      if (response.statusCode == 200) {
        return ItemModel.fromJson(response.data);
      } else {
        throw Exception("StatusCode: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

// 根据类型分页获取帖子列表
  static Future<List<Items>> getItemListByCategory(int page, String type) async {
    try {
      Response response = await Dio().get("$host/twitter/queryListByType?size=10&page=$page&type=$type");
      // print("$host/queryList?size=10&page=1&type=$type");

      if (response.statusCode == 200) {
        if (page > 1) {
          saveData.addAll(ItemModel.fromJson(response.data).items);
          return saveData;
        } else {
          if (saveData == null) {
            saveData = ItemModel.fromJson(response.data).items;
          }
          print(saveData);
          return ItemModel.fromJson(response.data).items;
        }
      } else {
        print(response.statusCode);
        throw Exception("StatusCode: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

//  获取分类
  static Future<Map> getItemCategory() async {
    try {
      Response response = await Dio().get("$host/twitter/queryCategory");

      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception("StatusCode: ${response.statusCode}");
      }
    } catch (e) {
      print("error");
      return null;
    }
  }

  // 通过用户名获取用户信息
  static Future<Map> getUserInfo(String username) async {
    try {
      Response response = await Dio().get("$host/user/queryUserInfoByName?name=$username");
      // print("$host/user/queryUserInfoByName?name=$username");

      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception("StatusCode: ${response.statusCode}");
      }
    } catch (e) {
      print("error");
      print(e);
      return null;
    }
  }
  
//  提交反馈内容
  static sendFeedback(String name, String feedback) async {
    try {
      Response response = await Dio().post("$host/comment/sendMsg", data: {"name" : name, "content" : feedback});

      if (response.statusCode == 201) {
        return response.statusCode;
      } else {
        throw Exception("StatusCode: ${response.statusCode}");
      }
    } catch (e) {
      print("error");
      return null;
    }
  }

//  翻译
  static Future<String> translate(String text, String language) async {
    try {
      Response response = await Dio().post("$host/translate", data: {"text" : text, "lang" : language});

      if (response.statusCode == 201) {
        return response.data['data'];
      } else {
        throw Exception("StatusCode: ${response.statusCode}");
      }
    } catch (e) {
      print("error");
      return null;
    }
  }

//  翻译帖子
  static Future<String> translatePost(String id) async {
    try {
      Response response = await Dio().get("$host/twitter/transTwitter?id=$id");

      if (response.statusCode == 200) {
        // 此处response.data返回的值为Map
        return response.data['data']['text_cn'];
      } else {
        throw Exception("StatusCode: ${response.statusCode}");
      }
    } catch (e) {
      print("error");
      print(e);
      return null;
    }
  }

}
