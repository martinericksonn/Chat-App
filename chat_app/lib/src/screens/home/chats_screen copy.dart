// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:chat_app/src/controllers/auth_controller.dart';
import 'package:chat_app/src/controllers/chat_controller.dart';
import 'package:chat_app/src/models/chat_user_model.dart';
import 'package:chat_app/src/widgets/avatar.dart';
import 'package:chat_app/src/widgets/chat_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';

import '../../models/chat_list_model.dart';
import '../../models/chat_user_model.dart';

// import '../../service_locators.dart';

class ChatScreen extends StatefulWidget {
  final String chatroom;
  final String selectedUserUID;
  const ChatScreen(
      {Key? key, required this.selectedUserUID, this.chatroom = ""});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // final AuthController _auth = locator<AuthController>();
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFN = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final ChatController _chatController = ChatController();
  String get selectedUserUID => widget.selectedUserUID;

  String get chatroom => widget.chatroom;
  ChatUser? user;

  @override
  void initState() {
    print('ChatScreen IN');
    print(selectedUserUID);
    _chatController.initChatRoom(
        _chatController.generateRoomId(selectedUserUID), selectedUserUID);
    print('ChatScreen END');
    super.initState();
  }

  scrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 250));
    print('scrolling to bottom');
    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          curve: Curves.easeIn, duration: const Duration(milliseconds: 250));
    }
  }

  scrollBottom() async {
    await Future.delayed(const Duration(milliseconds: 250));
    print('scrolling to bottom');
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
          _scrollController.position.viewportDimension +
              _scrollController.position.maxScrollExtent,
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 250));
    }
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   systemNavigationBarColor: Theme.of(context).bottomAppBarColor,
    //   statusBarColor: Theme.of(context).primaryColor,
    //   //color set to transperent or set your own color
    // ));
    return FutureBuilder<ChatUser>(
        future: ChatUser.fromUid(uid: selectedUserUID),
        builder: (BuildContext context, AsyncSnapshot<ChatUser> selectedUser) {
          if (!selectedUser.hasData) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  SizedBox(
                    child: CircularProgressIndicator(),
                    height: 50.0,
                    width: 50.0,
                  ),
                ],
              ),
            );
          }
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              elevation: 0,
              title: Row(
                children: [
                  AvatarImage(uid: selectedUser.data!.uid),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    selectedUser.data!.username,
                    style: TextStyle(
                        fontSize: 21,
                        color: Theme.of(context).textTheme.bodyLarge!.color),
                  ),
                ],
              ),
            ),
            body: StreamBuilder(
              stream: _chatController.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == "null") {
                    return loadingScreen("1");
                  } else if (snapshot.data == "success") {
                    return body(
                      context,
                      message,
                      send,
                    );
                  } else if (snapshot.data == 'empty') {
                    return body(
                      context,
                      firstMessage,
                      firstSend,
                    );
                  }
                } else if (snapshot.hasError) {
                  return loadingScreen(snapshot.error.toString());
                }
                return loadingScreen("3");
              },
            ),
          );
        });
  }

  Center loadingScreen(String num) {
    return Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: <Widget>[
          CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Loading" + num),
          ),
        ]));
  }

  SizedBox body(BuildContext context, Function message, Function send) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            message(),
            textField(context, send),
          ],
        ),
      ),
    );
  }

  Container textField(BuildContext context, Function send) {
    return Container(
      height: MediaQuery.of(context).size.height / 15,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              focusNode: _messageFN,
              controller: _messageController,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.all(12),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(
                    width: 1,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () => send(),
          )
        ],
      ),
    );
  }

  Expanded message() {
    return Expanded(
      child: AnimatedBuilder(
          animation: _chatController,
          builder: (context, Widget? w) {
            return SingleChildScrollView(
              physics: ScrollPhysics(),
              controller: _scrollController,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: _chatController.chats.length,
                        itemBuilder: (context, index) {
                          return ChatCard(
                            scrollController: _scrollController,
                            index: index,
                            chat: _chatController.chats,
                            chatroom: _chatController.chatroom ?? '',
                          );
                        }),

                    // for (ChatMessage chat in _chatController.chats)
                    //   ChatCard(
                    //       chat: chat, chatController: _chatController)
                  ],
                ),
              ),
            );
          }),
    );
  }

  Expanded firstMessage() {
    return Expanded(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/no_message.png", width: 300),
              Text('Start your legendary conversation'),
              SizedBox(
                height: 60,
              )
            ],
          ),
        ),
      ),
    );
  }

  send() {
    _messageFN.unfocus();
    if (_messageController.text.isNotEmpty) {
      _chatController.sendMessage(
          message: _messageController.text.trim(), recipient: selectedUserUID);
      _messageController.text = '';
    }
  }

  firstSend() async {
    _messageFN.unfocus();

    if (_messageController.text.isNotEmpty) {
      var chatroom = _chatController.sendFirstMessage(
          _messageController.text.trim(), selectedUserUID, false);
      _messageController.text = '';

      setState(() {
        _chatController.initChatRoom(chatroom, selectedUserUID);
      });
    }
  }
}
