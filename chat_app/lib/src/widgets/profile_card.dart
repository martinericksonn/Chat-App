import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.text2,
  }) : super(key: key);

  final IconData? icon;
  final String text, text2;

  @override
  Widget build(BuildContext context) {
    return Container(
        // padding: const EdgeInsets.symmetric(
        //   vertical: 7,
        //   horizontal: 15,
        // ),
        child: Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 6.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Theme.of(context).colorScheme.primary,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 5.0,
        ),
        leading: Container(
          padding: const EdgeInsets.only(right: 12.0),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                width: 1.0,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).scaffoldBackgroundColor,
            size: 30,
          ),
        ),
        title: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).scaffoldBackgroundColor,
            fontSize: 20,
          ),
        ),
        subtitle: Text(
          text2,
          style: TextStyle(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      ),
    ));
  }
}
