class ItemModel {
  List<Items> items;

  ItemModel({this.items});

  ItemModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      items = List<Items>();
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
  Map referenced_tweets;
  Map attachments;
  String twitterId;
  String username;
  String lang;

  Items({this.id, this.text, this.created, this.type, this.referenced_tweets, this.attachments, this.twitterId, this.username, this.lang});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    created = json['created_at'];
    type = json['type'];
    referenced_tweets = json['referenced_tweets'];
    attachments = json['attachments'];
    twitterId = json['twitterId'];
    username = json['username'];
    lang = json['lang'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    data['created_at'] = this.created;
    data['type'] = this.type;
    data['referenced_tweets'] = this.referenced_tweets;
    data['attachments'] = this.attachments;
    data['twitterId'] = this.twitterId;
    data['username'] = this.username;
    data['lang'] = this.lang;
    return data;
  }
}