// ignore_for_file: prefer_const_constructors

import 'package:chat_app/src/controllers/auth_controller.dart';
import 'package:chat_app/src/controllers/chat_controller.dart';
import 'package:chat_app/src/models/chat_user_model.dart';
import 'package:chat_app/src/screens/create_message/new_message.dart';
import 'package:chat_app/src/screens/home/chats_screen%20copy.dart';
import 'package:chat_app/src/screens/home/chats_screen.dart';
import 'package:chat_app/src/services/image_service.dart';
import 'package:chat_app/src/widgets/avatar.dart';
import 'package:chat_app/src/widgets/search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final ChatController _chatController = ChatController();

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
        onPressed: () => {},
        label: Text("Find Nearby",
            style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }

  SizedBox body(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Searchbar(),
          FutureBuilder<dynamic>(
            future: _chatController.fetchChatrooms(), // async work
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Text('Loading....');
                default:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Column(
                      children: [
                        // SizedBox(
                        //   height: 500,
                        //   child:
                        //       ListView.builder(itemBuilder: (context, index) {
                        //     return SizedBox();
                        //   }),
                        // ),
                        for (ChatUser user in snapshot.data)
                          if (user.uid !=
                              FirebaseAuth.instance.currentUser!.uid)
                            Container(
                              margin: EdgeInsets.all(5),
                              child: ListTile(
                                onTap: () => {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChatScreen(selectedUser: user),
                                    ),
                                  )
                                },
                                // subtitle: Text('data'),
                                leading: AvatarImage(
                                  uid: user.uid,
                                ),
                                title: Text(
                                  user.username,
                                ),
                                trailing: Text(DateFormat("hh:mm aaa")
                                    .format(DateTime.now())),
                              ),
                            ),
                      ],
                    );
                  }
              }
            },
          ),
          IconButton(
            onPressed: () {
              _auth.logout();
            },
            icon: const Icon(Icons.logout_rounded),
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }

  ListTile chatTile(BuildContext context) {
    return ListTile(
      onTap: () => {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GlobalChat(),
          ),
        )
      },
      leading: SizedBox(
        // color: Colors.red,
        height: 50,
        width: 50,
        child: CircleAvatar(
          child: Icon(Icons.message_rounded),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      ),
      title: Text(
        "Tabi-Tabi",
      ),
      subtitle: Container(
        child: Text(
          "subtitlsssssssssssssse",
          overflow: TextOverflow.ellipsis,
        ),
      ),
      trailing: Text(DateFormat("hh:mm aaa").format(DateTime.now())),
    );
  }

  Padding searchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        height: 42,
        width: MediaQuery.of(context).size.width / 1.1,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.circular(50)),
        child: TextButton(
          onPressed: () {},
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                SizedBox(
                  width: 5,
                ),
                Icon(Icons.search_rounded),
                SizedBox(
                  width: 5,
                ),
                Text('Search'),
              ],
            ),
          ),
        ),
      ),
    );
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
                ImageService.updateProfileImage();
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
