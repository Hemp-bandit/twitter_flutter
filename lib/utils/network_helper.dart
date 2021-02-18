import 'package:dio/dio.dart';
import 'package:twitter_flutter/model/item_model.dart';

class HttpHelper {
  static HttpHelper instance;
  static String token;
  static Dio _dio;
  Options _options;
  static const String host = "http://tt.gupiao66.com/tapi";

  static HttpHelper getInstance() {
    print("getInstance");
    if (instance == null) {
      instance = HttpHelper();
    }
    return instance;
  }

  static Future<ItemModel> getItemListByPage() async {
    try {
      Response response = await Dio().get("$host/queryList?size=10&page=2");

      if (response.statusCode == 200) {
        print(response.data['data']);
        return ItemModel.fromJson(response.data);
      } else {
        throw Exception("StatusCode: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map> getItemCategory() async {
    try {
      Response response = await Dio().get("$host/twitter/queryCategory");

      if (response.statusCode == 200) {
        print(response.data['data']);
        return response.data['data'];
      } else {
        throw Exception("StatusCode: ${response.statusCode}");
      }
    } catch (e) {
      print("error");
      return null;
    }
  }
  
}
