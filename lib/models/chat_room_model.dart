class ChatRoomModel {
  String? chatroomid;
  Map<String, dynamic>? participants;
  String? lastMessage;
  DateTime? createdon;
  List<dynamic>? users;

  ChatRoomModel(
      {this.chatroomid,
      this.participants,
      this.lastMessage,
      this.createdon,
      this.users});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatroomid = map["chatroomid"];
    participants = map["participants"];
    lastMessage = map["lastmessage"];
    createdon = map["createdon"].toDate();
    users = map["users"];
  }

  Map<String, dynamic> topMap() {
    return {
      "chatroomid": chatroomid,
      "participants": participants,
      "lastmessage": lastMessage,
      "createdon": createdon,
      "users": users,
    };
  }
}
