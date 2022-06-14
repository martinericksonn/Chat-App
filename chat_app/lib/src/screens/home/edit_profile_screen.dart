import 'package:flutter/material.dart';
 

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: appBar(),
      body: const SafeArea(
        child: Text("Welcome to Edit Profile")
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
}