import 'dart:async';

import 'package:chat_app/src/models/chat_message_model.dart';
import 'package:chat_app/src/models/chat_user_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageListController with ChangeNotifier {
  late StreamSubscription _chatSub;
  final StreamController<String?> _controller = StreamController();
  Stream<String?> get stream => _controller.stream;
  ChatUser? user;
  List<ChatMessage> chats = [];

  String? chatroom;
  MessageListController() {
    if (chatroom != null) {
      return;
    }
    _controller.add("empty");
  }

  _subscibe() {
    _chatSub = ChatMessage.currentChats(chatroom!).listen(chatUpdateHandler);
    _controller.add("success");
  }

  initChatRoom(String room) {
    print("inisidee.init1");
    ChatUser.fromUid(uid: FirebaseAuth.instance.currentUser!.uid).then((value) {
      print("inisidee.init2");
      user = value;
      if (user != null && user!.chatrooms.contains(room)) {
        _subscibe();
      } else {
        _controller.add("empty");
      }
      chatroom = room;
      print(user?.chatrooms);
      print(user?.chatrooms.contains(room));
    });
    print("inisidee.init3");
  }

  generateRoomId(recipient) {
    String currentUser = FirebaseAuth.instance.currentUser!.uid;

    if (currentUser.codeUnits[0] > recipient.codeUnits[0]) {
      return chatroom = currentUser + recipient;
    }
    return chatroom = recipient + currentUser;
  }

  @override
  void dispose() {
    _chatSub.cancel();
    super.dispose();
  }

  Future<dynamic> getCurrentChats() async {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
    } on FirebaseAuthException catch (error) {
      print(error);
    }
  }

  getChatRooms(List<String> userChatRooms) {
    try {
      var data = [];

      FirebaseFirestore.instance
          .collection('chats')
          .where("chatroom", whereIn: userChatRooms)
          .get()
          .then((value) => {
                for (var item in value.docs) {data.add(item.data())}
              });
      return data;
    } catch (error) {
      print(error);
    }
  }

  chatUpdateHandler(List<ChatMessage> update) {
    // for (ChatMessage message in update) {
    //   if (message.hasNotSeenMessage(FirebaseAuth.instance.currentUser!.uid)) {
    //     message.updateSeen(FirebaseAuth.instance.currentUser!.uid);
    //   }
    // }
    chats = update;
    notifyListeners();
  }

  sendFirstMessage(String message, String recipient, bool isGroup) {
    String chatroom = generateRoomId(recipient);

    FirebaseFirestore.instance.collection('chats').doc(chatroom).set({
      'chatroom': chatroom,
      'isGroup': isGroup,
      'members': FieldValue.arrayUnion(
          [recipient, FirebaseAuth.instance.currentUser!.uid])
    }).then(
      (snap) => {
        FirebaseFirestore.instance
            .collection('chats')
            .doc(chatroom)
            .collection('messages')
            .add(ChatMessage(
                    sentBy: FirebaseAuth.instance.currentUser!.uid,
                    message: message)
                .json)
            .then((value) => {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({
                    'chatrooms': FieldValue.arrayUnion([chatroom])
                  }).then((value) => {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(recipient)
                                .update({
                              'chatrooms': FieldValue.arrayUnion([chatroom])
                            }),
                            _subscibe(),
                          }),
                }),
      },
    );

    return chatroom;
  }

  Future sendMessage({required String message}) async {
    return await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatroom)
        .collection('messages')
        .add(ChatMessage(
                sentBy: FirebaseAuth.instance.currentUser!.uid,
                message: message)
            .json);
  }

  Future fetchChatrooms() {
    return ChatUser.fromUid(uid: FirebaseAuth.instance.currentUser!.uid)
        .then((value) {
      return value;
    }).then((dynamic user) {
      return FirebaseFirestore.instance
          .collection("users")
          .where("chatrooms", arrayContainsAny: user?.chatrooms ?? [])
          .get()
          .then((value) {
        List<dynamic> users = [];

        for (var data in value.docs) {
          users.add(ChatUser.fromDocumentSnap(data));
        }
        return users;
      });
    });
  }
}
