import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';

class GeolocationController with ChangeNotifier {
  bool serviceEnabled = false;
  double distanceInKm = 5;
  LocationPermission? permission;
  StreamSubscription<Position>? positionStream;
  Position? currentPosition;
  String userUID;
  GeolocationController(this.userUID) {
    checkPermissions().onError((error, stackTrace) {
      print(error);
    });
    // Test if location services are enabled.
  }

  @override
  dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  final Geoflutterfire geo = Geoflutterfire();
  //Fuente Circle
  GeoFirePoint? center;

  ///so I would suggest adding a listener to store the data in a controller when the data is updated.
  ///this should be a good starting point for you

  Stream<List<DocumentSnapshot>> radiusSearch() {
    Query<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection('locations');
    return geo
        .collection(collectionRef: collectionReference)
        .within(center: center!, radius: distanceInKm, field: 'position');
  }

  String parseLocation(DocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
    GeoPoint point = json['position']['geopoint'];
    return '${(Geolocator.distanceBetween(
          center!.latitude,
          center!.longitude,
          point.latitude,
          point.longitude,
        ) / 1000).toStringAsFixed(1)} km';
    // return 'name: [${point.latitude},${point.longitude}] - ${Geolocator.distanceBetween(
    //   center!.latitude,
    //   center!.longitude,
    //   point.latitude,
    //   point.longitude,
    // ).toStringAsFixed(2)}m';
  }

  Future checkPermissions() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  enableGeolocationStream() {
    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        distanceFilter: 10, //in meters
        timeLimit: Duration(seconds: 30),
      ),
    ).listen(
      (event) {
        print(event.latitude);
        print(event.longitude);
        currentPosition = event;
        center = Geoflutterfire().point(
          latitude: event.latitude,
          longitude: event.longitude,
        );
        FirebaseFirestore.instance
            .collection('locations')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'isEnable': true, 'position': center!.data});
        notifyListeners();
      },
    );
  }

  disableGeolocationStream() {
    FirebaseFirestore.instance
        .collection('locations')
        .doc(userUID)
        .update({'isEnable': false});
    positionStream?.cancel();
    currentPosition = null;
    positionStream = null;
    notifyListeners();
  }

  Future<Position?> getLastKnownPosition() {
    //you can try playing with forceAndroidLocationManager and the timeouts
    return Geolocator.getLastKnownPosition(forceAndroidLocationManager: false);
  }

  Future<Position?> getCurrentPosition() {
    //you can try playing with forceAndroidLocationManager and the timeouts
    return Geolocator.getCurrentPosition(
      forceAndroidLocationManager: true,
    );
  }

  saveLocationToDB() {}
}
