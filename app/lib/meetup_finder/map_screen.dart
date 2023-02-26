import 'dart:async';
import 'dart:math';
import 'package:geolocator/geolocator.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';

class MapScreen extends StatefulWidget {
  static const String route = '/multiicontap';

  const MapScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MapState();
  }
}

class _MapState extends State<MapScreen> {
  late final MapController _mapController;
  late final StreamSubscription _mapSubscription;
  List<LatLng> tappedPoints = [];
  List<LatLng> diamondPoints = [];
  List<LatLng> moneyPoints = [];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _mapSubscription = _mapController.mapEventStream.listen((event) async {
      print(await Geolocator.getCurrentPosition());
    });
    //Request permissions
    Geolocator.checkPermission().then((permission) async {
      print(permission);
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
    });
  }

  @override
  void dispose() {
    _mapSubscription.cancel();
    super.dispose();
  }

  void _centerMap() async {
    print(await Geolocator.getCurrentPosition());
    final currentLocation = await Geolocator.getCurrentPosition();
    LatLng locationLatLng =
        LatLng(currentLocation.latitude, currentLocation.longitude);
    _mapController.move(locationLatLng, _mapController.zoom);
  }

  @override
  Widget build(BuildContext context) {
    final runningMarkers = tappedPoints.map((latlng) {
      return Marker(
        width: 80,
        height: 80,
        point: latlng,
        // builder: (ctx) => const FlutterLogo(),
        builder: (ctx) => const Icon(Icons.run_circle),
      );
    }).toList();
    final dropMarkers = diamondPoints.map((latlng) {
      //TODO: Get cafes on board
      return Marker(
        width: 80,
        height: 80,
        point: latlng,
        // builder: (ctx) => const FlutterLogo(),
        builder: (ctx) => const Icon(Icons.diamond_outlined),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Meetup Map')),
      //drawer: buildDrawer(context, MapScreen.route),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Text('Click on markers for more info'),
            ),
            Flexible(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                    center: LatLng(51.507787, -0.089377),
                    zoom: 11,
                    onTap: _handleTap),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                  ),
                  MarkerLayer(markers: runningMarkers),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          IconButton(icon: Icon(Icons.place), onPressed: _centerMap),
    );
  }

  void _handleTap(TapPosition tapPosition, LatLng latlng) {
    setState(() {
      tappedPoints.add(latlng);
    });
  }
}
