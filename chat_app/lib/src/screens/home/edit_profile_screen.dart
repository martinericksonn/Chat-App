// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:chat_app/src/controllers/user_settings_controller.dart';
import 'package:chat_app/src/widgets/avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/image_service.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key? key, required this.uid}) : super(key: key);
  String uid;
  @override
  State<EditProfile> createState() => _EditProfileState();
}
final _formKey = GlobalKey<FormState>();

final TextEditingController _unCon = TextEditingController();
final FocusNode _messageFN = FocusNode();


class _EditProfileState extends State<EditProfile> {
  String get uid => widget.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            profilePic(context),
             
            lowerBody(context),
          ],
        ),
      ),
    );
  }

  Padding lowerBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .98,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                title(),
                usernameTextField(context),
              ],
            ),
            submitButton(context),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
            )
          ],
        ),
      ),
    );
  }

  Container title() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Text(
            "Change username",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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
                child: Icon(
                  Icons.camera_alt,
                  size: 30,
                  color: Theme.of(context).scaffoldBackgroundColor,
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
        "Edit Profile",
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Container usernameTextField(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              // width: isUsernameEmpty ? 2.0 : 1.0,
            ), // set
            // color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(20)),
        child: TextFormField(
          maxLength: 20,
          controller: _unCon,
          focusNode: _messageFN,
          // validator: (value) {
          //   if(value.isEmpty && value.)
          //   return null;
          // },
          style: const TextStyle(fontWeight: FontWeight.bold),
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: 'Username',
            // hintStyle: TextStyle(
            //     color: isUsernameEmpty
            //         ? Colors.red
            //         : Theme.of(context).colorScheme.primary),
            contentPadding:
                EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
          ),
        ));
  }

  Widget submitButton(BuildContext context) {
    return Container(
      // color: Colors.red,
      width: 320,
      height: 68,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(50)),
      child: TextButton(
        onPressed: () {
          if (_unCon.text != '') {
            UserSettingsController.changeUsername(
                uid: uid, username: _unCon.text.trim());
            Navigator.of(context).pop();
          }
        },
        child: Center(
          child: Text(
            "Save",
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).scaffoldBackgroundColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ),
    );
  }

}
