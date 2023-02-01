import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';

class MapScreen extends StatefulWidget {
  static const String route = '/multiicontap';

  const MapScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MultiIconTapToAddPageState();
  }
}

class _MultiIconTapToAddPageState extends State<MapScreen> {
  List<LatLng> tappedPoints = [];
  List<LatLng> diamondPoints = [];
  List<LatLng> moneyPoints = [];

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
    );
  }

  void _handleTap(TapPosition tapPosition, LatLng latlng) {
    setState(() {
      tappedPoints.add(latlng);
    });
  }
}
