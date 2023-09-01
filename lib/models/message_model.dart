class MessageModel {
  String? Sender;
  String? text;
  bool? seen;
  DateTime? createdon;
  String? messageid;

  MessageModel(
      {this.Sender, this.text, this.seen, this.createdon, this.messageid});

  MessageModel.fromMap(Map<String, dynamic> map) {
    Sender = map["Sender"];
    text = map["text"];
    seen = map["seen"];
    createdon = map["createdon"];
    messageid = map["messageid"];
  }
  Map<String, dynamic> topMap() {
    return {
      "Sender": Sender,
      "text": text,
      "seen": seen,
      "createdon": createdon,
      "messageid": messageid,
    };
  }
}
