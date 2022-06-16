import 'package:chat_app/src/widgets/avatar.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  ChatTile(
      {Key? key,
      required this.title,
      required this.trailing,
      required this.subtitle,
      required this.profile})
      : super(key: key);
  Widget title;
  Widget subtitle;
  Widget trailing;
  AvatarImage profile;
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          profile,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  subtitle,
                ],
              ),
            ),
          ),
          trailing
        ],
      ),
    );
  }
}
