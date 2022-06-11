// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  final IconData? icon;
  final String title, subtitle;

  @override
  Widget build(BuildContext context) {
    return profileCard(context);
  }

  Card profileCard(BuildContext context) {
    return Card(
      // elevation: 8.0,
      margin: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 6.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Theme.of(context).colorScheme.primary,
      child: ListTile(
        // contentPadding: const EdgeInsets.symmetric(
        //   horizontal: 15.0,
        //   vertical: 5.0,
        // ),
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Container(
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
              // size: 30,
            ),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).scaffoldBackgroundColor,
            // fontSize: 20,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      ),
    );
  }

  Widget alternative(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          icon,
        ),
      ),
      title: Text(
        title,
      ),
      subtitle: Text(
        subtitle,
      ),
    );
  }

  Widget cardTitle(int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          CircleAvatar(
            child: SizedBox(
              height: 70,
              child: Icon(Icons.person),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Title",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    "Subtitle",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
            ),
          ),
          Text("Trailing"),
        ],
      ),
    );
  }
}
