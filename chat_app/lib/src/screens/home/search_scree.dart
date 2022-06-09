import 'package:chat_app/src/models/chat_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/avatar.dart';
import 'chats_screen copy.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  // ignore: prefer_typing_uninitialized_variables
  var getUsers;

  @override
  Widget build(BuildContext context) {
    getUsers ??= ChatUser.getUsers();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).cardTheme.color,
        appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () => {},
                icon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
            backgroundColor: Colors.transparent,
            elevation: 0,
            // The search area here
            title: Center(
              child: TextField(
                autofocus: true,
                onSubmitted: (_textEditingController) {},
                controller: _textEditingController,
                onChanged: (text) {
                  setState(() {});
                  // if (text) print(text);
                },
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                // ignore: prefer_const_constructors
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  // ignore: prefer_const_constructors
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            )),
        body: SizedBox(
          child: FutureBuilder<List<ChatUser>>(
              future: getUsers,
              builder: (
                BuildContext context,
                AsyncSnapshot<List<ChatUser>> snapshot,
              ) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                }

                List<ChatUser> searchResult = [];
                if (_textEditingController.text.isNotEmpty) {
                  // snapshot.data!.toList().indexOf(_textEditingController.text)
                  for (var element in snapshot.data!) {
                    if (element.searchUsername(_textEditingController.text)) {
                      searchResult.add(element);
                    }
                  }

                  return searchResult.isEmpty
                      ? const Center(child: Text("No result found"))
                      : ListView.builder(
                          itemCount: searchResult.length,
                          itemBuilder: (context, index) {
                            return searchResult[index].uid !=
                                    FirebaseAuth.instance.currentUser?.uid
                                ? ListTile(
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) => ChatScreen(
                                                selectedUserUID:
                                                    searchResult[index].uid)),
                                      );
                                    },
                                    leading: AvatarImage(
                                        uid: searchResult[index].uid),
                                    title: Text(
                                      searchResult[index].username,
                                    ),
                                    subtitle: null,
                                  )
                                : SizedBox();
                          });
                  ;
                }
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return snapshot.data![index].uid !=
                              FirebaseAuth.instance.currentUser?.uid
                          ? ListTile(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
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
        ),
      ),
    );
  }
}
