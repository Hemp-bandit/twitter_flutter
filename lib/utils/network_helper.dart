import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:weita_app/models/item_model.dart';
import 'package:weita_app/models/comment_model.dart';
import 'package:weita_app/utils/save_user_data.dart';

class HttpHelper {
  static HttpHelper instance;
  static String userToken;
  static Dio _dio;
  Options _options;
  static const String host = "http://weita.online/tapi";

//  header
  static Map<String, dynamic> header = {'token': userToken};

// initHeader
  static Future initToken(bool tokenSave, String token) async {
    if (tokenSave == true) {
      userToken = await SaveUserData.getToken();
    } else {
      userToken = token;
    }
  }

//  通过 code 获取 access_token
  static Future getAccessTokenByCode(String code) async {
    try {
      Response response = await Dio().get('https://api.weixin.qq.com/sns/oauth2/access_token?appid=wx9dbedbb3bbbf0d38&secret=7d620d4c9cfd5db8a3d93ea7becabcc2&code=$code&grant_type=authorization_code');
      if (response.statusCode == 200) {
        print(response.data);
        return json.decode(response.data);
      } else {
        throw Exception("StatusCode: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
  
//  进行refresh_token
  static Future refreshToken(String refreshToken) async {
    try {
      Response response = await Dio().get('https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=wx9dbedbb3bbbf0d38&grant_type=refresh_token&refresh_token=$refreshToken');
    } catch (e) {
      print(e);
      return null;
    }
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
  static Future<List<Items>> getItemListByCategory(
      int page, String type) async {
    try {
      Response response = await Dio().get(
        "$host/twitter/queryLisByType?size=10&page=$page&type=$type",
        options: Options(headers: header),
      );
      print("$host/queryList?size=10&page=1&type=$type");

      if (response.statusCode == 200) {
        print(response.data);
        return ItemModel.fromJson(response.data).items;
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
      Response response = await Dio().get(
        "$host/twitter/queryCategory",
        options: Options(headers: header),
      );

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
      Response response = await Dio().get(
          "$host/user/queryUserInfoByName?name=$username",
          options: Options(headers: header));
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
      Response response = await Dio().post("$host/comment/sendMsg",
          options: Options(headers: header),
          data: {"name": name, "content": feedback});

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
      Response response = await Dio().post("$host/translate",
          options: Options(headers: header),
          data: {"text": text, "lang": language});

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
      Response response = await Dio().get(
          "$host/twitter/transTwitterById?id=$id",
          options: Options(headers: header));

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

//  通过id查询帖子内容
  static Future<Items> queryInfoById(String id) async {
    try {
      Response response = await Dio().post("$host/twitter/queryInfoById",
          data: {"id": id}, options: Options(headers: header));

      if (response.statusCode == 201) {
        return Items.fromJson(response.data['data']);
      } else {
        print(response.statusCode);
        throw Exception("StatusCode: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

//  用户注册
  static Future<Response> registerUser(
      String username, String phone, String code) async {
    try {
      Response response = await Dio().post("$host/user/registerUser",
          data: {"name": username, "phone": phone, "code": code});

      if (response.statusCode == 201) {
        print(response.data);
        return response;
      } else {
        print(response.statusCode);
        throw Exception("StatusCode: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

//  用户登录
  static Future login(String phone, String code) async {
    try {
      Response response = await Dio()
          .post("$host/user/login", data: {"phone": phone, "code": code});

      if (response.statusCode == 201) {
        return response.data;
      } else {
        print(response.statusCode);
        throw Exception("StatusCode: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

//  通过token登录
  static Future loginWithToken(String token) async {
    try {
      Response response = await Dio()
          .post("$host/user/loginWithToken", options: Options(headers: header));
      print(response.data);

      if (response.statusCode == 201) {
        return response.data;
      } else {
        print(response.statusCode);
        throw Exception("StatusCode: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

//  登出账户
  static Future logOut(String token) async {
    try {
      Response response = await Dio()
          .post("$host/user/logOut", options: Options(headers: header));
      print(response.data);

      if (response.statusCode == 201) {
        return response.data;
      } else {
        print(response.statusCode);
        throw Exception("StatusCode: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

//  发送评论
  static Future commentTwee(String id, String content, String userId, String commentId) async {
    try {
      Response response = await Dio().post(
        "$host/twitter/commentTwee",
        options: Options(headers: header),
        data: {
          "id": id,
          "content": content,
          "userId": userId,
          "commentId": commentId
        },
      );

      if (response.statusCode == 201) {
        return response.data;
      } else {
        print(response.statusCode);
        throw Exception("StatusCode: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

//  获取评论列表
  static Future<List<Comment>> queryCommentById(String id) async {
    try {
      Response response = await Dio().get("$host/twitter/queryCommentById?id=$id", options: Options(headers: header));
      print(response.request.path);
      if (response.statusCode == 200) {
        print("data: ${response.data['data']}");
          return CommentModel.fromJson(response.data).comments;

      } else {
        print(response.statusCode);
        throw Exception("StatusCode: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

//  关注用户
  static Future focusUser(String weUserId, String twitterId) async {
    try {
      Response response = await Dio().post("$host/user/focusUser", data: {"weUserId" : weUserId, "twitterId" : twitterId}, options: Options(headers: header));
      print(response.data);
      return response.data['msg'];
    }  catch (e) {
      print(e);
      return null;
    }
  }

//  查询关注列表
  static Future queryFocusList(String userId) async {
    try {
      Response response = await Dio().get("$host/user/queryFocusList?id=$userId", options: Options(headers: header));
    } catch (e) {
      print(e);
      return null;
    }
  }

//  搜索
  static Future search(String text) async {
    try {
      Response response = await Dio().post("$host/twitter/search", data: {"text" : text}, options: Options(headers: header));
      print(response.data);
    } catch (e) {
      print(e);
      return null;
    }
  }

//  上传用户头像
  static Future updateUserAvatar() async {
    try {
      Response response = await Dio().post("$host/user/updateUserAvatar", options: Options(headers: header));
    } catch (e) {
      print(e);
      return null;
    }
  }

//  获取验证码
  static Future<Response> getVerificationCode() async {
    try {
      Response response = await Dio().get("$host/user/getCode");
      print(response.data);
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
