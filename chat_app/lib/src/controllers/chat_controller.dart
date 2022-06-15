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
  List<ChatMessage> messages = [];

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
      if (chatroom == generateRoomId(recipient) &&
          message.hasNotSeenMessage(FirebaseAuth.instance.currentUser!.uid)) {
        message.updateSeen(
            FirebaseAuth.instance.currentUser!.uid, chatroom!, recipient);
      } else {}
    }

    messages = update;
    notifyListeners();
  }

  sendFirstMessage(
      {String message = '',
      required String recipient,
      bool isImage = false,
      String image = ''}) {
    var newMessage = ChatMessage(
            sentBy: FirebaseAuth.instance.currentUser!.uid, message: message)
        .json;
    var newImage = ChatMessage(
            sentBy: FirebaseAuth.instance.currentUser!.uid,
            message: "sent an image",
            isImage: true,
            image: image)
        .json;
    var thisUser = FirebaseAuth.instance.currentUser!.uid;
    String chatroom = generateRoomId(recipient);

    if (!isImage) {
      firstMessageText(chatroom, recipient, thisUser, newMessage);
    } else {
      firstMessageImage(chatroom, recipient, thisUser, newImage);
    }

    // return chatroom;
  }

  void firstMessageText(String chatroom, String recipient, String thisUser,
      Map<String, dynamic> newMessage) {
    FirebaseFirestore.instance.collection('chats').doc(chatroom).set({
      'chatroom': chatroom,
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
  }

  void firstMessageImage(String chatroom, String recipient, String thisUser,
      Map<String, dynamic> newImage) {
    FirebaseFirestore.instance.collection('chats').doc(chatroom).set({
      'chatroom': chatroom,
      'members': FieldValue.arrayUnion([recipient, thisUser])
    }).then(
      (snap) => {
        FirebaseFirestore.instance
            .collection('chats')
            .doc(chatroom)
            .collection('messages')
            .add(newImage)
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
            .set(newImage),
        FirebaseFirestore.instance
            .collection('users')
            .doc(thisUser)
            .collection('messageSnapshot')
            .doc(chatroom)
            .set(newImage),
        _subscibe(),
      },
    );
  }

  Future sendMessage(
      {String message = '',
      required String recipient,
      bool isImage = false,
      String image = ''}) async {
    var thisUser = FirebaseAuth.instance.currentUser!.uid;

    if (!isImage) {
      return await _sendMessageText(recipient, message, thisUser);
    } else {
      return await _sendMessageImage(recipient, image, thisUser);
    }
  }

  Future<DocumentReference<Map<String, dynamic>>> _sendMessageImage(
      String recipient, String image, String thisUser) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(recipient)
        .collection('messageSnapshot')
        .doc(chatroom)
        .set(ChatMessage(
                sentBy: FirebaseAuth.instance.currentUser!.uid,
                image: image,
                message: 'sent an image',
                isImage: true)
            .json);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(thisUser)
        .collection('messageSnapshot')
        .doc(chatroom)
        .set(ChatMessage(
                sentBy: FirebaseAuth.instance.currentUser!.uid,
                image: image,
                message: 'sent an image',
                isImage: true)
            .json);
    return await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatroom)
        .collection('messages')
        .add(ChatMessage(
                sentBy: FirebaseAuth.instance.currentUser!.uid,
                image: image,
                message: 'sent an image',
                isImage: true)
            .json);
  }

  Future<DocumentReference<Map<String, dynamic>>> _sendMessageText(
      String recipient, String message, String thisUser) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(recipient)
        .collection('messageSnapshot')
        .doc(chatroom)
        .set(ChatMessage(
          sentBy: FirebaseAuth.instance.currentUser!.uid,
          message: message,
        ).json);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(thisUser)
        .collection('messageSnapshot')
        .doc(chatroom)
        .set(ChatMessage(
          sentBy: FirebaseAuth.instance.currentUser!.uid,
          message: message,
        ).json);

    return await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatroom)
        .collection('messages')
        .add(ChatMessage(
          sentBy: FirebaseAuth.instance.currentUser!.uid,
          message: message,
        ).json);
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
