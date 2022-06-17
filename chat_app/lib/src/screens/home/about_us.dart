// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:chat_app/src/widgets/avatar.dart';
import 'package:flutter/material.dart';

class AboutTabiScreen extends StatelessWidget {
  AboutTabiScreen({Key? key}) : super(key: key);

// final ChatUser chatUser;
  var textStyle = TextStyle(
    // fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Center(
        child: Container(
          // color: Colors.red,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  profilePic(context),
                  title(context),
                  SizedBox(
                    height: 30,
                  ),
                  theDevelopers(context),
                ],
              ),
              footer(),

              // lowerBody(context),
            ],
          ),
        ),
      ),
    );
  }

  Padding footer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Text(
            "© Tabi-Tabi 2022",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          Text(
            "Mobile Application Development 2 - Final Project ",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Padding theDevelopers(context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          // Text(
          //   "The Developers:",
          //   style: TextStyle(
          //     color: Theme.of(context).colorScheme.secondary,
          //     fontWeight: FontWeight.w500,
          //     fontSize: 16,
          //   ),
          // ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: [
              AvatarImage(
                uid: "mWvWyIwldUXrUzaSjeVV5X2FAqk2",
                radius: 50,
              ),
              SizedBox(
                height: 10,
              ),
              Text("Martin Erickson Lapetaje", style: textStyle),
              Text("BSCS-3"),
            ],
          ),

          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    AvatarImage(
                      uid: "7Zmz2iboQkX9Fsye9tNS7QYhVJx1",
                      radius: 50,
                    ),
                    // CircleAvatar(
                    //   radius: 50,
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Franz Lesly Rocha", style: textStyle),
                    Text("BSIT-3"),
                  ],
                ),
                Column(
                  children: [
                    AvatarImage(
                      uid: "Eko5ToDMmWg3Tsl8QiA7BUHqhuK2",
                      radius: 50,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("John Lloyde Quizeo", style: textStyle),
                    Text(
                      "BSIT-3",
                    ),
                  ],
                ),
              ],
            ),
          ),

          // SizedBox(
          //   height: 3,
          // ),
          // Text("Franz Lesly Rocha, BSIT-3", style: textStyle),
          // SizedBox(
          //   height: 1,
          // ),
          // Text("Martin Erickson Lapetaje, BSCS-3", style: textStyle),
          // SizedBox(
          //   height: 1,
          // ),
          // Text("John Lloyde Quizeo, BSIT-3", style: textStyle),
          // SizedBox(
          //   height: 100,
          // ),

          // Text("2022"),
        ],
      ),
    );
  }

  // Padding lowerBody(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 28.0),
  //     child: Center(
  //       child: SizedBox(

  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             Column(
  //               children: [
  //                 title(),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Column title(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        Text(
          "Tabi Tabi",
          style: TextStyle(
            fontSize: 26,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Padding profilePic(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: SizedBox(
        width: 180,
        height: 180,
        child: FittedBox(
          // color: Colors.red,

          child: CircleAvatar(
            radius: 40,
            child: Image.asset("assets/images/tabi_lightmode.png"),
            backgroundColor: Colors.transparent,
            // backgroundImage:  DecorationImage(image: NetworkImage("urlImage"),

            // backgroundImage: ,
          ),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
    );
  }
}
