import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:weita_app/models/comment_model.dart';
import 'package:weita_app/models/item_model.dart';
import 'package:weita_app/utils/save_user_data.dart';

const String host = "http://weita.online/tapi";
String userToken;
Dio instance = Dio(BaseOptions(
    baseUrl: host, sendTimeout: 5000, headers: {'token': userToken}));

class HttpHelper {
  static Map<String, dynamic> header = {'token': userToken};
  static Future initToken(bool tokenSave, String token) async {
    if (tokenSave == true) {
      userToken = await SaveUserData.getToken();
    } else {
      userToken = token;
    }
  }

  static getToken() {
    return userToken;
  }

//  通过 code 获取 access_token
  static Future getAccessTokenByCode(String code) async {
    try {
      Response response = await instance.get(
          'https://api.weixin.qq.com/sns/oauth2/access_token?appid=wx9dbedbb3bbbf0d38&secret=7d620d4c9cfd5db8a3d93ea7becabcc2&code=$code&grant_type=authorization_code');
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
      Response response = await instance.get(
          'https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=wx9dbedbb3bbbf0d38&grant_type=refresh_token&refresh_token=$refreshToken');
    } catch (e) {
      print(e);
      return null;
    }
  }

//  根据类型分页获取数据
  static Future<ItemModel> getItemListByPage(int page) async {
    try {
      Response response = await instance.get("/queryList?size=10&page=$page");

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
      Response response = await instance.get(
        "/twitter/queryLisByType?size=10&page=$page&type=$type",
      );
      print("/queryList?size=10&page=1&type=$type");

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

  static Future<List<Items>> queryListByRandom() async {
    try {
      print(header);
      Response response = await instance.get('/twitter/queryListByRandom');
      if (response.statusCode == 200) {
        print(response.data);
        return ItemModel.fromJson(response.data).items;
      } else {
        print(response.statusCode);
        throw Exception("StatusCode: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

//  获取分类
  static Future<Map> getItemCategory() async {
    try {
      Response response = await instance.get("/twitter/queryCategory");

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
      Response response =
          await instance.get("/user/queryUserInfoByName?name=$username");

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
      Response response = await instance
          .post("/comment/sendMsg", data: {"name": name, "content": feedback});

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

//  翻译帖子
  static Future<String> translatePost(String id) async {
    try {
      Response response =
          await instance.get("/twitter/transTwitterById?id=$id");
      if (response.data['code'] == 0) {
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
      Response response = await instance.post(
        "/twitter/queryInfoById",
        data: {"id": id},
      );

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
      Response response = await instance.post("/user/registerUser",
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
      Response response = await instance
          .post("/user/login", data: {"phone": phone, "code": code});

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
      Response response = await instance.post(
        "/user/loginWithToken",
      );
      print(response.data);

      if (response.statusCode == 201) {
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

//  登出账户
  static Future logOut(String token) async {
    try {
      Response response = await instance.post(
        "/user/logOut",
      );
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
  static Future commentTwee(
      String id, String content, String userId, String commentId) async {
    try {
      Response response = await instance.post(
        "/twitter/commentTwee",
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
      Response response = await instance.get(
        "/twitter/queryCommentById?id=$id",
      );
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
      Response response = await instance.post(
        "/user/focusUser",
        data: {"weUserId": weUserId, "twitterId": twitterId},
      );
      print(response.data);
      return response.data['msg'];
    } catch (e) {
      print(e);
      return null;
    }
  }

//  查询关注列表
  static Future queryFocusList(String userId) async {
    try {
      Response response = await instance.get(
        "/user/queryFocusList?id=$userId",
      );
    } catch (e) {
      print(e);
      return null;
    }
  }

//  搜索
  static Future search(String text) async {
    try {
      Response response =
          await instance.post("/twitter/search", data: {"text": text});
      print(response.data);
    } catch (e) {
      print(e);
      return null;
    }
  }

//  上传用户头像
  static Future updateUserAvatar() async {
    try {
      Response response = await instance.post(
        "/user/updateUserAvatar",
      );
    } catch (e) {
      print(e);
      return null;
    }
  }

//  获取验证码
  static Future<Response> getVerificationCode() async {
    try {
      Response response = await instance.get("/user/getCode");
      print(response.data);
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
