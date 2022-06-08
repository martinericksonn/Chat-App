// ignore_for_file: prefer_const_constructors

import 'package:chat_app/src/models/chat_user_model.dart';
import 'package:chat_app/src/screens/home/chats_screen%20copy.dart';
import 'package:chat_app/src/widgets/avatar.dart';
import 'package:chat_app/src/widgets/search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';

import '../../models/chat_user_model.dart';

class NewMessage extends StatelessWidget {
  NewMessage({Key? key}) : super(key: key);

  // late Future<List<ChatUser>> gettingUsers;

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

  // ignore: prefer_typing_uninitialized_variables
  var getUsers;
  Expanded showUserList() {
    getUsers ??= ChatUser.getUsers();
    return Expanded(
      child: FutureBuilder<List<ChatUser>>(
          future: getUsers,
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
                  return snapshot.data![index].uid !=
                          FirebaseAuth.instance.currentUser?.uid
                      ? ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                      selectedUserUID:
                                          snapshot.data![index].uid)),
                            );
                          },
                          leading: AvatarImage(uid: snapshot.data![index].uid),
                          title: Text(
                            snapshot.data![index].username,
                          ),
                          subtitle: null,
                        )
                      : SizedBox();
                });
          }),
    );
  }

  ListTile newGroupChat(BuildContext context) {
    return ListTile(
      onTap: () {
        // _chatController.sendFirstMessage(
        //     "test", _auth.currentUser!.uid, 'private');
        // print("DONE");
      },
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
