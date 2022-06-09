import 'package:chat_app/src/controllers/auth_controller.dart';
import 'package:chat_app/src/models/chat_user_model.dart';
import 'package:chat_app/src/service_locators.dart';
import 'package:chat_app/src/services/image_service.dart';
import 'package:chat_app/src/widgets/avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                profilePic(context),
                userName(context),
                Text(
                  user?.email ?? '...',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  user?.age ?? '...',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  user?.gender ?? '...',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                 Text(
                  ',,,',//  DateFormat("MM:dd:yyyy").format(user.created.toDate()),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
               
              ],
            ),
          ),
        ),
      ),
    );
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
            width: 200,
            height: 200,
            child: AvatarImage(uid: FirebaseAuth.instance.currentUser!.uid),
          ),
          Positioned(
            right: 10,
            bottom: 0,
            child: InkWell(
              onTap: () {
                ImageService.updateProfileImage();
              },
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: const Icon(
                  Icons.camera_alt,
                  size: 25,
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

