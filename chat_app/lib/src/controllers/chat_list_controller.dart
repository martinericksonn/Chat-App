import 'dart:async';
import 'package:flutter/material.dart';
import '../models/chat_list_model.dart';

class ChatListController with ChangeNotifier {
  late StreamSubscription chatSub;
  final StreamController<String?> _controller = StreamController();
  Stream<String?> get stream => _controller.stream;

  List<ChatList> chats = [];

  String? chatroom;
  ChatListController() {
    print("ChatListController");
    chatSub = ChatList.currentChats().listen(chatUpdateHandler);
  }

  @override
  void dispose() {
    chatSub.cancel();
    super.dispose();
  }

  chatUpdateHandler(List<ChatList> update) {
    print(
        "chatUpdateHandlerrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
    chats = update;
    notifyListeners();
    _controller.add("");
  }

  extractUID(String chatroom, String userID) {
    return chatroom.replaceAll(userID, '');
  }
}
