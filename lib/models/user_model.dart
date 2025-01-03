import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_auth_provider/flutter_auth_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// ignore_for_file: avoid_print

// UserModel class definition
class UserModel {
  final String userID;
  final String username;
  final String email;
  final String phone;
  final String userImg;
  final String userDeviceToken;
  final String country;
  final String userAddress;
  final bool isAdmin;
  final bool isActive;
  final dynamic createdOn;
  final String city;
  final String vehicle;

  UserModel({
    required this.vehicle,
    required this.userID,
    required this.username,
    required this.email,
    required this.phone,
    required this.userImg,
    required this.userDeviceToken,
    required this.country,
    required this.userAddress,
    required this.isAdmin,
    required this.isActive,
    required this.createdOn,
    required this.city,
  });

  // Convert to Map for JSON encoding
  Map<String, dynamic> toMap() {
    return {
      'uId': userID,
      'username': username,
      'email': email,
      'phone': phone,
      'userImg': userImg,
      'userDeviceToken': userDeviceToken,
      'country': country,
      'userAddress': userAddress,
      'isAdmin': isAdmin,
      'isActive': isActive,
      'createdOn': createdOn,
      'city': city,
      'vehicle': vehicle,
    };
  }

  // Create UserModel from Map (JSON)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      vehicle: json['vehicle'] ?? 'null',
      userID: json['uId'] ?? 'null',
      username: json['username'] ?? 'null',
      email: json['email'] ?? 'null',
      phone: json['phone'] ?? 'null',
      userImg: json['userImg'] ?? 'null',
      userDeviceToken: json['userDeviceToken'] ?? 'null',
      country: json['country'] ?? 'null',
      userAddress: json['userAddress'] ?? 'null',
      isAdmin: json['isAdmin'] ?? 'null',
      isActive: json['isActive'] ?? 'null',
      createdOn: json['createdOn'] ?? 'null',
      city: json['city'] ?? 'null',
    );
  }
}

// Storage keys
const String userIdKey = 'uId';
const String usernameKey = 'username';
const String emailKey = 'email';
const String phoneKey = 'phone';
const String userImgKey = 'userImg';
const String userDeviceTokenKey = 'userDeviceToken';
const String countryKey = 'country';
const String userAddressKey = 'userAddress';
const String isAdminKey = 'isAdmin';
const String isActiveKey = 'isActive';
const String createdOnKey = 'createdOn';
const String cityKey = 'city';
const String vehicleKey = 'vehicle';
const String tokenKey = 'token';
const String refreshTokenKey = 'refreshToken';

class SecureStore implements AuthStore<UserModel>, TokenStore {
  static const SecureStore _instance = SecureStore._();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  const SecureStore._();

  factory SecureStore() => _instance;

  @override
  Future<void> delete() async {
    await _storage.delete(key: userIdKey);
    await _storage.delete(key: usernameKey);
    await _storage.delete(key: emailKey);
    await _storage.delete(key: phoneKey);
    await _storage.delete(key: userImgKey);
    await _storage.delete(key: userDeviceTokenKey);
    await _storage.delete(key: countryKey);
    await _storage.delete(key: userAddressKey);
    await _storage.delete(key: isAdminKey);
    await _storage.delete(key: isActiveKey);
    await _storage.delete(key: createdOnKey);
    await _storage.delete(key: cityKey);
    await _storage.delete(key: vehicleKey);
  }

  @override
  Future<UserModel?> retrieve() async {
    final uId = await _storage.read(key: userIdKey);
    final username = await _storage.read(key: usernameKey);
    final email = await _storage.read(key: emailKey);
    final phone = await _storage.read(key: phoneKey);
    final userImg = await _storage.read(key: userImgKey);
    final userDeviceToken = await _storage.read(key: userDeviceTokenKey);
    final country = await _storage.read(key: countryKey);
    final userAddress = await _storage.read(key: userAddressKey);
    final isAdmin = await _storage.read(key: isAdminKey) == 'true';
    final isActive = await _storage.read(key: isActiveKey) == 'true';
    final createdOn = await _storage.read(key: createdOnKey);
    final city = await _storage.read(key: cityKey);
    final vehicleJson = await _storage.read(key: vehicleKey);

    String vehicle = vehicleJson ?? '';





    if (uId != null && username != null) {
      return UserModel(
        vehicle: vehicle,
        userID: uId,
        username: username,
        email: email ?? '',
        phone: phone ?? '',
        userImg: userImg ?? '',
        userDeviceToken: userDeviceToken ?? '',
        country: country ?? '',
        userAddress: userAddress ?? '',
        isAdmin: isAdmin,
        isActive: isActive,
        createdOn: createdOn ?? '',
        city: city ?? '',
      );
    }
    return null;
  }

  @override
  Future<void> save(UserModel user) async {
    await _storage.write(key: userIdKey, value: user.userID);
    await _storage.write(key: usernameKey, value: user.username);
    await _storage.write(key: emailKey, value: user.email);
    await _storage.write(key: phoneKey, value: user.phone);
    await _storage.write(key: userImgKey, value: user.userImg);
    await _storage.write(key: userDeviceTokenKey, value: user.userDeviceToken);
    await _storage.write(key: countryKey, value: user.country);
    await _storage.write(key: userAddressKey, value: user.userAddress);
    await _storage.write(key: isAdminKey, value: user.isAdmin.toString());
    await _storage.write(key: isActiveKey, value: user.isActive.toString());
    await _storage.write(key: createdOnKey, value: user.createdOn.toString());
    await _storage.write(key: cityKey, value: user.city);

    // Serialize vehicle list into a JSON string before saving
    await _storage.write(key: vehicleKey, value: json.encode(user.vehicle));
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: tokenKey);
    await _storage.delete(key: refreshTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return _storage.read(key: refreshTokenKey);
  }

  @override
  Future<String?> getToken() async {
    return _storage.read(key: tokenKey);
  }

  @override
  Future<void> saveTokens({required String token, String? refreshToken}) async {
    await _storage.write(key: tokenKey, value: token);
    if (refreshToken != null) {
      await _storage.write(key: refreshTokenKey, value: refreshToken);
    }
  }
}

class UserProvider with ChangeNotifier {
  final SecureStore _secureStore = SecureStore();

  UserModel? _user;

  UserModel? get user => _user;

  bool get isLoggedIn => _user != null;

  // Phương thức đăng nhập
  Future<void> login(UserModel userModel) async {
    _user = userModel;
    await _secureStore
        .save(userModel); // Lưu thông tin người dùng vào SecureStore
    notifyListeners();
  }

  // Phương thức đăng xuất
  Future<void> logout() async {
    _user = null;
    await _secureStore.delete();
    await _secureStore.clear(); // Xóa thông tin người dùng khỏi SecureStore
    notifyListeners();
  }

  // Tải thông tin người dùng từ SecureStore
  Future<UserModel?> loadUser() async {
    try {
      _user = await _secureStore.retrieve();
      notifyListeners();
      return _user;
    } catch (e) {
      print("Error loading user: $e");
      return null;
    }
  }
}
