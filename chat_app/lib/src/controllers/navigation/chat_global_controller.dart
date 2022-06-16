import 'dart:async';

import 'package:chat_app/src/models/chat_message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatControllerGlobal with ChangeNotifier {
  late StreamSubscription _chatSub;
  List<ChatMessage> chats = [];

  ChatControllerGlobal() {
    _chatSub = ChatMessage.currentChats("globalchat").listen(chatUpdateHandler);
  }

  @override
  void dispose() {
    _chatSub.cancel();
    super.dispose();
  }

  chatUpdateHandler(List<ChatMessage> update) {
    for (ChatMessage message in update) {
      if (message.hasNotSeenMessage(FirebaseAuth.instance.currentUser!.uid)) {
        message.updateSeenGlobal(FirebaseAuth.instance.currentUser!.uid);
      }
    }
    chats = update;
    notifyListeners();
  }

  Future sendMessage({required String message}) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc("globalchat")
        .collection('messages')
        .add(ChatMessage(
                sentBy: FirebaseAuth.instance.currentUser!.uid,
                message: message)
            .json);
  }

  Future sendImageInGroup({required String image}) async {
    return await FirebaseFirestore.instance
        .collection('chats')
        .doc('globalchat')
        .collection('messages')
        .add(ChatMessage(
                sentBy: FirebaseAuth.instance.currentUser!.uid,
                image: image,
                message: 'sent an image',
                isImage: true)
            .json);
  }
  // Future sendMessage({required String message}) {
  //   ChatMessage payload = ChatMessage(
  //     sentBy: FirebaseAuth.instance.currentUser!.uid,
  //     message: message,
  //   );
  //   return FirebaseFirestore.instance.collection('chats').add(payload.json);
  // }
}
