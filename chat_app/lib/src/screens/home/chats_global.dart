// ignore_for_file: prefer_const_constructors

import 'package:chat_app/src/controllers/auth_controller.dart';

import 'package:chat_app/src/controllers/navigation/chat_global_controller.dart';
import 'package:chat_app/src/models/chat_user_model.dart';
import 'package:chat_app/src/widgets/chat_bubble.dart';

import 'package:flutter/material.dart';

import '../../models/chat_user_model.dart';

import '../../service_locators.dart';
import '../../services/image_service.dart';

class GlobalChat extends StatefulWidget {
  const GlobalChat({Key? key}) : super(key: key);

  @override
  State<GlobalChat> createState() => _GlobalChatState();
}

class _GlobalChatState extends State<GlobalChat> {
  final AuthController _auth = locator<AuthController>();
  final ChatControllerGlobal _chatControllerGlobal = ChatControllerGlobal();

  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFN = FocusNode();
  final ScrollController _scrollController = ScrollController();

  ChatUser? user;
  @override
  void initState() {
    ChatUser.fromUid(uid: _auth.currentUser!.uid).then((value) {
      if (mounted) {
        setState(() {
          user = value;
        });
      }
    });
    _chatControllerGlobal.addListener(scrollToBottom);
    super.initState();
  }

  @override
  void dispose() {
    _chatControllerGlobal.dispose();

    _chatControllerGlobal.removeListener(scrollToBottom);
    _messageFN.dispose();
    _messageController.dispose();

    super.dispose();
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            FittedBox(
              // color: Colors.red,

              child: CircleAvatar(
                // radius: 40,
                child: Image.asset("assets/images/tabi_lightmode.png"),
                backgroundColor: Theme.of(context).colorScheme.primary,
                // backgroundImage:  DecorationImage(image: NetworkImage("urlImage"),

                // backgroundImage: ,
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              "Tabi Global",
              style: TextStyle(
                  fontSize: 21,
                  color: Theme.of(context).textTheme.bodyLarge!.color),
            ),
          ],
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              child: AnimatedBuilder(
                  animation: _chatControllerGlobal,
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
                                itemCount: _chatControllerGlobal.chats.length,
                                itemBuilder: (context, index) {
                                  print(_chatControllerGlobal
                                      .chats[index].message);
                                  // return Text(_chatControllerGlobal
                                  //     .chats[index].message);
                                  return ChatCard(
                                    scrollController: _scrollController,
                                    index: index,
                                    chat: _chatControllerGlobal.chats,
                                    chatroom: 'globalchat',
                                    recipient: 'globalchat',
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
            ),
            Container(
              height: MediaQuery.of(context).size.height / 15,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: Theme.of(context).colorScheme.primary,
                      size: 35,
                    ),
                    onPressed: () => sendImage(),
                  ),
                  Expanded(
                    child: TextFormField(
                      onFieldSubmitted: (String text) {
                        send();
                      },
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
                      size: 35,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: send,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  sendImage() {
    ImageService.sendImageInGroup(_chatControllerGlobal);
  }

  send() {
    _messageFN.unfocus();
    if (_messageController.text.isNotEmpty) {
      _chatControllerGlobal.sendMessage(
          message: _messageController.text.trim());
      _messageController.text = '';
    }
  }
}
