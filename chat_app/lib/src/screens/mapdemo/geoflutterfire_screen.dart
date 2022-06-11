import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
// import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';

class GeoFlutterFireScreen extends StatefulWidget {
  const GeoFlutterFireScreen({Key? key}) : super(key: key);

  @override
  State<GeoFlutterFireScreen> createState() => _GeoFlutterFireScreenState();
}

class _GeoFlutterFireScreenState extends State<GeoFlutterFireScreen> {
  double distanceInKm = 5;
  TextEditingController controller = TextEditingController(text: '5.0');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('GeoFlutterFire'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                'On this screen you can set the radius of the data search or add data to the db',
                textAlign: TextAlign.justify,
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (dContext) {
                        return const AddLocation();
                      });
                },
                child: const Text('Add Location'),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('locations')
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap) {
                    if (snap.hasData) {
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (DocumentSnapshot doc in snap.data!.docs)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(parseLocation(doc)),
                              )
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.greenAccent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: AppBar().preferredSize.height,
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Distance In KM',
                                textAlign: TextAlign.end,
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: controller,
                                keyboardType: TextInputType.number,
                                onChanged: (val) {
                                  if (mounted) {
                                    setState(() {
                                      distanceInKm =
                                          double.tryParse(val) ?? 5.0;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder(
                          stream: radiusSearch(),
                          builder: (context, AsyncSnapshot snap) {
                            if (snap.hasError) {
                              return Text('${snap.error}');
                            }
                            if (snap.hasData) {
                              return SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    for (DocumentSnapshot doc in snap.data)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(parseLocation(doc)),
                                      )
                                  ],
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // var result = await asyncQuerySearch();
                          // print(result);
                        },
                        child: const Text('Test Async'),
                      ),
                      Expanded(
                        child: FutureBuilder(
                          // future: asyncQuerySearch(),
                          builder: (context, AsyncSnapshot snap) {
                            print('FutureBuilder Rebuilding');
                            if (snap.hasError) {
                              return Text('${snap.error}');
                            }
                            if (snap.hasData) {
                              return SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    for (DocumentSnapshot doc in snap.data)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(parseLocation(doc)),
                                      )
                                  ],
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  final Geoflutterfire geo = Geoflutterfire();
  //Fuente Circle
  GeoFirePoint center =
      Geoflutterfire().point(latitude: 10.3151, longitude: 123.8855);

  ///so I would suggest adding a listener to store the data in a controller when the data is updated.
  ///this should be a good starting point for you

  Stream<List<DocumentSnapshot>> radiusSearch() {
    Query<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection('locations');
    return geo
        .collection(collectionRef: collectionReference)
        .within(center: center, radius: distanceInKm, field: 'position');
  }

  String parseLocation(DocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
    GeoPoint point = json['position']['geopoint'];
    return '${json['name']}: [${point.latitude},${point.longitude}] - ${Geolocator.distanceBetween(
      center.latitude,
      center.longitude,
      point.latitude,
      point.longitude,
    ).toStringAsFixed(2)}m';
  }
}

class AddLocation extends StatefulWidget {
  const AddLocation({Key? key}) : super(key: key);

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  TextEditingController lat = TextEditingController(),
      long = TextEditingController(),
      index = TextEditingController();
  final Geoflutterfire geo = Geoflutterfire();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: SizedBox(
                height: AppBar().preferredSize.height,
                child: Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text('Label'),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: index,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Flexible(
              child: SizedBox(
                height: AppBar().preferredSize.height,
                child: Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text('Latitude'),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: lat,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Flexible(
              child: SizedBox(
                height: AppBar().preferredSize.height,
                child: Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text('Longitude'),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: long,
                      ),
                    )
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                GeoFirePoint myLocation = geo.point(
                    latitude: double.tryParse(lat.text) ?? 10.3142,
                    longitude: double.tryParse(long.text) ?? 123.8811);
                final FirebaseFirestore firestore = FirebaseFirestore.instance;
                firestore
                    .collection('locations')
                    .add({'name': index.text, 'position': myLocation.data});
                Navigator.of(context).pop();
              },
              child: const Text('Add location'),
            )
          ],
        ),
      ),
    );
  }
}
