import 'dart:developer';

import 'package:app_chat/main.dart';
import 'package:app_chat/models/chat_room_model.dart';
import 'package:app_chat/models/user_model.dart';
import 'package:app_chat/pages/chatroom_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const SearchPage(
      {super.key, required this.userModel, required this.firebaseUser});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  Future<ChatRoomModel?> getChatroomModel(UserModel targetuser) async {
    ChatRoomModel? chatRoom;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${widget.userModel.uid}", isEqualTo: true)
        .where("participants.${targetuser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.length > 0) {
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);
      chatRoom = existingChatroom;
    } else {
      ChatRoomModel newChatroom = ChatRoomModel(
        chatroomid: uuid.v1(),
        lastMessage: "",
        participants: {
          widget.userModel.uid.toString(): true,
          targetuser.uid.toString(): true,
        },
        users: [widget.userModel.uid.toString(), targetuser.uid.toString()],
        createdon: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatroom.chatroomid)
          .set(newChatroom.topMap());
      chatRoom = newChatroom;
      log("New Chatroom Created");
    }
    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: BackButton(
          color: Colors.white,
        ),
        title: Text(
          "Search",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                label: Text("Email Address"),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              child: Text(
                "Search",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(200, 50), backgroundColor: Colors.blue),
            ),
            SizedBox(
              height: 20,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where("email", isEqualTo: searchController.text)
                  .where("email", isNotEqualTo: widget.userModel.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
                    if (dataSnapshot.docs.length > 0) {
                      Map<String, dynamic> usermap =
                          dataSnapshot.docs[0].data() as Map<String, dynamic>;

                      UserModel searchedUser = UserModel.fromMap(usermap);
                      return ListTile(
                        onTap: () async {
                          ChatRoomModel? chatroomModel =
                              await getChatroomModel(searchedUser);
                          if (chatroomModel != null) {
                            Navigator.pop(context);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ChatRoomPage(
                                targetuser: searchedUser,
                                chatroom: chatroomModel,
                                userModel: widget.userModel,
                                firebaseuser: widget.firebaseUser,
                              );
                            }));
                          }
                        },
                        title: Text(searchedUser.fullname!),
                        subtitle: Text(searchedUser.email!),
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(searchedUser.profilepic!),
                          backgroundColor: Colors.grey[500],
                        ),
                        trailing: Icon(Icons.keyboard_arrow_right),
                      );
                    } else {
                      return Text("No results found!");
                    }
                  } else if (snapshot.hasError) {
                    return Text("An error occured!");
                  } else {
                    return Text("No results found!");
                  }
                } else {
                  CircularProgressIndicator();
                  return SizedBox();
                }
              },
            ),
          ],
        ),
      )),
    );
  }
}
