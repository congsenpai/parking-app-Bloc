import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // Đảm bảo bạn đang sử dụng latlong2 package
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class MapWidget extends StatefulWidget {
  final LatLng endPoint;
  final String apiKey = "9Gug0whGGq8v1H7AtidZcOGLbOV32mtm";

  MapWidget({required this.endPoint});

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  LatLng? currentLocation;
  List<LatLng> routePoints = [];
  StreamSubscription<Position>? positionStream;

  @override
  void initState() {
    super.initState();
    _startLocationUpdates();
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  void _startLocationUpdates() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 1, // Cập nhật khi di chuyển ít nhất 10m
    );

    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      LatLng newLocation = LatLng(position.latitude, position.longitude);
      setState(() {
        currentLocation = newLocation;
      });
      _fetchRoute(newLocation, widget.endPoint);
    });
  }

  Future<void> _fetchRoute(LatLng startPoint, LatLng endPoint) async {
    final url =
        "https://api.tomtom.com/routing/1/calculateRoute/${startPoint.latitude},${startPoint.longitude}:${endPoint.latitude},${endPoint.longitude}/json?key=${widget.apiKey}";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final routes = data['routes'] as List;
      if (routes.isNotEmpty) {
        final points = routes[0]['legs'][0]['points'] as List;
        setState(() {
          routePoints = points
              .map((point) => LatLng(point['latitude'], point['longitude']))
              .toList();
        });
      }
    } else {
      print("Error fetching route: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Real-Time Navigation'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: currentLocation == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : FlutterMap(
              options: MapOptions(
                initialCenter: currentLocation!,
                initialZoom: 17.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key=${widget.apiKey}",
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
                      point: currentLocation!,
                      child: Icon(
                        Icons.my_location,
                        color: Colors.green,
                        size: 40,
                      ),
                    ),
                    Marker(
                      point: widget.endPoint,
                      child: Icon(
                        Icons.flag,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
