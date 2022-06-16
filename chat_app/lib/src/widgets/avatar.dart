// ignore_for_file: prefer_const_constructors

import 'package:chat_app/src/models/chat_user_model.dart';
import 'package:flutter/material.dart';

class AvatarImage extends StatelessWidget {
  final String uid;
  final double radius;
  const AvatarImage({required this.uid, this.radius = 22, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ChatUser>(
        stream: ChatUser.fromUidStream(uid: uid),
        builder: (context, AsyncSnapshot<ChatUser?> snap) {
          if (snap.error != null || !snap.hasData) {
            // print('1');
            return tempProfile(context);
          } else {
            // print('2');
            if (snap.data!.image.isEmpty) {
              return tempProfile(context);
            } else if (snap.connectionState == ConnectionState.waiting) {
              // print('3');
              return tempProfile(context);
            } else {
              // print('4');
              return FittedBox(
                child: CircleAvatar(
                  radius: radius,
                  backgroundImage: NetworkImage(snap.data!.image),
                ),
              );
            }
          }
        });
  }

  Widget tempProfile(BuildContext context) {
    return FittedBox(
      // color: Colors.red,

      child: CircleAvatar(
        radius: radius,
        child: Icon(
          Icons.person_rounded,
          size: radius,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        // backgroundImage: ,
      ),
    );
  }
}
