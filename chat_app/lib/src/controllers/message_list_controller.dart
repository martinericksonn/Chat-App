import 'dart:async';

import 'package:chat_app/src/models/chat_message_model.dart';
import 'package:chat_app/src/models/chat_user_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageListController with ChangeNotifier {
  late StreamSubscription _messagesSub;
  final StreamController<String?> _controller = StreamController();
  Stream<String?> get stream => _controller.stream;
  ChatUser user;
  List<ChatMessage> messages = [];
  List<ChatUser> users = [];
  List<String> chatrooms = [];
  String? chatroom;

  MessageListController(this.user) {
    fetchChatrooms();
    try {
      // var somedata = activeChats();
      // shit();
    } catch (e) {
      print('errrrrrrrrrrrrrrrrrror');
      print(e);
    }
  }

  static Stream<void> activeChats() => FirebaseFirestore.instance
      .collection('chats')
      .snapshots()
      .map(fromQuerySnap);

  static fromQuerySnap(QuerySnapshot snap) {
    try {
      print(snap.docs);
      // return snap.docs.map(ChatMessage.fromDocumentSnap).toList();
    } catch (e) {
      print(e);
      return [];
    }
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
        List<ChatUser> currentUserMsgList = [];
        for (var data in value.docs) {
          currentUserMsgList.add(ChatUser.fromDocumentSnap(data));
        }
        users = currentUserMsgList;
        return currentUserMsgList;
      });
    });
  }

  @override
  void dispose() {
    _messagesSub.cancel();
    super.dispose();
  }

  chatUpdateHandler(List<ChatMessage> update) {
    messages = update;
    notifyListeners();
  }

  Future sendMessage({required String message}) {
    return FirebaseFirestore.instance.collection('chats').add(ChatMessage(
            sentBy: FirebaseAuth.instance.currentUser!.uid, message: message)
        .json);
  }
}
