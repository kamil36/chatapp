class ChatRoomModel {
  String? chatroomid;
  Map<String, dynamic>? participants;
  String? lastMessage;
  // DateTime? date;
  List<dynamic>? users;

  ChatRoomModel(
      {this.chatroomid,
      this.participants,
      this.lastMessage,
      // this.date,
      this.users,
      required DateTime createdon});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatroomid = map["chatroomid"];
    participants = map["participants"];
    lastMessage = map["lastmessage"];
    // date = map["date"]!.toDate();
    users = map["users"];
  }

  Map<String, dynamic> topMap() {
    return {
      "chatroomid": chatroomid,
      "participants": participants,
      "lastmessage": lastMessage,
      // "date": date,
      "users": users,
    };
  }
}
