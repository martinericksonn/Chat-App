// ignore_for_file: prefer_const_constructors
import 'package:chat_app/src/models/chat_user_model.dart';
import 'package:chat_app/src/screens/home/image_screen.dart';
import 'package:chat_app/src/widgets/avatar.dart';
import 'package:chat_app/src/widgets/bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../models/chat_message_model.dart';

// ignore: must_be_immutable
class ChatCard extends StatefulWidget {
  const ChatCard({
    Key? key,
    required this.index,
    required this.scrollController,
    required this.chatroom,
    required this.chat,
  }) : super(key: key);
  final ScrollController scrollController;
  final int index;
  final List<ChatMessage> chat;
  final String chatroom;

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  var isVisible = false;

  List<ChatMessage> get chat => widget.chat;
  ScrollController get scrollController => widget.scrollController;
  int get index => widget.index;
  String get chatroom => widget.chatroom;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        children: [
          Spacer(index: index),
          messageDate(context),
          messageBubble(context),
          messageSeen(context),
        ],
      ),
    );
    // );
  }

  Row messageBubble(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment:
          chat[index].sentBy == FirebaseAuth.instance.currentUser?.uid
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
      children: [
        // Text('asd'),
        editedLeft(context),
        messageBody(context),
        editedRight(context),
      ],
    );
  }

  Container messageBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: GestureDetector(
        onTap: () {
          // int num = 60;
          setState(() {
            // scrollBottom(isVisible ? -num : num);
            isVisible = !isVisible;
          });
        },
        onLongPress: () {
          chat[index].isDeleted
              ? null
              : chat[index].sentBy == FirebaseAuth.instance.currentUser?.uid
                  ? bottomModal(context, chatroom)
                  : null;
        },
        child: Column(
          crossAxisAlignment:
              chat[index].sentBy == FirebaseAuth.instance.currentUser?.uid
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          children: [
            if ((chat[index].sentBy !=
                    FirebaseAuth.instance.currentUser?.uid) &&
                (index == 0 || chat[index - 1].sentBy != chat[index].sentBy))
              FutureBuilder<ChatUser>(
                  future: ChatUser.fromUid(uid: chat[index].sentBy),
                  builder: (context, AsyncSnapshot<ChatUser> snap) {
                    if (!snap.hasData) {
                      return CircularProgressIndicator();
                    }
                    return Row(
                      children: [
                        SizedBox(
                            width: 30,
                            child: AvatarImage(uid: snap.data?.uid ?? "")),
                        Container(
                            padding:
                                EdgeInsets.only(left: 5, top: 5, bottom: 3),
                            child: Text(
                              '${snap.data?.username}',
                              style: Theme.of(context).textTheme.titleSmall,
                            )),
                      ],
                    );
                  }),
            if (chat[index].isDeleted)
              deletedMessage(context)
            else if (chat[index].isImage)
              imageMessage(context)
            else
              stringMessage(context),
          ],
        ),
      ),
    );
  }

  Container stringMessage(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.3),
      padding: const EdgeInsets.all(12),
      decoration: backgroundColor(context),
      // color: Colors.black,
      child: Text(
        overflow: TextOverflow.visible,
        chat[index].message,
        style: TextStyle(
            fontSize: 16,
            color: chat[index].isDeleted
                ? Theme.of(context).textTheme.titleMedium?.color
                : chat[index].sentBy == FirebaseAuth.instance.currentUser?.uid
                    ? Theme.of(context).scaffoldBackgroundColor
                    : Theme.of(context).colorScheme.onBackground),
      ),
    );
  }

  Container deletedMessage(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.3),
      padding: const EdgeInsets.all(12),
      decoration: backgroundColor(context),
      // color: Colors.black,
      child: Text(
        overflow: TextOverflow.visible,
        "message deleted",
        style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).textTheme.titleMedium?.color),
      ),
    );
  }

  GestureDetector imageMessage(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return ImageScreen(image: chat[index].image);
        }));
      },
      child: ClipRRect(
        // clipper: ,
        borderRadius: BorderRadius.circular(20.0),

        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 200.0,
            maxHeight: 200.0,
          ),
          child: Container(
              color:
                  chat[index].sentBy == FirebaseAuth.instance.currentUser?.uid
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.tertiary,
              // child: FittedBox(
              //     fit: BoxFit.fitWidth,
              child: Image(
                image: NetworkImage(
                  chat[index].image,
                  scale: 5,
                ),
              )
              //  PhotoView(
              //   imageProvider: NetworkImage(
              //     chat[index].image,
              //     scale: 5,
              //   ),
              // ),
              ),
        ),
      ),
      // ),
    );
  }

  BoxDecoration backgroundColor(BuildContext context) {
    return BoxDecoration(
      border: Border.all(
          color: chat[index].isDeleted
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent),
      borderRadius: BorderRadius.all(Radius.circular(20)),
      color: chat[index].isDeleted
          ? Colors.transparent
          : chat[index].sentBy == FirebaseAuth.instance.currentUser?.uid
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.tertiary,
    );
  }

  Visibility messageSeen(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Container(
        // color: Colors.pink,
        // padding: EdgeInsets.only(bottom: 2, top: 2),
        alignment: Alignment.center,
        width: double.infinity,
        // color: Colors.green,

        child: Container(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Row(
            mainAxisAlignment:
                chat[index].sentBy == FirebaseAuth.instance.currentUser?.uid
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
            children: [
              Text(
                chat[index].seenBy.length > 1 ? "Seen by " : "Sent",
                style: Theme.of(context).textTheme.bodySmall,
              ),

              for (String uid in chat[index].seenBy)
                FutureBuilder(
                    future: ChatUser.fromUid(uid: uid),
                    builder: (context, AsyncSnapshot snap) {
                      if (snap.hasData &&
                          chat[index].seenBy.length > 1 &&
                          snap.data?.uid !=
                              FirebaseAuth.instance.currentUser!.uid) {
                        return Container(
                            padding: EdgeInsets.symmetric(horizontal: 2),
                            width: 22,
                            child: AvatarImage(uid: snap.data?.uid));
                      }
                      return Text('');
                    }),
              // Text(
              //   DateFormat("MMM d, y hh:mm aaa")
              //       .format(chat[index].ts.toDate()),
              //   style: Theme.of(context).textTheme.bodySmall,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Visibility editedRight(BuildContext context) {
    return Visibility(
      visible: chat[index].isEdited
          ? chat[index].isDeleted
              ? false
              : chat[index].sentBy == FirebaseAuth.instance.currentUser?.uid
                  ? false
                  : true
          : false,
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Text(
          '(edited)',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }

  Visibility editedLeft(BuildContext context) {
    return Visibility(
      visible: chat[index].isEdited
          ? chat[index].isDeleted
              ? false
              : chat[index].sentBy == FirebaseAuth.instance.currentUser?.uid
          : false,
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Text(
          '(edited)',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }

  Visibility messageDate(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Container(
        // color: Colors.red,
        padding: EdgeInsets.only(bottom: 5, top: 15),
        alignment: Alignment.center,
        width: double.infinity,
        // color: Colors.green,
        child: Text(
          DateFormat("MMM d, y hh:mm aaa").format(chat[index].ts.toDate()),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }

  Future<dynamic> bottomModal(BuildContext context, chatroom) {
    return showMaterialModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: BottomSheetModal(
          chat: chat[index],
          chatroom: chatroom,
        ),
      ),
    );
  }
}

class Spacer extends StatelessWidget {
  const Spacer({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: index == 0,
        child: SizedBox(
          height: 10,
        ));
  }
}

// class DetailScreen extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Photo View Example App',

//       home: Scaffold(
//         body: HomeScreen(),
//       ),
//     );
//   }
// }