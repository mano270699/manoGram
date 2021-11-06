class PostModel {
  String? name;

  String? uId;
  String? image;
  String? dateTime;
  String? text;
  String? postImage;

  PostModel({
    this.name,
    this.uId,
    this.image,
    this.text,
    this.dateTime,
    this.postImage,
  });
  PostModel.fromjson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    text = json['text'];
    uId = json['uId'];
    dateTime = json['dateTime'];
    postImage = json['postImage'];
  }
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "uId": uId,
      "image": image,
      "postImage": postImage,
      "dateTime": dateTime,
      "text": text,
    };
  }
}
