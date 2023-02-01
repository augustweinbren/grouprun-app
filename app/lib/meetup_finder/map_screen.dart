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
    final heartMarkers = tappedPoints.map((latlng) {
      return Marker(
        width: 80,
        height: 80,
        point: latlng,
        // builder: (ctx) => const FlutterLogo(),
        builder: (ctx) => const Icon(Icons.favorite_border),
      );
    }).toList();
    final diamondMarkers = diamondPoints.map((latlng) {
      return Marker(
        width: 80,
        height: 80,
        point: latlng,
        // builder: (ctx) => const FlutterLogo(),
        builder: (ctx) => const Icon(Icons.diamond_outlined),
      );
    }).toList();
    final moneyMarkers = moneyPoints.map((latlng) {
      return Marker(
        width: 80,
        height: 80,
        point: latlng,
        // builder: (ctx) => const FlutterLogo(),
        builder: (ctx) =>
            const Icon(Icons.architecture_outlined), //TODO: change
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Tap to add multi-icon pins')),
      //drawer: buildDrawer(context, MapScreen.route),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Text('Tap to add pins'),
            ),
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                    center: LatLng(45.5231, -122.6765),
                    zoom: 13,
                    onTap: _handleTap),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                  ),
                  MarkerLayer(markers: heartMarkers),
                  MarkerLayer(markers: diamondMarkers),
                  MarkerLayer(markers: moneyMarkers),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTap(TapPosition tapPosition, LatLng latlng) {
    int randNum = Random().nextInt(3);
    if (randNum == 0) {
      setState(() {
        tappedPoints.add(latlng);
      });
    } else if (randNum == 1) {
      setState(() {
        diamondPoints.add(latlng);
      });
    } else {
      setState(() {
        moneyPoints.add(latlng);
      });
    }
  }
}
