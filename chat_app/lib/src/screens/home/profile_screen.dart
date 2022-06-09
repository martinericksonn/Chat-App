// ignore_for_file: prefer_const_constructors

import 'package:chat_app/src/controllers/auth_controller.dart';
import 'package:chat_app/src/models/chat_user_model.dart';
import 'package:chat_app/src/service_locators.dart';
import 'package:chat_app/src/services/image_service.dart';
import 'package:chat_app/src/widgets/avatar.dart';
import 'package:chat_app/src/widgets/profile_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController _auth = locator<AuthController>();
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
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   systemNavigationBarIconBrightness:
    //       Theme.of(context).scaffoldBackgroundColor.computeLuminance() > 0.5
    //           ? Brightness.dark
    //           : Brightness.light,
    //   statusBarIconBrightness:
    //       Theme.of(context).scaffoldBackgroundColor.computeLuminance() > 0.5
    //           ? Brightness.dark
    //           : Brightness.light,
    //   systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
    //   statusBarColor: Theme.of(context).scaffoldBackgroundColor,
    //   //color set to transperent or set your own color
    // ));
    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              profilePic(context),
              userName(context),
              emailCard(),
              ageCard(),
              genderCard(),
              dateJoinedCard(),
              ListTile(
                title: Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(Icons.dark_mode_rounded),
                ),
                title: Text(
                  "Theme",
                  style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500,
                    // color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(Icons.block_outlined),
                ),
                title: Text(
                  "Block User",
                  style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500,
                    // color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(Icons.login_rounded),
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500,
                    // color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              //mo error ang date joined
              // Text(
              //   DateFormat("MM:dd:yyyy").format(user!.created.toDate()),
              //   style: Theme.of(context).textTheme.titleLarge,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  ProfileCard dateJoinedCard() {
    return const ProfileCard(
        icon: Icons.date_range, text: 'Date Joined', text2: '...');
  }

  ProfileCard emailCard() {
    return ProfileCard(
        icon: Icons.email, text: 'Email', text2: user?.email ?? '...');
  }

  ProfileCard ageCard() {
    return ProfileCard(
        icon: Icons.numbers, text: 'Age', text2: user?.age ?? '...');
  }

  ProfileCard genderCard() {
    return ProfileCard(
        icon: Icons.arrow_drop_down,
        text: 'Gender',
        text2: user?.gender ?? '...');
  }

  Padding userName(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text(
        user?.username ?? '...',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Padding profilePic(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Stack(
        children: [
          SizedBox(
            width: 180,
            height: 180,
            child: AvatarImage(uid: FirebaseAuth.instance.currentUser!.uid),
          ),
          Positioned(
            right: 15,
            bottom: 0,
            child: InkWell(
              onTap: () {
                ImageService.updateProfileImage();
              },
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: const Icon(
                  Icons.camera_alt,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
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
        "Profile",
        style: Theme.of(context).textTheme.titleLarge,
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.edit),
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }
}
