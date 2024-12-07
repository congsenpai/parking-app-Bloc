import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class GoogleMapsService {
  final String apiKey = 'YOUR_GOOGLE_MAPS_API_KEY';  // Thay YOUR_GOOGLE_MAPS_API_KEY bằng API key của bạn

  // Yêu cầu quyền truy cập vị trí
  Future<void> requestLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      // Yêu cầu quyền nếu chưa được cấp
      await Permission.location.request();
    }
  }

  // Lấy vị trí hiện tại của người dùng
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Ensure permission is granted
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    // Proceed to get location if permission is granted
    return await Geolocator.getCurrentPosition();
  }


  // Tính khoảng cách từ điểm xuất phát đến đích
  Future<double> getDistance(double startLat, double startLng, double endLat, double endLng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=$startLat,$startLng&destination=$endLat,$endLng&key=$apiKey'
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Kiểm tra và lấy quãng đường từ phản hồi JSON
        if (data['status'] == 'OK') {
          final route = data['routes'][0];
          final leg = route['legs'][0];
          final distance = leg['distance']['value']; // Đơn vị là mét
          return distance / 1000;  // Chuyển sang km
        } else {
          throw Exception('Lỗi từ API: ${data['status']}');
        }
      } else {
        throw Exception('Lỗi khi lấy dữ liệu từ Google Maps API');
      }
    } catch (e) {
      //print('Lỗi: $e');
      return 0; // Trả về 0 nếu có lỗi
    }
  }

  // Tính khoảng cách từ vị trí hiện tại của người dùng đến điểm đích
  Future<double> getDistanceFromCurrentLocation(double endLat, double endLng) async {
    try {
      requestLocationPermission();
      Position currentPosition = await _getCurrentLocation();
      return await getDistance(currentPosition.latitude, currentPosition.longitude, endLat, endLng);
    } catch (e) {
      print('Lỗi khi lấy khoảng cách từ vị trí hiện tại: $e');
      return 0;
    }
  }
}
