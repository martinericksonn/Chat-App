import 'dart:async';

import 'package:chat_app/src/models/chat_message_model.dart';
import 'package:chat_app/src/widgets/chat_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatController with ChangeNotifier {
  late StreamSubscription _chatSub;
  final StreamController<String?> _controller = StreamController();
  Stream<String?> get stream => _controller.stream;
  List<ChatMessage> chats = [];

  String? chatroom;

  ChatController() {
    if (chatroom != null) {
      _subscibe();
      return;
    }
    _controller.add("empty");
  }

  _subscibe() {
    _chatSub = ChatMessage.currentChats(chatroom!).listen(chatUpdateHandler);
    _controller.add("success");
  }

  initChatRoom(String room) {
    chatroom = room;
    _subscibe();
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

    print("Forst MESSAGE");
    FirebaseFirestore.instance
        .collection(
          'chats',
        )
        .doc(chatroom)
        .set({
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
                .json),
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'chatrooms': FieldValue.arrayUnion([chatroom])
        }),
        FirebaseFirestore.instance.collection('users').doc(recipient).update({
          'chatrooms': FieldValue.arrayUnion([chatroom])
        }),
      },
    );
    return chatroom;
  }

  Future sendMessage({required String message}) async {
    print("im insideeeeee");
    return await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatroom)
        .collection('messages')
        .add(ChatMessage(
                sentBy: FirebaseAuth.instance.currentUser!.uid,
                message: message)
            .json);
  }
}
