import 'package:shared_preferences/shared_preferences.dart';

class SaveUserData {
  static String id;
  static String avatar;
  static String phone;
  static String email;
  static String name;
  static List<String> focus = [];
  static String token;

  static Future<String> getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String token = sharedPreferences.getString('token');
    return token;
  }

  static Future saveToken(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('token', token);
  }

  static Future saveUserData(Map data) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final Map userInfo = data['userInfo'];
    id = userInfo['id'];
    avatar = userInfo['avatar'];
    phone = userInfo['phone'];
    email = userInfo['email'];
    name = userInfo['name'];
    List focusList = userInfo['focus'];
    focusList.forEach((element) {
      focus.add(element.toString());
    });
    token = data['token'];
    print('login token $token ');
    await sharedPreferences.setString('id', id);
    await sharedPreferences.setString('avatar', avatar);
    await sharedPreferences.setString('phone', phone);
    await sharedPreferences.setString('email', email);
    await sharedPreferences.setString('name', name);
    await sharedPreferences.setStringList('focus', focus);
    await sharedPreferences.setString('token', token);
  }

  static Future getPreference(String key, Object defaultValue) async {
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
}

class WechatUserInfo {
  static String accessToken;
  static int expiresIn;
  static String refreshToken;
  static String openid;
  static String scope;
  static String unionId;
}
