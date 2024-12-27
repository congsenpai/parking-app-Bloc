import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // Đảm bảo bạn đang sử dụng latlong2 package
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class MapWidget {
  final String apiKey = "9Gug0whGGq8v1H7AtidZcOGLbOV32mtm";
  final LatLng endPoint;

  MapWidget({required this.endPoint});

  Future<LatLng?> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      print("Error getting current location: $e");
      return null;
    }
  }

  Future<List<LatLng>> fetchRoute(LatLng startPoint) async {
    final url =
        "https://api.tomtom.com/routing/1/calculateRoute/${startPoint.latitude},${startPoint.longitude}:${endPoint.latitude},${endPoint.longitude}/json?key=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final routes = data['routes'] as List;
      if (routes.isNotEmpty) {
        final points = routes[0]['legs'][0]['points'] as List;
        return points
            .map((point) => LatLng(point['latitude'], point['longitude']))
            .toList();
      }
    } else {
      print("Error fetching route: ${response.statusCode}");
    }
    return [];
  }

  Widget buildBasicMap(LatLng initialLocation) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: initialLocation,
        initialZoom: 17.0,
      ),
      children: [
        TileLayer(
          urlTemplate:
              "https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key=$apiKey",
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: initialLocation,
              child: Icon(
                Icons.my_location,
                color: Colors.green,
                size: 40,
              ),
            ),
            Marker(
              point: endPoint,
              child: Icon(
                Icons.flag,
                color: Colors.red,
                size: 40,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildRouteMap(LatLng initialLocation, List<LatLng> routePoints) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: initialLocation,
        initialZoom: 17.0,
      ),
      children: [
        TileLayer(
          urlTemplate:
              "https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key=$apiKey",
        ),
        if (routePoints.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: routePoints,
                color: Colors.blue,
                strokeWidth: 4.0,
              ),
            ],
          ),
        MarkerLayer(
          markers: [
            Marker(
              point: initialLocation,
              child: Icon(
                Icons.my_location,
                color: Colors.green,
                size: 40,
              ),
            ),
            Marker(
              point: endPoint,
              child: Icon(
                Icons.flag,
                color: Colors.red,
                size: 40,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class MapWidgetScreen extends StatefulWidget {
  final LatLng endPoint;

  MapWidgetScreen({required this.endPoint});

  @override
  _MapWidgetScreenState createState() => _MapWidgetScreenState();
}

class _MapWidgetScreenState extends State<MapWidgetScreen> {
  LatLng? currentLocation;
  List<LatLng> routePoints = [];
  late MapWidget mapWidget;

  @override
  void initState() {
    super.initState();
    mapWidget = MapWidget(endPoint: widget.endPoint);
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    currentLocation = await mapWidget.getCurrentLocation();
    if (currentLocation != null) {
      routePoints = await mapWidget.fetchRoute(currentLocation!);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multiple Views Map'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: currentLocation == null
          ? mapWidget.buildLoadingIndicator()
          : mapWidget.buildRouteMap(currentLocation!, routePoints),
    );
  }
}

class DistanceCalculator {
  /// Lấy vị trí hiện tại
  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Dịch vụ vị trí không khả dụng.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Quyền truy cập vị trí bị từ chối.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Quyền truy cập vị trí bị từ chối vĩnh viễn.");
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  /// Tính khoảng cách giữa hai điểm
  static double calculateDistance(LatLng start, LatLng end) {
    final Distance distance = Distance();
    return distance.as(
      LengthUnit.Meter,
      LatLng(start.latitude, start.longitude),
      LatLng(end.latitude, end.longitude),
    );
  }

  /// Tính khoảng cách từ vị trí hiện tại đến endPoint
  static Future<double> getDistanceToEndpoint(LatLng endPoint) async {
    try {
      Position currentPosition = await getCurrentLocation();
      LatLng currentLatLng =
          LatLng(currentPosition.latitude, currentPosition.longitude);

      double distance = calculateDistance(currentLatLng, endPoint);
      return distance;
    } catch (e) {
      throw Exception("Không thể tính khoảng cách: $e");
    }
  }
}
