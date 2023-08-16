class MessageModel{
  String? Sender;
  String? text;
  bool? seen;
  DateTime? createdon;

  MessageModel({this.Sender, this.text, this.seen, this.createdon});

    MessageModel.fromMap(Map<String, dynamic>map){
  Sender = map ["Sender"];
  text = map ["text"];
  seen = map ["seen"];
  createdon = map ["createdon"];  
}
Map<String, dynamic> topMap()  { 
    return {
      "Sender" : Sender,
      "text" : text,
      "seen" : seen,
      "createdon" : createdon,
      };

}

}