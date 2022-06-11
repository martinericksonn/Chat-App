import 'package:chat_app/src/screens/home/nearby_screen.dart';
import 'package:flutter/material.dart';

import 'geocoding_screen.dart';
import 'geoflutterfire_screen.dart';
import 'geolocation_screen.dart';

class HomeScreenGeo extends StatefulWidget {
  const HomeScreenGeo({Key? key}) : super(key: key);

  @override
  State<HomeScreenGeo> createState() => _HomeScreenGeoState();
}

class _HomeScreenGeoState extends State<HomeScreenGeo> {
  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        controller: controller,
        thumbVisibility: true,
        thickness: 16,
        child: PageView(
          controller: controller,
          children: [
            NearbyScreen(),
            GeolocationScreen(),
            GeocodingScreen(),
            GeoFlutterFireScreen(),
          ],
        ),
      ),
    );
  }
}
