class UserModel {
  List<User> users;

  UserModel({this.users});

  UserModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      users = List<User>();
      users.add(User.fromJson(json));
      print(users);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.users != null) {
      data['data'] = this.users.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  // String id;
  String userId;
  String name;
  String username;
  String description;
  String description_cn;
  String profileImageUrl;
  String qiniuUrl;

  User({this.userId, this.name, this.username, this.description, this.description_cn, this.profileImageUrl, this.qiniuUrl});

  User.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    userId = json['userId'];
    name = json['name'];
    username = json['username'];
    description = json['description'];
    description_cn = json['description_cn'];
    profileImageUrl = json['profile_image_url'];
    qiniuUrl = json['qiniuUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.id;
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['username'] = this.username;
    data['description'] = this.description;
    data['description_cn'] = this.description_cn;
    data['profile_image_url'] = this.profileImageUrl;
    data['qiniuUrl'] = this.qiniuUrl;
    return data;
  }
}