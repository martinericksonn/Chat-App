import 'dart:async';

import 'package:chat_app/src/models/chat_message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatController with ChangeNotifier {
  late StreamSubscription _chatSub;
  List<ChatMessage> chats = [];
  String? previousChatID;

  ChatController(String chatroom) {
    _chatSub = ChatMessage.currentChats(chatroom).listen(chatUpdateHandler);
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

  Future sendFirstMessage(String message, String recipient, bool isGroup) {
    String docID = FirebaseAuth.instance.currentUser!.uid + recipient;
    return FirebaseFirestore.instance
        .collection(
          'chats',
        )
        .doc(docID)
        .set({
      'isGroup': isGroup,
      'members': FieldValue.arrayUnion(
          [recipient, FirebaseAuth.instance.currentUser!.uid])
    }).then((snap) => {
              FirebaseFirestore.instance
                  .collection('chats')
                  .doc(docID)
                  .collection('messages')
                  .add(ChatMessage(
                          sentBy: FirebaseAuth.instance.currentUser!.uid,
                          message: message)
                      .json),
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .update({
                'chatrooms': FieldValue.arrayUnion([docID])
              }),
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(recipient)
                  .update({
                'chatrooms': FieldValue.arrayUnion([docID])
              })
            });
  }

  Future sendMessage({required String message, required String chatID}) async {
    return await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatID)
        .collection('messages')
        .add(ChatMessage(
                sentBy: FirebaseAuth.instance.currentUser!.uid,
                message: message)
            .json);
  }
}
