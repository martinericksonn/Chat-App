import 'dart:async';
import 'package:chat_app/src/models/chat_user_model.dart';
import 'package:flutter/material.dart';
import '../models/chat_list_model.dart';

class ChatListController with ChangeNotifier {
  late StreamSubscription _chatSub;

  List<ChatList> chats = [];

  String? chatroom;
  ChatListController() {
    print("ChatListController");
    _chatSub = ChatList.currentChats().listen(chatUpdateHandler);
  }

  @override
  void dispose() {
    _chatSub.cancel();
    super.dispose();
  }

  chatUpdateHandler(List<ChatList> update) {
    try {
      if (update == []) {
        print("null");
      } else {
        print(update);
        print("update");
      }

      print("chatUpdateHandler");
      chats = update;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  extractUID(String chatroom, String userID) {
    return chatroom.replaceAll(userID, '');
  }

  selectedUser() {}
  // Future fetchChatrooms() {
  //   return ChatUser.fromUid(uid: FirebaseAuth.instance.currentUser!.uid)
  //       .then((value) {
  //     return value;
  //   }).then((dynamic user) {
  //     return FirebaseFirestore.instance
  //         .collection("users")
  //         .where("chatrooms", arrayContainsAny: user?.chatrooms ?? [])
  //         .get()
  //         .then((value) {
  //       List<ChatUser> users = [];

  //       for (var data in value.docs) {
  //         users.add(ChatUser.fromDocumentSnap(data));
  //       }
  //       return users;
  //     });
  //   });
  // }
}
