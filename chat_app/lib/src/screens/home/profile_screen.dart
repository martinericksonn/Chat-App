import 'package:chat_app/src/services/image_service.dart';
import 'package:chat_app/src/widgets/avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
      appBar: appBar(),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 200,
            height: 200,
            child: InkWell(
              onTap: () {
                ImageService.updateProfileImage();
              },
              child: SizedBox(
                  child:
                      AvatarImage(uid: FirebaseAuth.instance.currentUser!.uid)),
            ),
          ),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      elevation: 0,
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
