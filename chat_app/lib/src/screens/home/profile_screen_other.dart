// ignore_for_file: prefer_const_constructors

import 'package:chat_app/src/controllers/user_settings_controller.dart';
import 'package:chat_app/src/models/chat_user_model.dart';
import 'package:chat_app/src/screens/home/home_screen.dart';
import 'package:chat_app/src/widgets/avatar.dart';
import 'package:chat_app/src/widgets/profile_card.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ProfileScreenOther extends StatefulWidget {
  ProfileScreenOther({Key? key, required this.selectedUser}) : super(key: key);
  String selectedUser;
  @override
  State<ProfileScreenOther> createState() => _ProfileScreenOtherState();
}

// if private account hide info

class _ProfileScreenOtherState extends State<ProfileScreenOther> {
  String get selectedUser => widget.selectedUser;
  UserSettingsController userSC = UserSettingsController();
  ChatUser? user;
  @override
  void initState() {
    ChatUser.fromUid(uid: selectedUser).then((value) {
      if (mounted) {
        setState(() {
          user = value;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                profilePic(context),
                spacer(context),
                if (!(user?.isPrivate ?? true))
                  Column(
                    children: [
                      usernameCard(),
                      ageCard(),
                      genderCard(),
                      dateJoinedCard(),
                    ],
                  )
                else
                  SizedBox(
                    child: Text("Account is Private"),
                  ),
                blockedUser(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container blockedUser(BuildContext context) {
    return Container(
        alignment: FractionalOffset.bottomCenter,
        child: TextButton(
          onPressed: () {
            UserSettingsController.blockUser(user!.uid);
            Navigator.popUntil(
              context,
              ModalRoute.withName('/'),
            );
          },
          child: Text(
            "Block User",
            style: TextStyle(color: Colors.red),
          ),
        )
        //  ListTile(
        //   title: Text("Block User"),
        // ),
        );
  }

  ProfileCard usernameCard() {
    return ProfileCard(
        icon: Icons.account_circle_rounded,
        title: 'Username',
        subtitle: user?.username ?? '...');
  }

  ProfileCard dateJoinedCard() {
    return const ProfileCard(
        icon: Icons.date_range, title: 'Date Joined', subtitle: '...');
  }

  ProfileCard emailCard() {
    return ProfileCard(
        icon: Icons.email, title: 'Email', subtitle: user?.email ?? '...');
  }

  ProfileCard ageCard() {
    return ProfileCard(
        icon: Icons.calendar_month, title: 'Age', subtitle: user?.age ?? '...');
  }

  ProfileCard genderCard() {
    return ProfileCard(
        icon: Icons.animation,
        title: 'Gender',
        subtitle: user?.gender ?? '...');
  }

  Widget spacer(BuildContext context) {
    return SizedBox(height: 30);
  }

  Padding profilePic(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Stack(
        children: [
          SizedBox(
            width: 180,
            height: 180,
            child: AvatarImage(uid: selectedUser),
          ),
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: Text(
        'User Info',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
