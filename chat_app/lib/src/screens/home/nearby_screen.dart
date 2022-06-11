// ignore_for_file: prefer_const_constructors

import 'package:chat_app/src/models/chat_user_model.dart';
import 'package:chat_app/src/screens/home/chats_screen%20copy.dart';
import 'package:chat_app/src/widgets/avatar.dart';
import 'package:chat_app/src/widgets/search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../controllers/geolocation_controller.dart';
import '../../models/chat_user_model.dart';

class NearbyScreen extends StatefulWidget {
  NearbyScreen({Key? key}) : super(key: key);

  @override
  State<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  bool isSwitched = false;
  Position? lastKnownPosition, currentPosition;
  final GeolocationController geoCon = GeolocationController();

  @override
  dispose() {
    geoCon.dispose();
    super.dispose();
  }

  // late Future<List<ChatUser>> gettingUsers;
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
                  child: Switch(
                    value: isSwitched,
                    onChanged: (value) async {
                      if (value) {
                        print(isSwitched);
                        geoCon.enableGeolocationStream();
                        currentPosition = await geoCon.getCurrentPosition();
                        print("lat");
                        print(currentPosition?.latitude);
                        print("long");
                        print(currentPosition?.longitude);
                      } else {
                        print(isSwitched);
                        geoCon.disableGeolocationStream();
                        currentPosition = await geoCon.getCurrentPosition();
                        print("lat");
                        print(currentPosition?.latitude);
                        print("long");
                        print(currentPosition?.longitude);
                      }
                      setState(() {
                        isSwitched = value;
                      });
                    },
                    // activeTrackColor: Theme.of(context).colorScheme.primary,
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
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
              // showUserList(),
              // AnimatedBuilder(
              //   animation: geoCon,
              //   builder: (context, snapshot) {
              //     print("rebuild");
              //     print(currentPosition?.latitude);
              //     return Column(
              //       children: [
              //         Text(geoCon.currentPosition?.latitude.toString() ??
              //             "null"),
              //         Text(geoCon.currentPosition?.longitude.toString() ??
              //             "null"),
              //       ],
              //     );
              //   },
              // ),
              AnimatedBuilder(
                animation: geoCon,
                builder: (context, Widget? child) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Text(
                      //   geoCon.currentPosition != null
                      //       ? geoCon.currentPosition.toString()
                      //       : 'aww gi off, batia',
                      //   textAlign: TextAlign.center,
                      // ),
                      if (geoCon.currentPosition != null)
                        // FutureBuilder(
                        //   future: placemarkFromCoordinates(
                        //       geoCon.currentPosition!.latitude,
                        //       geoCon.currentPosition!.longitude),
                        //   builder:
                        //       (context, AsyncSnapshot<List<Placemark>> snap) {
                        //     if (snap.hasData) {
                        //       return Text('${snap.data!.first}');
                        //     }
                        //     return Container();
                        //   },
                        // ),
                        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection('locations')
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snap) {
                            if (snap.hasData) {
                              if (geoCon.center == null) {
                                return CircularProgressIndicator();
                              }
                              // for (DocumentSnapshot doc in snap.data!.docs) {
                              //   FutureBuilder(
                              //       future: ChatUser.fromUid(uid: doc.id),
                              //       builder: (context, snapshot) {
                              //         if (!snapshot.hasData) {
                              //           return CircularProgressIndicator();
                              //         }

                              //         return ListTile(
                              //           leading: AvatarImage(uid: doc.id),
                              //           title: Text(
                              //             snapshot.data!.toString(),
                              //           ),
                              //           subtitle: null,
                              //         );
                              //       });
                              // }

                              return SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    for (var doc in snap.data!.docs)
                                      if (doc['isEnable'])
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
                                                leading:
                                                    AvatarImage(uid: doc.id),
                                                title: Text(
                                                  snapshot.data!.username,
                                                ),
                                                trailing: Text(
                                                    geoCon.parseLocation(doc)),
                                              );
                                            })
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

  Expanded showUserList() {
    getUsers ??= ChatUser.getUsers();
    return Expanded(
      child: FutureBuilder<List<ChatUser>>(
          future: getUsers,
          builder: (
            BuildContext context,
            AsyncSnapshot<List<ChatUser>> snapshot,
          ) {
            if (!snapshot.hasData) {
              return SizedBox();
            }
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return !isSwitched
                      ? SizedBox()
                      : snapshot.data![index].uid !=
                              FirebaseAuth.instance.currentUser?.uid
                          ? ListTile(
                              trailing: Text('5 km '),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                          selectedUserUID:
                                              snapshot.data![index].uid)),
                                );
                              },
                              leading:
                                  AvatarImage(uid: snapshot.data![index].uid),
                              title: Text(
                                snapshot.data![index].username,
                              ),
                              subtitle: null,
                            )
                          : SizedBox();
                });
          }),
    );
  }

  // String parseLocation(DocumentSnapshot doc) {
  //   Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
  //   GeoPoint point = json['position']['geopoint'];
  //   return '${json['name']}: [${point.latitude},${point.longitude}] - ${Geolocator.distanceBetween(
  //     center.latitude,
  //     center.longitude,
  //     point.latitude,
  //     point.longitude,
  //   ).toStringAsFixed(2)}m';
  // }
  ListTile newGroupChat(BuildContext context) {
    return ListTile(
      onTap: () {
        // _chatController.sendFirstMessage(
        //     "test", _auth.currentUser!.uid, 'private');
        // print("DONE");
      },
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
