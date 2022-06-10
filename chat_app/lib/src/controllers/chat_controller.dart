import 'dart:async';
import 'package:chat_app/src/models/chat_message_model.dart';
import 'package:chat_app/src/models/chat_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatController with ChangeNotifier {
  late StreamSubscription _chatSub;
  final StreamController<String?> _controller = StreamController();
  Stream<String?> get stream => _controller.stream;
  ChatUser? user;
  late String recipient;
  List<ChatMessage> chats = [];

  String? chatroom;
  ChatController() {
    if (chatroom != null) {
      return;
    }
    _controller.add("empty");
  }

  _subscibe() {
    _chatSub = ChatMessage.currentChats(chatroom!).listen(chatUpdateHandler);
    _controller.add("success");
  }

  initChatRoom(String room, String currentRecipient) {
    ChatUser.fromUid(uid: FirebaseAuth.instance.currentUser!.uid).then((value) {
      recipient = currentRecipient;
      user = value;
      if (user != null && user!.chatrooms.contains(room)) {
        _subscibe();
      } else {
        _controller.add("empty");
      }
      chatroom = room;
    });
  }

  generateRoomId(recipient) {
    String currentUser = FirebaseAuth.instance.currentUser!.uid;

    if (currentUser.codeUnits[0] >= recipient.codeUnits[0]) {
      if (currentUser.codeUnits[1] == recipient.codeUnits[1]) {
        return chatroom = recipient + currentUser;
      }
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
    for (ChatMessage message in update) {
      print("1");
      print(message.sentBy != FirebaseAuth.instance.currentUser!.uid);
      print("2");
      print(chatroom == generateRoomId(recipient));
      print("3");
      print(message.hasNotSeenMessage(FirebaseAuth.instance.currentUser!.uid));
      if (message.sentBy == FirebaseAuth.instance.currentUser!.uid &&
          chatroom == generateRoomId(recipient) &&
          message.hasNotSeenMessage(FirebaseAuth.instance.currentUser!.uid)) {
        print('seeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeen');
        message.updateSeen(
            FirebaseAuth.instance.currentUser!.uid, chatroom!, recipient);
      } else {
        print('zzzzzzzzzzzzzzzzzzzzzzzzzz');
      }
    }

    chats = update;
    notifyListeners();
  }

  sendFirstMessage(String message, String recipient, bool isGroup) {
    var newMessage = ChatMessage(
            sentBy: FirebaseAuth.instance.currentUser!.uid, message: message)
        .json;
    var thisUser = FirebaseAuth.instance.currentUser!.uid;
    String chatroom = generateRoomId(recipient);

    FirebaseFirestore.instance.collection('chats').doc(chatroom).set({
      'chatroom': chatroom,
      'isGroup': isGroup,
      'members': FieldValue.arrayUnion([recipient, thisUser])
    }).then(
      (snap) => {
        FirebaseFirestore.instance
            .collection('chats')
            .doc(chatroom)
            .collection('messages')
            .add(newMessage)
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
        FirebaseFirestore.instance
            .collection('users')
            .doc(recipient)
            .collection('messageSnapshot')
            .doc(chatroom)
            .set(newMessage),
        FirebaseFirestore.instance
            .collection('users')
            .doc(thisUser)
            .collection('messageSnapshot')
            .doc(chatroom)
            .set(newMessage),
        _subscibe(),
      },
    );

    return chatroom;
  }

  Future sendMessage(
      {required String message, required String recipient}) async {
    var newMessage = ChatMessage(
            sentBy: FirebaseAuth.instance.currentUser!.uid, message: message)
        .json;
    var thisUser = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(recipient)
        .collection('messageSnapshot')
        .doc(chatroom)
        .set(ChatMessage(
                sentBy: FirebaseAuth.instance.currentUser!.uid,
                message: message)
            .json);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(thisUser)
        .collection('messageSnapshot')
        .doc(chatroom)
        .set(ChatMessage(
                sentBy: FirebaseAuth.instance.currentUser!.uid,
                message: message)
            .json);

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
        List<ChatUser> users = [];

        for (var data in value.docs) {
          users.add(ChatUser.fromDocumentSnap(data));
        }
        return users;
      });
    });
  }
}
