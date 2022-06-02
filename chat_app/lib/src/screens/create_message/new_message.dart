// ignore_for_file: prefer_const_constructors

import 'package:chat_app/src/controllers/auth_controller.dart';
import 'package:chat_app/src/controllers/chat_controller.dart';
import 'package:chat_app/src/models/chat_user_model.dart';
import 'package:chat_app/src/widgets/search_bar.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';

import '../../models/chat_user_model.dart';

import '../../service_locators.dart';

class NewMessage extends StatefulWidget {
  static const String route = 'home-screen';
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final AuthController _auth = locator<AuthController>();
  final ChatController _chatController = ChatController();

  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFN = FocusNode();

  late Future<List<ChatUser>> gettingUsers;
  @override
  void initState() {
    gettingUsers = ChatUser.getUsers();
    ChatUser.fromUid(uid: _auth.currentUser!.uid).then((value) {
      if (mounted) {
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _messageFN.dispose();
    _messageController.dispose();
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Theme.of(context).bottomAppBarColor,
      statusBarColor: Theme.of(context).primaryColor,
      //color set to transperent or set your own color
    ));
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'New Message',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Searchbar(),
              newGroupChat(context),
              ListTile(
                title: Text(
                  "People on Tabi",
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              showUserList(),
            ],
          ),
        ),
      ),
    );
  }

  Expanded showUserList() {
    return Expanded(
      child: FutureBuilder<List<ChatUser>>(
          future: gettingUsers,
          builder: (
            BuildContext context,
            AsyncSnapshot<List<ChatUser>> snapshot,
          ) {
            if (!snapshot.hasData) {
              return SizedBox();
            }
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  print(index);
                  return ListTile(
                    leading: CircleAvatar(
                      child: Icon(Icons.person_rounded),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      snapshot.data![index].username,
                    ),
                    subtitle: null,
                  );
                });
          }),
    );
  }

  ListTile newGroupChat(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.group_rounded),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        "Create a group chat",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
