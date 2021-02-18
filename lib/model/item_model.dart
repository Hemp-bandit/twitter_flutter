class ItemModel {
  List<Items> items;

  ItemModel({this.items});

  ItemModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      items = new List<Items>();
      json['data']['list'].forEach((v) {
        items.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['data'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String id;
  String text;
  String created;
  String type;
  String twitterId;
  String username;

  Items({this.id, this.text, this.created, this.type, this.twitterId, this.username});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    created = json['created_at'];
    type = json['type'];
    twitterId = json['twitterId'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    data['created_at'] = this.created;
    data['type'] = this.type;
    data['twitterId'] = this.twitterId;
    data['username'] = this.username;
    return data;
  }
}