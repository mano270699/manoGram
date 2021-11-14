class SocialMessageModel {
  String? text;
  String? reciverId;
  String? senderId;
  String? dateTime;

  SocialMessageModel({
    this.reciverId,
    this.text,
    this.senderId,
    this.dateTime,
  });
  SocialMessageModel.fromjson(Map<String, dynamic> json) {
    text = json['text'];
    reciverId = json['reciverId'];
    senderId = json['senderId'];
    dateTime = json['dateTime'];
  }
  Map<String, dynamic> toMap() {
    return {
      "text": text,
      "reciverId": reciverId,
      "senderId": senderId,
      "dateTime": dateTime,
    };
  }
}
