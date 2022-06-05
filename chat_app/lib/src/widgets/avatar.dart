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
            return CircleAvatar(
              radius: radius,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: radius * .95,
              ),
            );
          } else {
            if (snap.data!.image.isEmpty) {
              return CircleAvatar(
                radius: radius,
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: radius * .95,
                ),
              );
            } else if (snap.connectionState == ConnectionState.waiting) {
              return CircleAvatar(
                  radius: radius,
                  backgroundColor: Colors.grey,
                  child: const CircularProgressIndicator());
            } else {
              return CircleAvatar(
                radius: radius,
                backgroundImage: NetworkImage(snap.data!.image),
              );
            }
          }
        });
  }
}
