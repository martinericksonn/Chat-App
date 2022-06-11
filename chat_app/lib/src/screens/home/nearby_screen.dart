// ignore_for_file: prefer_const_constructors

import 'package:chat_app/src/models/chat_user_model.dart';
import 'package:chat_app/src/screens/home/chats_screen%20copy.dart';
import 'package:chat_app/src/widgets/avatar.dart';
import 'package:chat_app/src/widgets/search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';

import '../../models/chat_user_model.dart';

class NearbyScreen extends StatefulWidget {
  NearbyScreen({Key? key}) : super(key: key);

  @override
  State<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  bool isSwitched = false;

  // late Future<List<ChatUser>> gettingUsers;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Find Nearby',
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
              ListTile(
                title: Text(
                  "Enable Feature",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                      "With on device location, geocoding and geolocator, find nearby allows you to find people near you"),
                ),
                trailing: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                        print(isSwitched);
                      });
                    },
                    // activeTrackColor: Theme.of(context).colorScheme.primary,
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  "Tabians near you",
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
                  return !isSwitched
                      ? SizedBox()
                      : snapshot.data![index].uid !=
                              FirebaseAuth.instance.currentUser?.uid
                          ? ListTile(
                              trailing: Text('5 km '),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                          selectedUserUID:
                                              snapshot.data![index].uid)),
                                );
                              },
                              leading:
                                  AvatarImage(uid: snapshot.data![index].uid),
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
