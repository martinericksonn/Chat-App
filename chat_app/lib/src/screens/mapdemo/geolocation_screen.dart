import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GeolocationScreen extends StatefulWidget {
  const GeolocationScreen({Key? key}) : super(key: key);

  @override
  State<GeolocationScreen> createState() => _GeolocationScreenState();
}

class _GeolocationScreenState extends State<GeolocationScreen> {
  Position? lastKnownPosition, currentPosition;

  final GeolocationController geoCon = GeolocationController();

  @override
  dispose() {
    geoCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Geolocation'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                lastKnownPosition != null
                    ? lastKnownPosition.toString()
                    : 'Last known position is null. Maybe set a position if you are on emulator?',
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    lastKnownPosition = await geoCon.getLastKnownPosition();
                    setState(() {});
                  } catch (e) {
                    print(e);
                  }
                },
                child: const Text('GetLastKnownLocation'),
              ),
              Text(
                currentPosition != null
                    ? currentPosition.toString()
                    : 'Current position is null. Maybe set a position if you are on emulator?',
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    currentPosition = await geoCon.getCurrentPosition();
                    setState(() {});
                  } catch (e) {
                    print(e);
                  }
                },
                child: const Text('GetCurrentPosition'),
              ),
              AnimatedBuilder(
                animation: geoCon,
                builder: (context, Widget? child) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        geoCon.currentPosition != null
                            ? geoCon.currentPosition.toString()
                            : 'Current position from stream is null. Maybe set a position route if you are on emulator?',
                        textAlign: TextAlign.center,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (geoCon.positionStream == null) {
                            geoCon.enableGeolocationStream();
                          } else {
                            geoCon.disableGeolocationStream();
                          }
                        },
                        child: Text(geoCon.positionStream == null
                            ? 'EnableLocationStream'
                            : 'DisableLocationStream'),
                      )
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GeolocationController with ChangeNotifier {
  bool serviceEnabled = false;
  LocationPermission? permission;
  StreamSubscription<Position>? positionStream;
  Position? currentPosition;

  GeolocationController() {
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
        distanceFilter: 100, //in meters
        timeLimit: Duration(seconds: 30),
      ),
    ).listen((event) {
      currentPosition = event;
      notifyListeners();
    });
  }

  disableGeolocationStream() {
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
    return Geolocator.getCurrentPosition(forceAndroidLocationManager: false);
  }
}
