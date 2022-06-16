// ignore_for_file: prefer_const_constructors

import 'package:chat_app/src/controllers/auth_controller.dart';
import 'package:chat_app/src/models/chat_list_model.dart';
import 'package:chat_app/src/models/chat_user_model.dart';
import 'package:chat_app/src/screens/home/chats_screen%20copy.dart';
import 'package:chat_app/src/screens/home/new_message.dart';
import 'package:chat_app/src/screens/home/chats_private.dart';
import 'package:chat_app/src/screens/home/nearby_screen.dart';
import 'package:chat_app/src/screens/home/profile_screen_current.dart';
import 'package:chat_app/src/widgets/avatar.dart';
import 'package:chat_app/src/widgets/chat_tiles.dart';
import 'package:chat_app/src/widgets/search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../controllers/chat_list_controller.dart';
import '../../controllers/geolocation_controller.dart';
import '../../models/chat_user_model.dart';
import '../../service_locators.dart';
import '../../settings/settings_controller.dart';
import 'chats_global.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  static const String route = 'home-screen';
  HomeScreen({Key? key, required this.settingsController}) : super(key: key);
  SettingsController settingsController;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SettingsController get settingsController => widget.settingsController;
  final AuthController _auth = locator<AuthController>();
  final ChatListController _chatListController = ChatListController();
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFN = FocusNode();
  late GeolocationController geoCon;
  ChatUser? user;

  @override
  void initState() {
    super.initState();
    ChatUser.fromUid(uid: _auth.currentUser?.uid ?? "").then((value) {
      if (mounted) {
        setState(() {
          user = value;
          geoCon = GeolocationController(value.uid);
        });
      }
    });
  }

  @override
  void dispose() {
    geoCon.dispose();
    _messageFN.dispose();
    _messageController.dispose();
    _chatListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder:
            (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap) {
          if (!snap.hasData) {
            print("no");
            return Center(child: CircularProgressIndicator());
          }
          List<dynamic> blocklist = [];
          for (var doc in snap.data!.docs) {
            blocklist.addAll(doc["blocklistedme"]);
            blocklist.addAll(doc["blocklist"]);
            print(blocklist);
          }
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: appBar(blocklist),
            body: body(context, blocklist),
            floatingActionButton: floatingButton(context, blocklist),
          );
        });
  }

  FloatingActionButton floatingButton(BuildContext context, blocklist) {
    return FloatingActionButton.extended(
      backgroundColor: Theme.of(context).colorScheme.primary,
      onPressed: () => {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NearbyScreen(
              geoCon: geoCon,
              blocklist: blocklist,
            ),
          ),
        )
      },
      label: Text("Find Nearby",
          style: Theme.of(context).textTheme.headlineMedium),
    );
  }

  SizedBox body(BuildContext context, List<dynamic> blocklist) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Searchbar(blocklist: blocklist),
              globalChat(context),
              // Divider(
              //   color: Theme.of(context).colorScheme.tertiary,
              // ),
              messageList(blocklist),
            ],
          ),
        ),
      ),
    );
  }

//AsyncSnapshot<dynamic> snapshot
  Widget messageList(List<dynamic> blocklist) {
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
                : bodyWithMessage(blocklist),
          ),
        ),

        // ),
      ],
    );
  }

  Widget bodyNoMessage() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          ChatUser.fromUid(uid: _auth.currentUser?.uid ?? "").then((value) {
            user = value;
          });
        });
      },
      child: Center(
        child: Column(children: [
          Image.asset("assets/images/home_empty.png", width: 300),
          Text("Create your first message on Tabi or"),
          SizedBox(height: 2),
          Text("invite your friends and enjoy Tabi-Tabi together"),
        ]),
      ),
    );
  }

  Widget bodyWithMessage(List<dynamic> blocklist) {
    return AnimatedBuilder(
        animation: _chatListController,
        builder: (context, snapshot) {
          return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              reverse: true,
              shrinkWrap: true,
              itemCount: _chatListController.chats.length,
              itemBuilder: (context, index) {
                var chatFriends = _chatListController.extractUID(
                    _chatListController.chats[index].uid,
                    FirebaseAuth.instance.currentUser!.uid);
                if (user == null) {
                  return CircularProgressIndicator();
                }
                if (_chatListController.chats[index].uid !=
                        FirebaseAuth.instance.currentUser!.uid &&
                    !blocklist.contains(chatFriends)) {
                  return FutureBuilder<ChatUser>(
                      future: ChatUser.fromUid(uid: chatFriends),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return SizedBox(
                            child: CircleAvatar(
                                child: CircularProgressIndicator()),
                          );
                        }

                        return Container(
                          child: messageListTile(context,
                              _chatListController.chats[index], snapshot),
                        );
                      });
                }
                return SizedBox();
              });
        });
  }

  String formatDateReceived(ChatList chatList) {
    if (chatList.ts
            .toDate()
            .compareTo(DateTime.now().subtract(Duration(days: 1))) ==
        -1) {
      if (chatList.ts
              .toDate()
              .compareTo(DateTime.now().subtract(Duration(days: 7))) ==
          -1) {
        return DateFormat("d MMM").format(chatList.ts.toDate());
      } else {
        return DateFormat.EEEE().format(chatList.ts.toDate());
      }
    } else {
      return DateFormat("hh:mm aaa").format(chatList.ts.toDate());
    }
  }

  ListTile messageListTile(BuildContext context, ChatList chatList,
      AsyncSnapshot<ChatUser> chatUser) {
    return ListTile(
        onTap: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      ChatScreenPrivate(selectedUserUID: chatUser.data!.uid),
                ),
              )
            },
        subtitle: Text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            chatList.sentBy == user!.uid
                ? "You: " +
                    (chatList.isDeleted ? "message deleted" : chatList.message)
                : (chatList.isDeleted ? "message deleted" : chatList.message),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: chatList.seenBy.contains(user!.uid)
                  ? FontWeight.normal
                  : FontWeight.bold,
            )),
        leading: AvatarImage(
          uid: chatUser.data!.uid,
          radius: 40,
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formatDateReceived(chatList),
              style: TextStyle(
                fontWeight: chatList.seenBy.contains(user!.uid)
                    ? FontWeight.normal
                    : FontWeight.bold,
              ),
            ),
            chatList.seenBy.contains(user!.uid)
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      Icons.fiber_manual_record_rounded,
                      size: 15,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
          ],
        ));
  }

  Widget globalChat(
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: ListTile(
        onTap: () => {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GlobalChat(),
            ),
          )
        },
        leading: FittedBox(
          // color: Colors.red,

          child: CircleAvatar(
            radius: 40,
            child: Image.asset("assets/images/tabi_lightmode.png"),
            backgroundColor: Colors.transparent,
            // backgroundImage:  DecorationImage(image: NetworkImage("urlImage"),

            // backgroundImage: ,
          ),
        ),
        title: Text(
          "Tabi-Tabi Global",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            // color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ),
    );
  }

  AppBar appBar(blocklist) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      automaticallyImplyLeading: false,
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
                    builder: (context) => ProfileScreen(
                      settingsController: settingsController,
                      geoCon: geoCon,
                    ),
                  ),
                );
              },
              child: SizedBox(
                child: AvatarImage(
                  uid: FirebaseAuth.instance.currentUser!.uid,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Flexible(
            child: Text(
              user?.username ?? '...',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NewMessage(
                  blocklist: blocklist,
                ),
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
