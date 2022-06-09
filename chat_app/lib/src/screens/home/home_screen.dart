// ignore_for_file: prefer_const_constructors

import 'package:chat_app/src/controllers/auth_controller.dart';
import 'package:chat_app/src/models/chat_list_model.dart';
import 'package:chat_app/src/models/chat_user_model.dart';
import 'package:chat_app/src/screens/create_message/new_message.dart';
import 'package:chat_app/src/screens/home/chats_screen%20copy.dart';
import 'package:chat_app/src/screens/home/profile_screen.dart';
import 'package:chat_app/src/screens/home/search.dart';
import 'package:chat_app/src/services/image_service.dart';
import 'package:chat_app/src/widgets/avatar.dart';
import 'package:chat_app/src/widgets/search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../controllers/chat_list_controller.dart';
import '../../models/chat_user_model.dart';
import '../../service_locators.dart';

class HomeScreen extends StatefulWidget {
  static const String route = 'home-screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController _auth = locator<AuthController>();
  final ChatListController _chatListController = ChatListController();
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFN = FocusNode();

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

    super.initState();
  }

  @override
  void dispose() {
    _messageFN.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarIconBrightness:
          Theme.of(context).scaffoldBackgroundColor.computeLuminance() > 0.5
              ? Brightness.dark
              : Brightness.light,
      statusBarIconBrightness:
          Theme.of(context).scaffoldBackgroundColor.computeLuminance() > 0.5
              ? Brightness.dark
              : Brightness.light,
      systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
      statusBarColor: Theme.of(context).scaffoldBackgroundColor,
      //color set to transperent or set your own color
    ));
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appBar(),
      body: body(context),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () => {_auth.logout()},
        label:
            Text("Log out", style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }

  SizedBox body(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Searchbar(),
            messageList(),
            // IconButton(
            //   onPressed: () {
            //     _auth.logout();
            //   },
            //   icon: const Icon(Icons.logout_rounded),
            //   color: Theme.of(context).colorScheme.primary,
            // ),
          ],
        ),
      ),
    );
  }

//AsyncSnapshot<dynamic> snapshot
  Widget messageList() {
    return Column(
      children: [
        SizedBox(
          // height: MediaQuery.of(context).size.height / 1.5,
          child: RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: _chatListController.chats.isEmpty
                ? bodyNoMessage()
                : bodyWithMessage(),
          ),
        ),

        // ),
      ],
    );
  }

  Widget bodyNoMessage() {
    return Center(
      child: Column(children: [
        Image.asset("assets/images/home_empty.png", width: 300),
        Text("Create your first message on Tabi or"),
        SizedBox(height: 2),
        Text("invite your friends and enjoy Tabi-Tabi together"),
      ]),
    );
  }

  Widget bodyWithMessage() {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _chatListController.chats.length,
        itemBuilder: (context, index) {
          var chatListUser = _chatListController.extractUID(
              _chatListController.chats[index].uid,
              FirebaseAuth.instance.currentUser!.uid);

          if (_chatListController.chats[index].uid !=
              FirebaseAuth.instance.currentUser!.uid) {
            return FutureBuilder<ChatUser>(
                future: ChatUser.fromUid(uid: chatListUser),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox(
                      child: CircleAvatar(child: CircularProgressIndicator()),
                    );
                  }

                  return Container(
                    child: messageListTile(
                        context, _chatListController.chats[index], snapshot),
                  );
                });
          }
          return SizedBox(child: Text('asdasd'));
        });
  }

  ListTile messageListTile(BuildContext context, ChatList chatList,
      AsyncSnapshot<ChatUser> chatUser) {
    return ListTile(
        onTap: () => {
              print("on tap"),
              print(chatList.uid),
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      ChatScreen(selectedUserUID: chatUser.data!.uid),
                ),
              )
            },
        subtitle: Text(
            chatList.sentBy == user!.uid
                ? "You: " + chatList.message
                : chatList.message,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: chatList.seenBy.contains(user!.uid)
                  ? FontWeight.normal
                  : FontWeight.bold,
            )),
        leading: AvatarImage(
          uid: chatUser.data!.uid,
        ),
        title: Text(
          chatUser.data!.username,
          style: TextStyle(
            fontWeight: chatList.seenBy.contains(user!.uid)
                ? FontWeight.normal
                : FontWeight.bold,
            // color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        trailing: Text(
          DateFormat("hh:mm aaa").format(chatList.ts.toDate()),
          style: TextStyle(
            fontWeight: chatList.seenBy.contains(user!.uid)
                ? FontWeight.normal
                : FontWeight.bold,
          ),
        ));
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      title: Row(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: InkWell(
              onTap: () {
                 Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProfileScreen(),
              ),
            );
              },
              child: SizedBox(
                  child:
                      AvatarImage(uid: FirebaseAuth.instance.currentUser!.uid)),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            user?.username ?? '...',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NewMessage(),
              ),
            );
          },
          icon: const Icon(Icons.edit_rounded),
          color: Theme.of(context).colorScheme.primary,
        )
      ],
    );
  }
}
