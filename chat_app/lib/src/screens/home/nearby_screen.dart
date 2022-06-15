// ignore_for_file: prefer_const_constructors

import 'package:chat_app/src/models/chat_user_model.dart';
import 'package:chat_app/src/screens/home/chats_screen%20copy.dart';
import 'package:chat_app/src/widgets/avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../controllers/geolocation_controller.dart';
import '../../models/chat_user_model.dart';

class NearbyScreen extends StatefulWidget {
  NearbyScreen({Key? key, required this.geoCon}) : super(key: key);
  final GeolocationController geoCon;
  @override
  State<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  bool isSwitched = false;
  Position? lastKnownPosition, currentPosition;
  GeolocationController get geoCon => widget.geoCon;

  @override
  void initState() {
    // isSwitched = currentPosition != null;
    // TODO: implement initState
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Find Nearby',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              ListTile(
                title: Text(
                  "Enable Feature",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                      "With on device location, geocoding and geolocator, find nearby allows you to find people near you"),
                ),
                trailing: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: AnimatedBuilder(
                      animation: geoCon,
                      builder: (context, Widget? child) {
                        return Switch(
                          value: geoCon.currentPosition != null,
                          onChanged: (value) async {
                            if (geoCon.currentPosition == null) {
                              await geoCon.enableGeolocationStream();
                              await geoCon.getCurrentPosition().then((value) {
                                currentPosition = value;

                                // print(value);
                              });
                            } else {
                              await geoCon.disableGeolocationStream();
                              await geoCon.getCurrentPosition().then((value) {
                                currentPosition = value;
                              });
                            }

                            setState(() {});
                          },
                          activeColor: Theme.of(context).colorScheme.primary,
                        );
                      }),
                ),
              ),
              ListTile(
                title: Text(
                  "Tabians near you",
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: geoCon,
                builder: (context, Widget? child) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (geoCon.currentPosition != null)
                        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection('locations')
                              .where('isEnable', isEqualTo: true)
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snap) {
                            if (snap.hasData) {
                              if (geoCon.center == null) {
                                return CircularProgressIndicator();
                              }
                              // print("snap.data!.docs.length");
                              // print(snap.data!.docs.length);
                              return SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    if (snap.data!.docs.length == 1)
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            // alignment: Alignment.center,
                                            // padding: EdgeInsets.only(top: 18.0),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.34,
                                            child: Image(
                                              image: AssetImage(
                                                  "assets/images/location.png"),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Currently no Tabians nearby",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                          )
                                        ],
                                      )
                                    else
                                      for (var doc in snap.data!.docs)
                                        if (doc['isEnable'] &&
                                            doc['userUID'] !=
                                                FirebaseAuth
                                                    .instance.currentUser!.uid)
                                          FutureBuilder(
                                            future:
                                                ChatUser.fromUid(uid: doc.id),
                                            builder: (context,
                                                AsyncSnapshot<ChatUser>
                                                    snapshot) {
                                              // print( snapshot.data.);
                                              if (!snapshot.hasData) {
                                                return CircularProgressIndicator();
                                              }

                                              return ListTile(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ChatScreen(
                                                                selectedUserUID:
                                                                    snapshot
                                                                        .data!
                                                                        .uid)),
                                                  );
                                                },
                                                leading:
                                                    AvatarImage(uid: doc.id),
                                                title: Text(
                                                  snapshot.data!.username,
                                                ),
                                                trailing: Text(
                                                    geoCon.parseLocation(doc)),
                                              );
                                            },
                                          )
                                  ],
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  // ignore: prefer_typing_uninitialized_variables
  var getUsers;

  ListTile newGroupChat(BuildContext context) {
    return ListTile(
      onTap: () {},
      leading: CircleAvatar(
        child: Icon(Icons.group_rounded),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        "Create a group chat",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
