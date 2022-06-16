// ignore_for_file: prefer_const_constructors
import 'package:chat_app/src/models/chat_user_model.dart';
import 'package:chat_app/src/screens/home/chats_private.dart';
import 'package:chat_app/src/widgets/avatar.dart';
import 'package:chat_app/src/widgets/search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import '../../models/chat_user_model.dart';

// ignore: must_be_immutable
class NewMessage extends StatelessWidget {
  NewMessage({Key? key, required this.blocklist}) : super(key: key);
  List<dynamic> blocklist;
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
              Searchbar(
                blocklist: blocklist,
              ),
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
  Geoflutterfire geo = Geoflutterfire();
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
                  // GeoFirePoint myLocation =
                  //     geo.point(latitude: 0, longitude: 0);
                  // FirebaseFirestore.instance
                  //     .collection('users')
                  //     .doc(snapshot.data![index].uid)
                  //     .update({
                  //   'chatrooms': FieldValue.arrayUnion(["globalchat"]),
                  // });

                  if (snapshot.data?[index].username == null) {
                    return CircularProgressIndicator();
                  }
                  return snapshot.data![index].uid !=
                              FirebaseAuth.instance.currentUser?.uid &&
                          !blocklist.contains(snapshot.data![index].uid)
                      ? ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ChatScreenPrivate(
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
