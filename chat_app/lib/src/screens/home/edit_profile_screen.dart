import 'package:chat_app/src/models/chat_user_model.dart';
import 'package:chat_app/src/widgets/avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/image_service.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

  final TextEditingController _unCon = TextEditingController();
  final FocusNode _messageFN = FocusNode();
  // final ChatUser chatUser;

class _EditProfileState extends State<EditProfile> {

 
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
           height: MediaQuery.of(context).size.height * .75,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              usernameTextField(context),
              submitButton(context),
            ],
          ),
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
          controller: _unCon,
          focusNode: _messageFN,
          // validator: (value) {
          //   setState(() {
          //     isUsernameEmpty = (value == null || value.isEmpty) ? true : false;
          //   });
          //   return null;
          // },
          style: const TextStyle(fontWeight: FontWeight.bold),
          decoration: const InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            // hintStyle: TextStyle(
            //     color: isUsernameEmpty
            //         ? Colors.red
            //         : Theme.of(context).colorScheme.primary),
            hintText: "Username",
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
            // if (_unCon.text != '')
            //         {
            //          chatUser.updateUsername(_unCon.text);
            //           Navigator.of(context).pop();
            //         }
        },
        child: Center(
          child: Text(
            "Submit",
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
