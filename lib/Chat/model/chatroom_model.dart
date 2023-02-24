class ChatRoomModel {
  String? chatroomid;
  String? chatUserName1;
  String? chatUserName2;
  String? chatUser1;
  String? chatUser2;
  Map<String, dynamic>? participants;
  String? lastMessage;
  String? lastMessageTime;

  ChatRoomModel({this.chatroomid, this.participants,
    this.lastMessage,required this.chatUser1,required this.chatUser2,
    required this.chatUserName1,
    required this.chatUserName2,
    required this.lastMessageTime});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatroomid = map["chatroomid"];
    chatUserName1 = map["userName1"];
    chatUserName2 = map["userName2"];
    participants = map["participants"];
    lastMessage = map["lastmessage"];
    chatUser1 = map["chatUser1"];
    chatUser2 = map["chatUser2"];
    lastMessageTime = map["lastMessageTime"];
  }

  Map<String, dynamic> toMap() {
    return {
      "chatroomid": chatroomid,
      "userName1": chatUserName1,
      "userName2": chatUserName2,
      "participants": participants,
      "chatUser1": chatUser1,
      "chatUser2": chatUser2,
      "lastmessage": lastMessage,
      "lastMessageTime": lastMessageTime
    };
  }
}