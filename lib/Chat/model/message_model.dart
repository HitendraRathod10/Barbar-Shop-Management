class MessageModel {
  String? messageid;
  String? sender;
  String? text;
  bool? seen;
  String? timeStamp;

  MessageModel({this.messageid, this.sender, this.text, this.seen, this.timeStamp});

  MessageModel.fromMap(Map<String, dynamic> map) {
    messageid = map["messageid"];
    sender = map["sender"];
    text = map["text"];
    seen = map["seen"];
    timeStamp = map["timeStamp"];
  }

  Map<String, dynamic> toMap() {
    return {
      "messageid": messageid,
      "sender": sender,
      "text": text,
      "seen": seen,
      "timeStamp": timeStamp
    };
  }
}