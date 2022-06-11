import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import 'geolocation_screen.dart';

class GeocodingScreen extends StatefulWidget {
  const GeocodingScreen({Key? key}) : super(key: key);

  @override
  State<GeocodingScreen> createState() => _GeocodingScreenState();
}

class _GeocodingScreenState extends State<GeocodingScreen> {
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
        title: const Text('Geocoding'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                'So on this screen we are taking advantage of the controller made on the previous screen',
                textAlign: TextAlign.justify,
              ),
              const SizedBox(
                height: 32,
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
                      if (geoCon.currentPosition != null)
                        FutureBuilder(
                            future: placemarkFromCoordinates(
                                geoCon.currentPosition!.latitude,
                                geoCon.currentPosition!.longitude),
                            builder:
                                (context, AsyncSnapshot<List<Placemark>> snap) {
                              if (snap.hasData) {
                                return Text('${snap.data!.first}');
                              }
                              return Container();
                            }),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
